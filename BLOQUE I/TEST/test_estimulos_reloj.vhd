library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.pack_test_reloj.all;

entity test_estimulos_reloj is
port(clk:     	  in std_logic;
     nRst:        in std_logic;
     tic_025s:    out std_logic;
     tic_1s:      out std_logic;
     ena_cmd:     out std_logic;
     cmd_tecla:   out std_logic_vector(3 downto 0);
     pulso_largo: out std_logic;
     modo:        in std_logic;
     segundos:    in std_logic_vector(7 downto 0);
     minutos:     in std_logic_vector(7 downto 0);
     horas:       in std_logic_vector(7 downto 0);
     AM_PM:       in std_logic;
     info:        in std_logic_vector(1 downto 0)
    );
end entity;

architecture test of test_estimulos_reloj is

begin
  -- Tic para el incremento continuo de campo. Escalado. 
  process
  begin
    tic_025s <= '0';
    for i in 1 to 3 loop
       wait until clk'event and clk = '1';
    end loop;

    tic_025s <= '1';
    wait until clk'event and clk = '1';

  end process;
  -- Tic de 1 seg. Escalado.
  process
  begin
    tic_1s <= '0';
    for i in 1 to 15 loop
       wait until clk'event and clk = '1';
    end loop;

    tic_1s <= '1';
    wait until clk'event and clk = '1';

  end process;


  process
  begin
    ena_cmd  <= '0';
    cmd_tecla <= (others => '0');
    pulso_largo <= '0';

    -- Esperamos el final del Reset
    wait until nRst'event and nRst = '1';
    
    for i in 1 to 9 loop
       wait until clk'event and clk = '1';
    end loop;

    -- Cuenta en formato de 12 horas
    wait until clk'event and clk = '1';





    --esperar_hora(horas, minutos, AM_PM, clk, '0', X"01"&X"58");
  
	-- Cambio de 12h a 24 horas
	
	--cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
	
	--VUELTA--
	--MODO 12h desde las 03:30AM a las 03:30AM del dia siguiente
	report("TEST DE CICLO ENTERO DE UN DIA");
	esperar_hora(horas, minutos, AM_PM, clk, '0', X"0330");
	esperar_hora(horas, minutos, AM_PM, clk, '0', X"0330");
	report("FIN **TEST DE CICLO ENTERO DE UN DIA**");
	--********************************************************

	--CAMBIO DE MODO 12h -> 24h y ciclo de vuelta
	report("TEST CAMBIAMOS MODO Y CICLO ENTERO DE UN DIA");
	--MODO 24h
	cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
	esperar_hora(horas, minutos, AM_PM, clk, '1', X"2055");
	esperar_hora(horas, minutos, AM_PM, clk, '1', X"2055");
	report("FIN ***TEST DE CICLO ENTERO DE UN DIA***");
	--**********************************************************

	--PRUEBA DE PASO A 24h EN EL MOMENTO EXACTO DE PASO DE AM-PM
	report("TEST AM-PM");
	--PONEMOS EL MODO 12h
	cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
	esperar_hora(horas, minutos, AM_PM, clk, '0', X"1159");
	--CAMBIAMOS A 24h
	cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
	esperar_hora(horas, minutos, AM_PM, clk, '1', X"1201");
	esperar_hora(horas, minutos, AM_PM, clk, '1', X"1201");
	report("FIN ***TEST AM-PM***");
	--********************************************************
	
	--ENTRAMOS EN MODO PROGRAMACION
	report("TEST MODO PROGRAMACION Y PROGRAMAR HORA");
	--ESTAMOS EN EL FORMATO 12h
	cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
	esperar_hora(horas, minutos, AM_PM, clk, '0', X"0109");
	entrar_modo_prog(pulso_largo,cmd_tecla,clk,15);
	programar_hora_inc_largo(pulso_largo,ena_cmd, cmd_tecla,horas,minutos, AM_PM, clk, '0', X"0804");
	--FORMATO 24h
	cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
	esperar_hora(horas, minutos, AM_PM, clk, '1', X"22"&X"30");
	report("Volvemos a modificar la hora haciendole pasar por los minutos 59 sin que modifique las horas");
	entrar_modo_prog(pulso_largo,cmd_tecla,clk,15);
	programar_hora_inc_corto(ena_cmd, cmd_tecla,horas,minutos, AM_PM, clk, '1', X"2220");
	cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
	
	esperar_hora(horas, minutos, AM_PM, clk, '0', X"10"&X"44");
	
	
	programar_hora_inc_corto (ena_cmd,cmd_tecla,horas,minutos,AM_PM,clk,'0', X"00"&X"03");
	-- FIN DEL TEST
	report("TEST COMPLETADO");
    assert false
    report "done"
  severity failure;
  end process;

end test;
