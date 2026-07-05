library ieee;
  use ieee.std_logic_1164.all;

entity unidade_controle is
  port (
    clk                    : in    std_logic;
    reset                  : in    std_logic;
    produto_valido         : in    std_logic;
    tem_estoque            : in    std_logic;
    confirma_moeda         : in    std_logic;
    moeda_presente         : in    std_logic;
    valor_suficiente       : in    std_logic;
    tem_troco              : in    std_logic;
    desiste                : in    std_logic;
    habilita_soma          : out   std_logic;
    limpa_soma             : out   std_logic;
    libera_salgado         : out   std_logic;
    libera_troco           : out   std_logic;
    libera_todas_as_moedas : out   std_logic;
    moeda_recusada         : out   std_logic;
    sem_estoque            : out   std_logic;
    estado_debug           : out   std_logic_vector(2 downto 0)
  );
end entity unidade_controle;

architecture rtl of unidade_controle is

  type estado_t is (
    espera_escolha,
    verifica_estoque,
    aviso_sem_estoque,
    recebe_moedas,
    verifica_valor,
    estado_libera_salgado,
    estado_libera_troco,
    devolve_moedas
  );

  signal estado_atual, proximo_estado : estado_t;

  signal contador       : integer range 0 to 50000000 := 0;
  signal habilita_timer : std_logic;
  signal timer_pronto   : std_logic;

begin

  p_timer : process (clk, reset) is
  begin

    if (reset = '1') then
      contador     <= 0;
      timer_pronto <= '0';
    elsif rising_edge(clk) then
      if (habilita_timer = '1') then
        if (contador >= 50000000) then
          timer_pronto <= '1';
          contador     <= 0;
        else
          contador     <= contador + 1;
          timer_pronto <= '0';
        end if;
      else
        contador     <= 0;
        timer_pronto <= '0';
      end if;
    end if;

  end process p_timer;

  p_atualiza_estado : process (clk, reset) is
  begin

    if (reset = '1') then
      estado_atual <= espera_escolha;
    elsif rising_edge(clk) then
      estado_atual <= proximo_estado;
    end if;

  end process p_atualiza_estado;

  p_proximo_estado : process (
                              estado_atual,
                              produto_valido,
                              tem_estoque,
                              confirma_moeda,
                              moeda_presente,
                              valor_suficiente,
                              tem_troco,
                              desiste,
                              timer_pronto
                             ) is
  begin

    proximo_estado <= estado_atual;

    habilita_soma          <= '0';
    limpa_soma             <= '0';
    libera_salgado         <= '0';
    libera_troco           <= '0';
    libera_todas_as_moedas <= '0';
    moeda_recusada         <= '0';
    sem_estoque            <= '0';
    habilita_timer         <= '0';

    case estado_atual is

      when espera_escolha =>

        limpa_soma <= '1';

        if (produto_valido = '1') then
          proximo_estado <= verifica_estoque;
        end if;

      when verifica_estoque =>

        if (tem_estoque = '1') then
          proximo_estado <= recebe_moedas;
        else
          proximo_estado <= aviso_sem_estoque;
        end if;

      when aviso_sem_estoque =>

        sem_estoque    <= '1';
        habilita_timer <= '1';

        if (timer_pronto = '1') then
          proximo_estado <= espera_escolha;
        end if;

      when recebe_moedas =>

        if (desiste = '1') then
          proximo_estado <= devolve_moedas;
        elsif (confirma_moeda = '1') then
          if (moeda_presente = '1') then
            habilita_soma  <= '1';
            proximo_estado <= verifica_valor;
          else
            moeda_recusada <= '1';
          end if;
        end if;

      when verifica_valor =>

        if (valor_suficiente = '1') then
          proximo_estado <= estado_libera_salgado;
        else
          proximo_estado <= recebe_moedas;
        end if;

      when estado_libera_salgado =>

        libera_salgado <= '1';
        habilita_timer <= '1';

        if (timer_pronto = '1') then
          if (tem_troco = '1') then
            proximo_estado <= estado_libera_troco;
          else
            proximo_estado <= espera_escolha;
          end if;
        end if;

      when estado_libera_troco =>

        libera_troco   <= '1';
        habilita_timer <= '1';

        if (timer_pronto = '1') then
          proximo_estado <= espera_escolha;
        end if;

      when devolve_moedas =>

        libera_todas_as_moedas <= '1';
        limpa_soma             <= '1';
        habilita_timer         <= '1';

        if (timer_pronto = '1') then
          proximo_estado <= espera_escolha;
        end if;

    end case;

  end process p_proximo_estado;

  p_estado_debug : process (estado_atual) is
  begin

    case estado_atual is

      when espera_escolha =>

        estado_debug <= "000";

      when verifica_estoque =>

        estado_debug <= "001";

      when aviso_sem_estoque =>

        estado_debug <= "010";

      when recebe_moedas =>

        estado_debug <= "011";

      when verifica_valor =>

        estado_debug <= "100";

      when estado_libera_salgado =>

        estado_debug <= "101";

      when estado_libera_troco =>

        estado_debug <= "110";

      when devolve_moedas =>

        estado_debug <= "111";

    end case;

  end process p_estado_debug;

end architecture rtl;
