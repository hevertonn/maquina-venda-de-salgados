library ieee;
  use ieee.std_logic_1164.all;

entity decodificador_7seg is
  port (
    digito    : in    std_logic_vector(3 downto 0);
    segmentos : out   std_logic_vector(6 downto 0)
  );
end entity decodificador_7seg;

architecture rtl of decodificador_7seg is

begin

  p_decodificador_7seg : process (digito) is
  begin

    -- Ordem dos bits: abcdefg. Padrao ativo em nivel baixo.
    case digito is

      when "0000" =>

        segmentos <= "0000001"; -- 0

      when "0001" =>

        segmentos <= "1001111"; -- 1

      when "0010" =>

        segmentos <= "0010010"; -- 2

      when "0011" =>

        segmentos <= "0000110"; -- 3

      when "0100" =>

        segmentos <= "1001100"; -- 4

      when "0101" =>

        segmentos <= "0100100"; -- 5

      when "0110" =>

        segmentos <= "0100000"; -- 6

      when "0111" =>

        segmentos <= "0001111"; -- 7

      when "1000" =>

        segmentos <= "0000000"; -- 8

      when "1001" =>

        segmentos <= "0000100"; -- 9

      when others =>

        segmentos <= "1111111"; -- apagado

    end case;

  end process p_decodificador_7seg;

end architecture rtl;
