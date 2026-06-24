library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tabela_precos is
  port (
    tipo_salgado   : in    std_logic_vector(2 downto 0);
    preco          : out   std_logic_vector(4 downto 0);
    produto_valido : out   std_logic
  );
end entity tabela_precos;

architecture rtl of tabela_precos is

begin

  p_tabela_precos : process (tipo_salgado) is
  begin

    produto_valido <= '1';

    case tipo_salgado is

      when "001" =>

        preco <= std_logic_vector(to_unsigned(10, 5)); -- R$ 2,50

      when "010" =>

        preco <= std_logic_vector(to_unsigned(6, 5));  -- R$ 1,50

      when "011" =>

        preco <= std_logic_vector(to_unsigned(3, 5));  -- R$ 0,75

      when "100" =>

        preco <= std_logic_vector(to_unsigned(14, 5)); -- R$ 3,50

      when "101" =>

        preco <= std_logic_vector(to_unsigned(8, 5));  -- R$ 2,00

      when others =>

        preco          <= (others => '0');
        produto_valido <= '0';

    end case;

  end process p_tabela_precos;

end architecture rtl;
