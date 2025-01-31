library ieee;
use ieee.std_logic_1164.all;


entity tb_crc16_sid is
end entity tb_crc16_sid;



architecture TB_CRC16 of tb_crc16_sid is

	
	signal i_clk			: std_logic;
	signal i_reset_p		: std_logic := '0';
	signal i_init			: std_logic := '0';
	signal i_data			: std_logic_vector( 7 downto 0 ) := x"00";
	signal i_ena_pulse		: std_logic := '0';
	signal o_crc_value		: std_logic_vector(15 downto 0 );

	constant waitdly		: time := 5.0 ns;



procedure SHIFT_THIS
(
	constant thisByte	: in	std_logic_vector( 7 downto 0 );
	signal i_data		: out	std_logic_vector( 7 downto 0 );
	signal i_ena_pulse	: out	std_logic
) is
begin
	i_data			<= thisByte;
	i_ena_pulse		<= '1';
	wait for waitdly;
	i_ena_pulse		<= '0';
	wait for waitdly * 16;
end procedure SHIFT_THIS;


begin


process begin
	i_clk	<= '0';
	wait for waitdly / 2;
	i_clk	<= '1';
	wait for waitdly / 2;
end process;


uut: entity work.CRC16_Top
port map
(
	i_clk			=> i_clk			,
	i_reset_p		=> i_reset_p		,
	i_init			=> i_init			,
	i_data			=> i_data			,
	i_ena_pulse		=> i_ena_pulse		,
	o_crc_value		=> o_crc_value		
);


process begin
	wait for waitdly * 10;
	i_reset_p	<= '1';
	wait for waitdly;
	i_reset_p	<= '0';
	wait for waitdly * 10;
	

	
	i_init		<= '1';
	wait for waitdly;
	i_init		<= '0';
--	wait for waitdly;

	SHIFT_THIS( x"07", i_data, i_ena_pulse );
	SHIFT_THIS( x"30", i_data, i_ena_pulse );
	SHIFT_THIS( x"00", i_data, i_ena_pulse );
	SHIFT_THIS( x"00", i_data, i_ena_pulse );
	SHIFT_THIS( x"00", i_data, i_ena_pulse );

	wait;
end process;



end TB_CRC16;