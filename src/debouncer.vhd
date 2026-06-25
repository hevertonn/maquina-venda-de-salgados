library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity debouncer is
  port (
    clk   : in    std_logic;
    botao : in    std_logic;
    pulso : out   std_logic
  );
end entity debouncer;

architecture rtl of debouncer is

  signal contador        : integer range 0 to 500000 := 0;
  signal estado_atual    : std_logic                 := '1';
  signal estado_anterior : std_logic                 := '1';

begin

  p_debouncer : process (clk) is
  begin

    if rising_edge(clk) then
      if (botao = estado_atual) then
        contador <= 0;
      else
        contador <= contador + 1;
        if (contador = 500000) then
          estado_atual <= botao;
          contador     <= 0;
        end if;
      end if;

      estado_anterior <= estado_atual;

      if (estado_anterior = '1' and estado_atual = '0') then
        pulso <= '1';
      else
        pulso <= '0';
      end if;
    end if;

  end process p_debouncer;

end architecture rtl;

