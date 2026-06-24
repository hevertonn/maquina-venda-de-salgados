library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity decodificador_moeda is
  port (
    moeda_in       : in    std_logic_vector(1 downto 0);
    valor_moeda    : out   std_logic_vector(4 downto 0);
    moeda_presente : out   std_logic
  );
end entity decodificador_moeda;

architecture rtl of decodificador_moeda is

begin

  p_decodificador_moeda : process (moeda_in) is
  begin

    case moeda_in is

      when "00" =>

        valor_moeda    <= std_logic_vector(to_unsigned(0, 5));
        moeda_presente <= '0';

      when "01" =>

        valor_moeda    <= std_logic_vector(to_unsigned(1, 5)); -- R$ 0,25
        moeda_presente <= '1';

      when "10" =>

        valor_moeda    <= std_logic_vector(to_unsigned(2, 5)); -- R$ 0,50
        moeda_presente <= '1';

      when others =>

        valor_moeda    <= std_logic_vector(to_unsigned(4, 5)); -- R$ 1,00
        moeda_presente <= '1';

    end case;

  end process p_decodificador_moeda;

end architecture rtl;
