----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2021 15:03:21
-- Design Name: 
-- Module Name: modular_barret - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


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

entity modular_barret is
port( 
            x : in std_logic_vector(31 downto 0);
            y : in std_logic_vector(31 downto 0);
            z : out std_logic_vector(15 downto 0):=(others => '0');
            clk : in std_logic;
            start : in std_logic;
            done1 : out std_logic;
            reset : in std_logic
            );
end modular_barret;

architecture Behavioral of modular_barret is
type my_States is (idle,barret1,barret2,barret3,barret4,barret5,barret6,loop_state, finish);
		signal state_reg,state_next : my_States := idle;
		 
                       constant k                                       :integer:=21;--2^k
                       constant q                                       :unsigned(12 downto 0):="1111000000001";--7681--q
                       constant m                                       :unsigned(8 downto 0):="100010001";--273--((2^k)/q)=m
                       signal   t                                       :unsigned(72 downto 0);
                      signal   t_reg                                    :unsigned(72 downto 0);
                      signal   y_reg,z_reg2,z_reg3                      :unsigned(85 downto 0);  
                      signal   z_reg                                    :unsigned(63 downto 0);
                     

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
                    state_reg     <= barret1;
                    
                 when loop_state =>   
                       z_reg<=resize(z_reg3,64);
                      state_reg<=barret2; 
                    
                when barret1=>
                     z_reg <=(unsigned(x)* unsigned(y))  ;          
                    state_reg<=barret2;  
   
                when barret2=>
                    t_reg<=z_reg*m;  
                    state_reg<=barret3;  
                when barret3=>  
                     t<=  t_reg srl k  ; 
                     state_reg<=barret4;  
                when barret4=>
                     y_reg<=  t*q;
                     state_reg<=barret5;
                when barret5=>
                     z_reg2<=z_reg-y_reg;
                     state_reg<= barret6;   
                when barret6=>
                      if(z_reg2>=q) then
                        z_reg3<= z_reg2 - q;
                       state_reg<=loop_state;
                      else
                        
                        z<=std_logic_vector(resize(z_reg2,16));  
                          done1         <= '1';
                          state_reg<=finish;
                      end if;
                when finish=>
                       state_reg<=finish;   
                end case;
            end if;
        end if;
    end process;

end Behavioral;
