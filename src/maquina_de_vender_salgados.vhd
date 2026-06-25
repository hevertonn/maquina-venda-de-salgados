library ieee;
  use ieee.std_logic_1164.all;

entity maquina_de_vender_salgados is
  port (
    clk                    : in    std_logic;
    reset                  : in    std_logic;
    moeda_in               : in    std_logic_vector(1 downto 0);
    tipo_salgado           : in    std_logic_vector(2 downto 0);
    confirma_moeda         : in    std_logic;
    desiste                : in    std_logic;
    estoque                : in    std_logic_vector(4 downto 0);
    segmentos_unidade      : out   std_logic_vector(6 downto 0);
    segmentos_centavos     : out   std_logic_vector(6 downto 0);
    libera_salgado         : out   std_logic;
    libera_troco           : out   std_logic;
    libera_todas_as_moedas : out   std_logic;
    moeda_recusada         : out   std_logic;
    sem_estoque            : out   std_logic;
    estado_debug           : out   std_logic_vector(2 downto 0)
  );
end entity maquina_de_vender_salgados;

architecture struct of maquina_de_vender_salgados is

  component comparador_valor is
    port (
      soma_atual       : in    std_logic_vector(4 downto 0);
      preco            : in    std_logic_vector(4 downto 0);
      valor_suficiente : out   std_logic;
      tem_troco        : out   std_logic;
      troco            : out   std_logic_vector(4 downto 0)
    );
  end component comparador_valor;

  component conversor_display is
    port (
      soma_atual      : in    std_logic_vector(4 downto 0);
      digito_unidade  : out   std_logic_vector(3 downto 0);
      digito_centavos : out   std_logic_vector(3 downto 0)
    );
  end component conversor_display;

  component debouncer is
    port (
      clk   : in    std_logic;
      botao : in    std_logic;
      pulso : out   std_logic
    );
  end component debouncer;

  component decodificador_7seg is
    port (
      digito    : in    std_logic_vector(3 downto 0);
      segmentos : out   std_logic_vector(6 downto 0)
    );
  end component decodificador_7seg;

  component decodificador_moeda is
    port (
      moeda_in       : in    std_logic_vector(1 downto 0);
      valor_moeda    : out   std_logic_vector(4 downto 0);
      moeda_presente : out   std_logic
    );
  end component decodificador_moeda;

  component somador_moedas is
    port (
      clk           : in    std_logic;
      reset         : in    std_logic;
      limpa_soma    : in    std_logic;
      habilita_soma : in    std_logic;
      valor_moeda   : in    std_logic_vector(4 downto 0);
      soma_atual    : out   std_logic_vector(4 downto 0)
    );
  end component somador_moedas;

  component tabela_precos is
    port (
      tipo_salgado   : in    std_logic_vector(2 downto 0);
      preco          : out   std_logic_vector(4 downto 0);
      produto_valido : out   std_logic
    );
  end component tabela_precos;

  component unidade_controle is
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
  end component unidade_controle;

  component verifica_estoque is
    port (
      tipo_salgado : in    std_logic_vector(2 downto 0);
      estoque      : in    std_logic_vector(4 downto 0);
      tem_estoque  : out   std_logic
    );
  end component verifica_estoque;

  signal sig_soma_atual       : std_logic_vector(4 downto 0);
  signal sig_preco            : std_logic_vector(4 downto 0);
  signal sig_valor_suficiente : std_logic;
  signal sig_tem_troco        : std_logic;
  signal sig_digito_unidade   : std_logic_vector(3 downto 0);
  signal sig_digito_centavos  : std_logic_vector(3 downto 0);
  signal sig_valor_moeda      : std_logic_vector(4 downto 0);
  signal sig_moeda_presente   : std_logic;
  signal sig_limpa_soma       : std_logic;
  signal sig_habilita_soma    : std_logic;
  signal sig_produto_valido   : std_logic;
  signal sig_tem_estoque      : std_logic;
  signal sig_confirma_moeda   : std_logic;
  signal sig_desiste          : std_logic;
  signal sig_reset            : std_logic;

begin

  comparador_valor_inst : component comparador_valor
    port map (
      soma_atual       => sig_soma_atual,
      preco            => sig_preco,
      valor_suficiente => sig_valor_suficiente,
      tem_troco        => sig_tem_troco,
      troco            => open
    );

  conversor_display_inst : component conversor_display
    port map (
      soma_atual      => sig_soma_atual,
      digito_unidade  => sig_digito_unidade,
      digito_centavos => sig_digito_centavos
    );

  debouncer_confirma_moeda_inst : component debouncer
    port map (
      clk   => clk,
      botao => confirma_moeda,
      pulso => sig_confirma_moeda
    );

  debouncer_desiste_inst : component debouncer
    port map (
      clk   => clk,
      botao => desiste,
      pulso => sig_desiste
    );

  debouncer_reset_inst : component debouncer
    port map (
      clk   => clk,
      botao => reset,
      pulso => sig_reset
    );

  decodificador_7seg_unidade_inst : component decodificador_7seg
    port map (
      digito    => sig_digito_unidade,
      segmentos => segmentos_unidade
    );

  decodificador_7seg_centavos_inst : component decodificador_7seg
    port map (
      digito    => sig_digito_centavos,
      segmentos => segmentos_centavos
    );

  decodificador_moeda_inst : component decodificador_moeda
    port map (
      moeda_in       => moeda_in,
      valor_moeda    => sig_valor_moeda,
      moeda_presente => sig_moeda_presente
    );

  somador_moedas_inst : component somador_moedas
    port map (
      clk           => clk,
      reset         => sig_reset,
      limpa_soma    => sig_limpa_soma,
      habilita_soma => sig_habilita_soma,
      valor_moeda   => sig_valor_moeda,
      soma_atual    => sig_soma_atual
    );

  tabela_precos_inst : component tabela_precos
    port map (
      tipo_salgado   => tipo_salgado,
      preco          => sig_preco,
      produto_valido => sig_produto_valido
    );

  unidade_controle_inst : component unidade_controle
    port map (
      clk                    => clk,
      reset                  => sig_reset,
      produto_valido         => sig_produto_valido,
      tem_estoque            => sig_tem_estoque,
      confirma_moeda         => sig_confirma_moeda,
      moeda_presente         => sig_moeda_presente,
      valor_suficiente       => sig_valor_suficiente,
      tem_troco              => sig_tem_troco,
      desiste                => sig_desiste,
      habilita_soma          => sig_habilita_soma,
      limpa_soma             => sig_limpa_soma,
      libera_salgado         => libera_salgado,
      libera_troco           => libera_troco,
      libera_todas_as_moedas => libera_todas_as_moedas,
      moeda_recusada         => moeda_recusada,
      sem_estoque            => sem_estoque,
      estado_debug           => estado_debug
    );

  verifica_estoque_inst : component verifica_estoque
    port map (
      tipo_salgado => tipo_salgado,
      estoque      => estoque,
      tem_estoque  => sig_tem_estoque
    );

end architecture struct;
