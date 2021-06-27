----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2021 18:41:24
-- Design Name: 
-- Module Name: barret_test - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity barret_test is
--  Port ( );
end barret_test;

architecture Behavioral of barret_test is
-- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT modular_barret
    PORT(
         x : IN  std_logic_vector(31 downto 0);
         y : IN  std_logic_vector(31 downto 0);
         z : OUT  std_logic_vector(15 downto 0);
         clk : IN  std_logic;
         start : IN  std_logic;
         done1 : OUT  std_logic;
         reset : IN  std_logic
        );
    END COMPONENT;
     --Inputs
      signal x : std_logic_vector(31 downto 0) := (others => '0');
      signal y : std_logic_vector(31 downto 0) := (others => '0');
      signal clk : std_logic := '0';
      signal start : std_logic := '0';
      signal reset : std_logic := '0';
   
        --Outputs
      signal z : std_logic_vector(15 downto 0);
      signal done1 : std_logic;
   
      -- Clock period definitions
      constant clk_period : time := 10 ns;
    
begin
-- Instantiate the Unit Under Test (UUT)
   uut: modular_barret PORT MAP (
          x => x,
          y => y,
          z => z,
          clk => clk,
          start => start,
          done1 => done1,
          reset => reset
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
     -- hold reset state for 100 ns.
  
   x<="11111111111111111111111111111111";--4294967295
   y<="11111111111111111111111111111111";--4294967295
		wait for 100 ns;
          start <= '1';
				
        wait for 800 ns;
		  
            start <= '0';
             reset<='1';
            
        wait for 100 ns;
            start <= '1';
            reset<='0';
   

      wait;
   end process;


end Behavioral;
