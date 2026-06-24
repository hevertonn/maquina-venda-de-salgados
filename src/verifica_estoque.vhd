library ieee;
  use ieee.std_logic_1164.all;

entity verifica_estoque is
  port (
    tipo_salgado : in    std_logic_vector(2 downto 0);
    estoque      : in    std_logic_vector(4 downto 0);
    tem_estoque  : out   std_logic
  );
end entity verifica_estoque;

architecture rtl of verifica_estoque is

  signal disponivel : std_logic;

begin

  p_verifica_estoque : process (tipo_salgado, estoque) is
  begin

    case tipo_salgado is

      when "001" =>

        disponivel <= estoque(0);

      when "010" =>

        disponivel <= estoque(1);

      when "011" =>

        disponivel <= estoque(2);

      when "100" =>

        disponivel <= estoque(3);

      when "101" =>

        disponivel <= estoque(4);

      when others =>

        disponivel <= '0';

    end case;

  end process p_verifica_estoque;

  tem_estoque <= disponivel;

end architecture rtl;
