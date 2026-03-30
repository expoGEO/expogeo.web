import 'package:expogeo/core/content/cultura_e_politica/cultura_e_politica.dart';
import 'package:expogeo/core/content/espacos_urbanos_e_rurais/espacos_urbanos_e_rurais.dart';
import 'package:expogeo/core/content/natureza_e_meio_ambiente/natureza_e_meio_ambiente.dart';
import 'package:expogeo/core/content/representacoes_espaciais/representacoes_espaciais.dart';
import 'package:expogeo/core/models/theme_model.dart';

class ThemeDataModel {
  static List<ThemeModel> themes = [
    representacoesEspaciais,
    naturezaMeioAmbiente,
    espacosUrbanosRurais,
    culturaPolitica,
  ];
}

enum ThemeEnum {
  representacoesEspaciais('representacoes-espaciais', 'Representações Espaciais'),
  naturezaMeioAmbiente('natureza-meio-ambiente', 'Natureza e Meio Ambiente'),
  espacosUrbanosRurais('espacos-urbanos-rurais', 'Espaços Urbanos e Rurais'),
  culturaPolitica('cultura-politica', 'Cultura e Política');

  final String value;
  final String name;

  const ThemeEnum(this.value, this.name);

  String get route => '/$value';

  String get id => switch (this) {
    ThemeEnum.representacoesEspaciais => 'RE',
    ThemeEnum.naturezaMeioAmbiente => 'NMA',
    ThemeEnum.espacosUrbanosRurais => 'EUR',
    ThemeEnum.culturaPolitica => 'CP',
  };

  static ThemeEnum fromName(String name) {
    try {
      return ThemeEnum.values.firstWhere((e) => e.name == name);
    } catch (_) {
      throw ArgumentError('Tema desconhecido: $name');
    }
  }
}

enum SubthemeEnum {
  // Representações Espaciais
  coordenadasGeograficas('coordenadas-geograficas', 'Coordenadas Geográficas'),
  compositorMapas('compositor-mapas', 'Compositor de Mapas'),
  fusoHorario('fuso-horario', 'Fuso Horário'),
  geotecnologias('geotecnologias', 'Geotecnologias'),
  historiaCartografia('historia-cartografia', 'História da Cartografia'),
  leituraMapas('leitura-mapas', 'Leitura de Mapas'),
  movimentosTerra('movimentos-terra', 'Movimentos da Terra'),
  pontosCardeais('pontos-cardeais', 'Pontos Cardeais'),

  // Natureza e Meio Ambiente
  poluicaoAgua('poluicao-agua', 'Poluição da Água'),
  poluicaoAr('poluicao-ar', 'Poluição do Ar'),
  desmatamento('desmatamento', 'Desmatamento'),
  queimadas('queimadas', 'Queimadas'),
  recursosMinerais('recursos-minerais', 'Recursos Minerais'),
  sustentabilidade('sustentabilidade', 'Sustentabilidade'),
  biomas('biomas', 'Biomas'),
  estruturasFormasRelevo('estruturas-formas-relevo', 'Estruturas e Formas do Relevo'),
  tempoClima('tempo-clima', 'Tempo e Clima'),
  tiposClimaticos('tipos-climaticos', 'Tipos Climáticos'),
  baciasHidrograficas('bacias-hidrograficas', 'Bacias Hidrográficas'),
  usoAgua('uso-agua', 'Uso da Água'),

  // Espaços Urbanos e Rurais
  espacoUrbanoBrasileiro('espaco-urbano-brasileiro', 'Espaço Urbano Brasileiro'),
  globalizacaoMobilidade('globalizacao-mobilidade', 'Globalização e Mobilidade'),
  industriaTransformacao('industria-transformacao', 'Indústria e Transformação'),
  espacoRuralBrasileiro('espaco-rural-brasileiro', 'Espaço Rural Brasileiro'),
  conflitosTerra('conflitos-terra', 'Conflitos pela Terra'),
  mercadoAgropecuario('mercado-agropecuario', 'Mercado Agropecuário'),

  // Cultura e Política
  geopolitica('geopolitica', 'Geopolítica'),
  censoDemografico('censo-demografico', 'Censo Demográfico'),
  regioesAdministrativas('regioes-administrativas', 'Regiões Administrativas'),
  populacao('populacao', 'População'),
  identidadesCulturais('identidades-culturais', 'Identidades Culturais'),
  povosOriginarios('povos-originarios', 'Povos Originários');

  final String value;
  final String name;

  const SubthemeEnum(this.value, this.name);

  ThemeEnum get theme => switch (this) {
    // Representações Espaciais
    SubthemeEnum.coordenadasGeograficas => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.compositorMapas => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.fusoHorario => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.geotecnologias => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.historiaCartografia => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.leituraMapas => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.movimentosTerra => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.pontosCardeais => ThemeEnum.representacoesEspaciais,

    // Natureza e Meio Ambiente
    SubthemeEnum.poluicaoAgua => ThemeEnum.naturezaMeioAmbiente,
    SubthemeEnum.poluicaoAr => ThemeEnum.naturezaMeioAmbiente,
    SubthemeEnum.desmatamento => ThemeEnum.naturezaMeioAmbiente,
    SubthemeEnum.queimadas => ThemeEnum.naturezaMeioAmbiente,
    SubthemeEnum.recursosMinerais => ThemeEnum.naturezaMeioAmbiente,
    SubthemeEnum.sustentabilidade => ThemeEnum.naturezaMeioAmbiente,
    SubthemeEnum.tempoClima => ThemeEnum.naturezaMeioAmbiente,
    SubthemeEnum.tiposClimaticos => ThemeEnum.naturezaMeioAmbiente,
    SubthemeEnum.baciasHidrograficas => ThemeEnum.naturezaMeioAmbiente,
    SubthemeEnum.usoAgua => ThemeEnum.naturezaMeioAmbiente,
    SubthemeEnum.biomas => ThemeEnum.naturezaMeioAmbiente,
    SubthemeEnum.estruturasFormasRelevo => ThemeEnum.naturezaMeioAmbiente,

    // Espaços Urbanos e Rurais
    SubthemeEnum.espacoUrbanoBrasileiro => ThemeEnum.espacosUrbanosRurais,
    SubthemeEnum.globalizacaoMobilidade => ThemeEnum.espacosUrbanosRurais,
    SubthemeEnum.industriaTransformacao => ThemeEnum.espacosUrbanosRurais,
    SubthemeEnum.espacoRuralBrasileiro => ThemeEnum.espacosUrbanosRurais,
    SubthemeEnum.conflitosTerra => ThemeEnum.espacosUrbanosRurais,
    SubthemeEnum.mercadoAgropecuario => ThemeEnum.espacosUrbanosRurais,

    // Cultura e Política
    SubthemeEnum.geopolitica => ThemeEnum.culturaPolitica,
    SubthemeEnum.censoDemografico => ThemeEnum.culturaPolitica,
    SubthemeEnum.regioesAdministrativas => ThemeEnum.culturaPolitica,
    SubthemeEnum.populacao => ThemeEnum.culturaPolitica,
    SubthemeEnum.identidadesCulturais => ThemeEnum.culturaPolitica,
    SubthemeEnum.povosOriginarios => ThemeEnum.culturaPolitica,
  };

  String get route => '/${theme.value}/$value';

  String get id => switch (this) {
    // Representações Espaciais
    SubthemeEnum.coordenadasGeograficas => 'RE_CG',
    SubthemeEnum.compositorMapas => 'RE_CM',
    SubthemeEnum.fusoHorario => 'RE_FH',
    SubthemeEnum.geotecnologias => 'RE_GT',
    SubthemeEnum.historiaCartografia => 'RE_HC',
    SubthemeEnum.leituraMapas => 'RE_LM',
    SubthemeEnum.movimentosTerra => 'RE_MOT',
    SubthemeEnum.pontosCardeais => 'RE_PC',

    // Natureza e Meio Ambiente
    SubthemeEnum.poluicaoAgua => 'NMA_PA',
    SubthemeEnum.poluicaoAr => 'NMA_PAR',
    SubthemeEnum.desmatamento => 'NMA_DES',
    SubthemeEnum.queimadas => 'NMA_QUE',
    SubthemeEnum.recursosMinerais => 'NMA_RM',
    SubthemeEnum.sustentabilidade => 'NMA_SUS',
    SubthemeEnum.tempoClima => 'NMA_TC',
    SubthemeEnum.tiposClimaticos => 'NMA_TPCL',
    SubthemeEnum.baciasHidrograficas => 'NMA_BH',
    SubthemeEnum.usoAgua => 'NMA_UA',
    SubthemeEnum.biomas => 'NMA_BIO',
    SubthemeEnum.estruturasFormasRelevo => 'NMA_EFR',

    // Espaços Urbanos e Rurais
    SubthemeEnum.espacoUrbanoBrasileiro => 'EUR_EUB',
    SubthemeEnum.globalizacaoMobilidade => 'EUR_GM',
    SubthemeEnum.industriaTransformacao => 'EUR_IT',
    SubthemeEnum.espacoRuralBrasileiro => 'EUR_ERB',
    SubthemeEnum.conflitosTerra => 'EUR_CT',
    SubthemeEnum.mercadoAgropecuario => 'EUR_MA',

    // Cultura e Política
    SubthemeEnum.geopolitica => 'CP_GP',
    SubthemeEnum.censoDemografico => 'CP_CD',
    SubthemeEnum.regioesAdministrativas => 'CP_RA',
    SubthemeEnum.populacao => 'CP_POP',
    SubthemeEnum.identidadesCulturais => 'CP_IC',
    SubthemeEnum.povosOriginarios => 'CP_PO',
  };

  static SubthemeEnum fromName(String name) {
    try {
      return SubthemeEnum.values.firstWhere((e) => e.name == name);
    } catch (_) {
      throw ArgumentError('Subtema desconhecido: $name');
    }
  }
}
