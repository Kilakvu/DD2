library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity timer is
port(	clk: 		in std_logic;
	nRst: 		in std_logic;
	tic_125: 	buffer std_logic;
	tic_250:	buffer std_logic;
	tic_1s        : buffer std_logic;
    	tic_1ms       : buffer std_logic;
    	tic_5ms       : buffer std_logic
);
end entity;

architecture rtl of timer is
	signal cnt_div_125: std_logic_vector(23 downto 0);	--Contador modulo 6250000 para 8Hz -> 125ms
	constant contador_125: integer := 16#5F5E10#;		--Hexadecimal: 6250000
	signal f_div_250: std_logic;
	signal cnt_div_250: Std_logic_vector(2 downto 0);
begin

contador_125ms : process(clk,nRst)
begin
if nRst = '0' then
	cnt_div_125 <= (others => '0');
elsif clk'event and clk = '1' then
	if tic_125 = '1' then
	cnt_div_125 <= (others => '0');
	else
	cnt_div_125 <= cnt_div_125 + 1;
	end if;
end if;
end process contador_125ms;

tic_125 <= '1' when cnt_div_125 = contador_125 else	
			'0';
contador_250ms : process(clk,nRst)
begin
if nRst = '0' then
	cnt_div_250 <= (others => '0');
elsif clk'event and clk = '1' then
	if f_div_250 = '1' then
		if tic_250 = '1' then
		cnt_div_250 <= (others => '0');
		else
		cnt_div_250 <= cnt_div_250 + 1;
		end if;
	end if;
end if;
end process contador_250ms;

f_div_250 <= '1' when cnt_div_250 = 2 else
	   '0';
tic_250 <= '1' when f_div_250 = '1' and tic_125 = '1' else
  	   '0';


end rtl;
