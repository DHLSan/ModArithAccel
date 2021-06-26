--
-- EEM464 SoC lab 
--
-- Description: it converts a 4-bit data into ASCII character.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_ascii is
    port ( data      : in   std_logic_vector (3 downto 0);
           asciichar : out  std_logic_vector (7 downto 0));
end bcd_ascii;

architecture behavioral of bcd_ascii is
   type rom16x8 is array (0 to 15) of std_logic_vector (7 downto 0);
   constant bcdrom : rom16x8 := ( 
       std_logic_vector(to_unsigned(character'pos('0'),8)),
       std_logic_vector(to_unsigned(character'pos('1'),8)),
       std_logic_vector(to_unsigned(character'pos('2'),8)),
       std_logic_vector(to_unsigned(character'pos('3'),8)),
       std_logic_vector(to_unsigned(character'pos('4'),8)),
       std_logic_vector(to_unsigned(character'pos('5'),8)),
       std_logic_vector(to_unsigned(character'pos('6'),8)),
       std_logic_vector(to_unsigned(character'pos('7'),8)),
       std_logic_vector(to_unsigned(character'pos('8'),8)),
       std_logic_vector(to_unsigned(character'pos('9'),8)),
       std_logic_vector(to_unsigned(character'pos('a'),8)),
       std_logic_vector(to_unsigned(character'pos('b'),8)),
       std_logic_vector(to_unsigned(character'pos('c'),8)),
       std_logic_vector(to_unsigned(character'pos('d'),8)),
       std_logic_vector(to_unsigned(character'pos('e'),8)),
       std_logic_vector(to_unsigned(character'pos('f'),8)));
begin
   asciichar <= bcdrom(to_integer(unsigned(data)));
end behavioral;