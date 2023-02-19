library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_timer is
end entity;

architecture test of test_timer is
  signal clk:     std_logic;
  signal nRst:    std_logic;
  signal tic_1ms: std_logic;
  signal tic_5ms: std_logic;
  signal tic_125ms: std_logic;
  signal tic_250ms: std_logic;
  signal tic_1s: std_logic;
  signal end_simulation: boolean := false;
  
  -- modifique la siguiente constante para un reloj de 12 MHz
  constant T_clk: time := 100 ns;
  
begin
dut: entity Work.timer(rtl)
     port map(clk       => clk,
              nRst      => nRst,
              tic_1ms => tic_1ms,
              tic_125ms => tic_125ms,
              tic_250ms => tic_250ms,
              tic_5ms => tic_5ms,
              tic_1s => tic_1s);
              
-- reloj de 12 MHz
process
begin
  clk <= '0';
  wait for T_clk/2;
  clk <= '1';
  wait for T_clk/2;  
  if end_simulation = true then
    wait;
  end if;
end process;

-- Secuencia de test
process
begin
  -- Secuencia de reset
  nRst <= '0'; 
  wait until clk'event and clk = '1';
  wait until clk'event and clk = '1';
  nRst <= '0';                         -- Reset inactivo
  wait until clk'event and clk = '1';
  nRst <= '1';                         -- Reset activo
  wait until clk'event and clk = '1';
                       -- Reset inactivo
  --Fin de secuencia de reset

  wait until clk'event and clk = '1';
  --wait until tic_125ms = '1';
 wait until tic_1s = '1';
 wait until clk'event and clk = '1';
 wait until tic_1s = '1';
 wait until clk'event and clk = '1';
  -- Complete el test para que puedan observarse
  -- 5 períodos de reloj ed la salida f_out_2
 end_simulation <= true; 
 assert(false) report "FIN" severity failure;
  -- Complete el test para que puedan observarse
  -- 5 períodos de reloj ed la salida f_div_50
  
  
  
  
  
  
end process;

end test;