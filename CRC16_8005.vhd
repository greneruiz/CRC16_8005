-- ==============================================================
-- File Name: CRC16_8005.vhd
-- Type     : CRC-16-IBM algorithm
-- Purpose  : General-purpose
-- Version  : 2.0
-- ==============================================================
-- Revision History
-- Version/Date : V1.0 / 2024-Apr-03 / G.RUIZ
--     * This is an initial release - simulated
-- ==============================================================
--	Polynomial: 0x8005 ( x^16 + x^15 + x^2 + 1 )
--	Start Value: 0x0000
-- ==============================================================
--	Instructions:
--		Toggle reset before use to initialize x = 0x0000.
--		Feed data serially *MSB-FIRST*, with I_BIT_VALID = '1'
--			for 1 I_CLK cycle.
--		Get O_CRC_VALUE after feeding the last serial data bit.
-- ==============================================================




library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity CRC16_8005 is
port
(
	i_clk			: in	std_logic;
	i_resetp		: in	std_logic;
	i_bit_data		: in	std_logic;
	i_bit_valid		: in	std_logic;
	o_crc_value		: out	std_logic_vector(15 downto 0 )
);
end entity CRC16_8005;




-- ==============================================================
architecture RTL_CRC16 of CRC16_8005 is
-- ==============================================================

	
	signal x		: std_logic_vector(15 downto 0 ) := x"0000";



-- ==============================================================
begin
-- ==============================================================


--//	Polynomial: 0x8005 ( x^16 + x^15 + x^2 + 1 )	//
--//	Start Value: 0x0000								//

process( i_clk )
begin
	if rising_edge( i_clk ) then
		if i_resetp = '1' then
			x				<= x"0000";
			
		elsif i_bit_valid = '1' then
			x(0)			<= x(15) xor i_bit_data;
			x(1)			<= x(0);
			x(2)			<= x(1) xor x(15) xor i_bit_data;
			x(14 downto 3)	<= x(13 downto 2);
			x(15)			<= x(14) xor x(15) xor i_bit_data;
		end if;
	end if;
end process;


	o_crc_value	<= x;




-- ==============================================================
end RTL_CRC16;
-- ==============================================================