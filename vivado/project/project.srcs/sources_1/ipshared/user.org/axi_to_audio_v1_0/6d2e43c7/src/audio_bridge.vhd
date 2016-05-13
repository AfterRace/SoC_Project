----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2016 12:12:43 PM
-- Design Name: 
-- Module Name: audio_bridge - Behavioral
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

entity audio_bridge is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           audio_in_l : in STD_LOGIC_VECTOR (23 downto 0);
           audio_in_r : in STD_LOGIC_VECTOR (23 downto 0);
           audio_in_valid : in STD_LOGIC;
           audio_out_l : out STD_LOGIC_VECTOR (23 downto 0);
           audio_out_r : out STD_LOGIC_VECTOR (23 downto 0);
           audio_out_valid : out STD_LOGIC);
end audio_bridge;

architecture Behavioral of audio_bridge is

begin
			
    audio_out_l <= audio_in_l;
    audio_out_r <= audio_in_r;
    audio_out_valid <= audio_in_valid;    

end Behavioral;
