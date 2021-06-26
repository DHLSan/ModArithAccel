library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;
--use ieee.std_logic_arith.all;
use ieee.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fixed_number is
port( 
            x : in std_logic_vector(63 downto 0);
            z : out std_logic_vector(15 downto 0):=(others => '0');
            clk : in std_logic;
            start : in std_logic;
            done1 : out std_logic;
            reset : in std_logic
            );
end fixed_number;

architecture Behavioral of fixed_number is
type my_States is (idle,fixed1,fixed2,fixed3,fixed4,fixed5,fixed6,fixed7,fixed8,fixed9,fixed10,loop_state, finish);
		signal state_reg,state_next : my_States := idle;
		 
                      
                      constant  q                                                                         :unsigned(12 downto 0):="1111000000001";--7681--q
                      signal    z_reg_1,z_reg_2,z_reg_3,z_reg_4,z_reg_5,z_reg_6,z_reg_7,z_reg_8,z_reg_9   :unsigned(127 downto 0);
                      signal    z_reg_0                                                                   :unsigned(63 downto 0);
begin
process(clk,reset)
    begin 
    if rising_edge(clk) then 
        if (reset='1') then 
            state_reg<= idle;
        elsif (start = '1' and reset='0') then   

            case state_reg is

                when idle =>
                    done1         <= '0';
                    z           <=(others=>'0');                  
                    state_reg     <= fixed1;
                    
                 when loop_state =>   
                      z_reg_0<=resize(z_reg_9,64);
                      state_reg<=fixed2; 
                    
                when fixed1=>
                     z_reg_0 <=(unsigned(x))  ;          
                    state_reg<=fixed2;  
   
                when fixed2=>
                    z_reg_1<=resize(z_reg_0 sll 8,128); 
                    state_reg<=fixed3; 
                     
                when fixed3=>  
                     z_reg_2<=resize(  z_reg_0 sll 4, 128)  ; 
                     state_reg<=fixed4;
                       
                when fixed4=>
                     z_reg_3 <=resize( z_reg_1 + z_reg_2 + z_reg_0,128);
                     state_reg<=fixed5;
                     
                when fixed5=>
                     z_reg_4<=resize( z_reg_3 srl 21 ,128);
                     state_reg<= fixed6; 
                     
                when fixed6=>           
                     z_reg_5<=resize( z_reg_4 sll 13 , 128) ;
                     state_reg<= fixed7;
                     
                when fixed7=>           
                     z_reg_6<=resize (z_reg_4 sll 9 , 128) ;
                     state_reg<= fixed8;
                     
                when fixed8=>           
                     z_reg_7<=resize((z_reg_5 - z_reg_6) + z_reg_4 , 128);
                     state_reg<= fixed9;  
                                                  
                when fixed9=>           
                     z_reg_8<= resize( z_reg_0 - z_reg_7 , 128);
                     state_reg<= fixed10;    
                                         
                when fixed10=>
                      if(z_reg_8>=q) then
                        z_reg_9<=resize(z_reg_8 - q , 128);
                       state_reg<=loop_state;
                      else
                        z<=std_logic_vector(resize(z_reg_8,16));  
                          done1         <= '1';
                          state_reg<=finish;
                      end if;
                 when finish =>
                        state_reg<=finish   ;  
                 
                end case;
            end if;
        end if;
    end process;

end Behavioral;