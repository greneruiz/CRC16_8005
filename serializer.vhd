--===================================================================
-- File Name: serializer.vhd
-- Type     : RTL
-- Purpose  : 
-- Version  : 1.0
--===================================================================
-- Revision History
-- Version/Date : V1.0 / 2025-Jan-31 / G.RUIZ
--		* Initial release
--===================================================================




library ieee;
use ieee.std_logic_1164.all;


entity serializer is
generic( LENGTH : integer := 8 );
port
(
	i_clk		: in	std_logic;
	i_rst		: in	std_logic;									-- '1' = Reset; Always toggle first
	i_ena		: in	std_logic;									-- Shift Enable
	i_d			: in	std_logic_vector( LENGTH - 1 downto 0 );	-- Floating input
	o_q			: out	std_logic := '0';							-- Serialized output
	o_valid		: out	std_logic := '0'							-- Output valid
);
end entity serializer;



architecture RTL_SERIALIZER of serializer is


	signal s_ptr	: integer range 0 to LENGTH;


begin


process( i_clk, i_rst )
begin
	if i_rst = '1' then
		s_ptr		<= LENGTH;
		o_q			<= '0';
		o_valid		<= '0';
	elsif rising_edge( i_clk ) then
		if i_ena = '1' then
			if s_ptr > 0 then
				s_ptr	<= s_ptr - 1;
				o_valid	<= i_ena;
				o_q		<= i_d( s_ptr -1 );
			else
				o_valid	<= '0';
			end if;

		else
			o_valid	<= '0';
		end if;
	end if;
end process;


end RTL_SERIALIZER;