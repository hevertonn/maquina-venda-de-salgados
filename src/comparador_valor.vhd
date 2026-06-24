library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity comparador_valor is
  port (
    soma_atual       : in    std_logic_vector(4 downto 0);
    preco            : in    std_logic_vector(4 downto 0);
    valor_suficiente : out   std_logic;
    tem_troco        : out   std_logic;
    troco            : out   std_logic_vector(4 downto 0)
  );
end entity comparador_valor;

architecture rtl of comparador_valor is

begin

  p_comparador_valor : process (soma_atual, preco) is

    variable soma_u  : unsigned(4 downto 0);
    variable preco_u : unsigned(4 downto 0);

  begin

    soma_u  := unsigned(soma_atual);
    preco_u := unsigned(preco);

    if (soma_u >= preco_u) then
      valor_suficiente <= '1';
    else
      valor_suficiente <= '0';
    end if;

    if (soma_u > preco_u) then
      tem_troco <= '1';
      troco     <= std_logic_vector(soma_u - preco_u);
    else
      tem_troco <= '0';
      troco     <= (others => '0');
    end if;

  end process p_comparador_valor;

end architecture rtl;
