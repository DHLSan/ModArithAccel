--
-- EEM464 SoC Lab 
--
-- Description: Top level controller that controls the OLED display.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mod_mul_with_oled is
    port (  clk         : in std_logic;
            rst         : in std_logic;
            sw_in       : in std_logic_vector(7 downto 0);
            en          : in std_logic; 
            oled_sdin   : out std_logic;
            oled_sclk   : out std_logic;
            oled_dc     : out std_logic;
            oled_res    : out std_logic;
            oled_vbat   : out std_logic;
            oled_vdd    : out std_logic);
end mod_mul_with_oled;

architecture behavioral of mod_mul_with_oled is

component modular_barret is port(
	       x : in std_logic_vector(31 downto 0);
           y : in std_logic_vector(31 downto 0);
           z : out std_logic_vector(15 downto 0):=(others => '0');
           clk : in std_logic;
           start : in std_logic;
           done1 : out std_logic;
           reset : in std_logic
    );
    end component;

    component debounce IS
  GENERIC(
    counter_size  :  INTEGER := 20); --counter size (19 bits gives 10.5ms with 50MHz clock)
  PORT(
    clk     : IN  STD_LOGIC;  --input clock
    button  : IN  STD_LOGIC;  --input signal to be debounced
    result  : OUT STD_LOGIC); --debounced signal
END component;

    component oled_init is
        port (  clk         : in std_logic;
                rst         : in std_logic;
                en          : in std_logic;
                sdout       : out std_logic;
                oled_sclk   : out std_logic;
                oled_dc     : out std_logic;
                oled_res    : out std_logic;
                oled_vbat   : out std_logic;
                oled_vdd    : out std_logic;
                fin         : out std_logic);
    end component;

    component oled_drive is
        port (  clk         : in std_logic;
                rst         : in std_logic;
                en          : in std_logic;
                a_reg       : in std_logic_vector(15 downto 0);
                b_reg       : in std_logic_vector(15 downto 0);
                n_reg       : in std_logic_vector(15 downto 0);
                z_reg       : in std_logic_vector(15 downto 0);
                sdout       : out std_logic;
                oled_sclk   : out std_logic;
                oled_dc     : out std_logic;
                fin         : out std_logic);
    end component;

    type states is (Idle, OledInitialize, LoadA_0,load_empty,wait_state, OledExample, OledExample2, WaitMult, Done);

    signal current_state, next_state : states := Idle;

     signal x                :std_logic_vector(31 downto 0) := (others => '0');
     signal y                :std_logic_vector(31 downto 0) := (others => '0');
     signal z                :std_logic_vector(15 downto 0):= (others => '0');
     signal start2           : std_logic :='0';
     signal done2            : std_logic;
     
     
      signal z_1                :std_logic_vector(15 downto 0):= (others => '0') ;
      


    signal init_en          : std_logic := '0';
    signal init_done        : std_logic;
    signal init_sdata       : std_logic;
    signal init_spi_clk     : std_logic;
    signal init_dc          : std_logic;

    signal example_en       : std_logic := '0';
    signal example_sdata    : std_logic;
    signal example_spi_clk  : std_logic;
    signal example_dc       : std_logic;
    signal example_done     : std_logic;
    
    signal a_reg : std_logic_vector(15 downto 0) := (others => '0');
    signal b_reg : std_logic_vector(15 downto 0) := (others => '0');
    signal n_reg : std_logic_vector(15 downto 0) := (others => '0');
    signal z_reg : std_logic_vector(15 downto 0) := (others => '0');
    signal ready_mult : std_logic;
    signal start_mult : std_logic := '0';

    signal en_db : std_logic;

begin

    Debouncing: debounce port map(clk, en, en_db);

    Initialize: oled_init port map (clk,
                                    rst,
                                    init_en,
                                    init_sdata,
                                    init_spi_clk,
                                    init_dc,
                                    oled_res,
                                    oled_vbat,
                                    oled_vdd,
                                    init_done);

    Drive_OLED_Screen: oled_drive port map ( clk,
                                            rst,
                                            example_en,
                                            a_reg,
                                            b_reg,
                                            n_reg,
                                            z_reg,
                                            example_sdata,
                                            example_spi_clk,
                                            example_dc,
                                            example_done);
barret :         modular_barret port map(      x,
                                               y,
                                               z,
                                              clk,
                                              start2,
                                              done2,
                                              rst);  
    -- MUXes to indicate which outputs are routed out depending on which block is enabled
    oled_sdin <= init_sdata when current_state = OledInitialize else example_sdata;
    oled_sclk <= init_spi_clk when current_state = OledInitialize else example_spi_clk;
    oled_dc <= init_dc when current_state = OledInitialize else example_dc;
    -- End output MUXes

    -- MUXes that enable blocks when in the proper states
    init_en <= '1' when current_state = OledInitialize else '0';
    example_en <= '1' when current_state = OledExample  else
                  '1' when current_state = OledExample2 else '0';
    -- End enable MUXes
    x<="11111111111111111111111111111111";--4294967295
    y<="11111111111111111111111111111111";--4294967295
   process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                current_state <= Idle;
                start_mult <= '0';
                z_1<= (others => '0');
                start2<='0';
            else
                case current_state is
                    when Idle =>
                        start2<='1';
                        next_state<= load_empty;
                        current_state <= load_empty;
                        a_reg <=(others=>'0');
                        b_reg<=(others=>'0');
                        n_reg <=(others=>'0');
                        z_reg<=(others=>'0');
                    -- Go through the initialization sequence
                    when OledInitialize =>
                        if init_done = '1' then
                            current_state <= OledExample;
                            --next_state <= Done;
                        end if;
                        
                    -- Do example and do nothing when finished
                     when OledExample =>
                         if example_done = '1' then
                             current_state <= wait_state;
                             
                         end if;
                     when wait_state=>
                          if en='0' then
                           current_state<=next_state;
                          else
                          current_state<=wait_state;
                          end if;        
                     
                      when load_empty=>
                          if done2='1' then 
                            z_1<=  z; 
                            current_state <= LoadA_0;  
                           else
                            current_state <= load_empty; 
                          end if;
                     
                     
                     when LoadA_0 =>
                          
                         if en = '1'  then 
                             a_reg<=z_1;
                             next_state<=  Done;
                             current_state <= OledInitialize;    
                             else
                             current_state <= LoadA_0;                     
                         end if;    
                    
                    when Done =>
                        current_state <= Done;
                    when others =>
                        current_state <= Idle;
                end case;
            end if;
        end if;
    end process;
    
    
    
     --------------------------------------------------------------
     -- You also need to instantiate ModMult.vhd component here. --
     --------------------------------------------------------------
    
    -- start_mult is required to start the operation of the modular multiplication
    -- ready_mult is control signal which indicates that the modulo multiplication completes its operation.
    -- z_reg is the result value taken from your Modulo Multiplier hardware IP core.
    -- All other parameters required for the multiplier circuit might be a constant in your ModMult.vhd file.


end behavioral;
