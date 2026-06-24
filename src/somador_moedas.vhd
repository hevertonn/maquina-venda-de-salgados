library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity somador_moedas is
  port (
    clk           : in    std_logic;
    reset         : in    std_logic;
    limpa_soma    : in    std_logic;
    habilita_soma : in    std_logic;
    valor_moeda   : in    std_logic_vector(4 downto 0);
    soma_atual    : out   std_logic_vector(4 downto 0)
  );
end entity somador_moedas;

architecture rtl of somador_moedas is

  signal soma_reg : unsigned(4 downto 0);

begin

  p_somador_moedas : process (clk, reset) is
  begin

    if (reset = '1') then
      soma_reg <= (others => '0');
    elsif rising_edge(clk) then
      if (limpa_soma = '1') then
        soma_reg <= (others => '0');
      elsif (habilita_soma = '1') then
        soma_reg <= soma_reg + unsigned(valor_moeda);
      end if;
    end if;

  end process p_somador_moedas;

  soma_atual <= std_logic_vector(soma_reg);

end architecture rtl;
