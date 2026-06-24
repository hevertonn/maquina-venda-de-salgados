library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity conversor_display is
  port (
    soma_atual      : in    std_logic_vector(4 downto 0);
    digito_unidade  : out   std_logic_vector(3 downto 0);
    digito_centavos : out   std_logic_vector(3 downto 0)
  );
end entity conversor_display;

architecture rtl of conversor_display is

begin

  p_conversor_display : process (soma_atual) is

    variable valor        : integer range 0 to 31;
    variable unidade      : integer range 0 to 7;
    variable resto_quarto : integer range 0 to 3;
    variable centavos     : integer range 0 to 9;

  begin

    valor        := to_integer(unsigned(soma_atual));
    unidade      := valor / 4;
    resto_quarto := valor mod 4;

    case resto_quarto is

      when 0 =>

        centavos := 0;

      when 1 =>

        centavos := 2;                                             -- representa R$ 0,25

      when 2 =>

        centavos := 5;                                             -- representa R$ 0,50

      when others =>

        centavos := 7;                                             -- representa R$ 0,75

    end case;

    digito_unidade  <= std_logic_vector(to_unsigned(unidade, 4));
    digito_centavos <= std_logic_vector(to_unsigned(centavos, 4));

  end process p_conversor_display;

end architecture rtl;
