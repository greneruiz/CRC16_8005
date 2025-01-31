--===================================================================
-- File Name: CRC16_Top.vhd
-- Type     : RTL
-- Purpose  : CRC16 Processor - 0x8005 Polynomial
-- Version  : 1.0
--===================================================================
-- Revision History
-- Version/Date : V1.0 / 2025-Jan-31 / G.RUIZ
--		* Initial release
--===================================================================



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;


entity CRC16_Top is
generic
(
	REFLECT_IN		: boolean := TRUE;								-- If true, input bit order is swapped
	REFLECT_OUT		: boolean := TRUE								-- If true, output bits order is swapped
);
port
(
	i_clk			: in	std_logic;								-- System clock
	i_reset_p		: in	std_logic;								-- Global reset; '1' = reset
	i_init			: in	std_logic;								-- Initialize pulse; must be triggered before every calculation
	i_data			: in	std_logic_vector( 7 downto 0 );			-- Byte input
	i_ena_pulse		: in	std_logic;								-- Valid pulse for byte input
	o_crc_value		: out	std_logic_vector(15 downto 0 )			-- CRC16 output. Process time: 13 CLK cycles from I_ENA_PULSE
);
end entity CRC16_Top;



architecture RTL_CRC_TOP of CRC16_Top is

	signal s_ena			: std_logic;
	signal s_init			: std_logic;
	signal s_data			: std_logic_vector( 7 downto 0 );

	signal s_crc_valid		: std_logic;
	signal s_crc_value		: std_logic_vector(15 downto 0 );
	signal s_crc_input		: std_logic;
	signal s_crc_ena		: std_logic;
	signal s_crc_ena_p		: std_logic_vector( 7 downto 0 );
	


begin


process( i_clk )													-- REFLECT_IN REGISTER
begin
	if rising_edge( i_clk ) then
		s_ena		<= i_ena_pulse;
		s_init		<= i_init;
		
		if REFLECT_IN = TRUE then
			for i in 7 downto 0 loop
				s_data(i)	<= i_data(7 - i);
			end loop;
		else
			s_data	<= i_data;
		end if;
		
	end if;
end process;


process( i_clk )
begin
	if rising_edge( i_clk ) then
		s_crc_ena_p(0)			<= s_ena;
		
		for i in 0 to 6 loop
			s_crc_ena_p(i + 1)	<= s_crc_ena_p(i);
		end loop;
		
		s_crc_ena		<= OR_REDUCE( s_crc_ena_p );
	end if;
end process;


ser: entity work.serializer
generic map( LENGTH => 8 )
port map
(
	i_clk			=> i_clk,
	i_rst			=> i_reset_p or s_ena,							-- '1' = Reset; Always toggle first
	i_ena			=> s_crc_ena,									-- Shift Enable
	i_d				=> s_data,										-- Floating input
	o_q				=> s_crc_input,									-- Serialized output
	o_valid			=> s_crc_valid									-- Output valid
);


crc: entity work.CRC16_8005
port map
(
	i_clk			=> i_clk,
	i_resetp		=> i_reset_p or s_init,
	i_bit_data		=> s_crc_input,
	i_bit_valid		=> s_crc_valid,
	o_crc_value		=> s_crc_value
);


process( i_clk )													-- REFLECT_OUT REGISTER
begin
	if rising_edge( i_clk ) then
		if REFLECT_OUT = TRUE then
			for i in 15 downto 0 loop
				o_crc_value(i)	<= s_crc_value(15 - i);
			end loop;
		else
			o_crc_value	<= s_crc_value;
		end if;
	end if;
end process;


end RTL_CRC_TOP;