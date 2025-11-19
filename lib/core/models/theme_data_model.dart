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
  representacoesEspaciais('representacoes-espaciais'),
  naturezaMeioAmbiente('natureza-meio-ambiente'),
  espacosUrbanosRurais('espacos-urbanos-rurais'),
  culturaPolitica('cultura-politica');

  final String value;
  const ThemeEnum(this.value);

  String get route => '/$value';
}

enum SubthemeEnum {
  // Representações Espaciais
  coordenadasGeograficas('coordenadas-geograficas'),
  compositorMapas('compositor-mapas'),
  fusoHorario('fuso-horario'),
  geotecnologias('geotecnologias'),
  historiaCartografia('historia-cartografia'),
  leituraMapas('leitura-mapas'),
  movimentosTerra('movimentos-terra'),
  pontosCardeais('pontos-cardeais'),

  // Natureza e Meio Ambiente
  poluicaoAgua('poluicao-agua'),
  poluicaoAr('poluicao-ar'),
  desmatamento('desmatamento'),
  queimadas('queimadas'),
  recursosMinerais('recursos-minerais'),
  sustentabilidade('sustentabilidade'),
  biomas('biomas'),
  estruturasFormasRelevo('estruturas-formas-relevo'),
  tempoClima('tempo-clima'),
  tiposClimaticos('tipos-climaticos'),
  baciasHidrograficas('bacias-hidrograficas'),
  usoAgua('uso-agua'),

  // Espaços Urbanos e Rurais
  espacoUrbanoBrasileiro('espaco-urbano-brasileiro'),
  globalizacaoMobilidade('globalizacao-mobilidade'),
  industriaTransformacao('industria-transformacao'),
  espacoRuralBrasileiro('espaco-rural-brasileiro'),
  conflitosTerra('conflitos-terra'),
  mercadoAgropecuario('mercado-agropecuario'),

  // Cultura e Política
  geopolitica('geopolitica'),
  censoDemografico('censo-demografico'),
  regioesAdministrativas('regioes-administrativas'),
  demografia('demografia'),
  identidadesCulturais('identidades-culturais'),
  povosOriginarios('povos-originarios');

  final String value;
  const SubthemeEnum(this.value);

  ThemeEnum get theme => switch (this) {
    SubthemeEnum.coordenadasGeograficas => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.compositorMapas => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.fusoHorario => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.geotecnologias => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.historiaCartografia => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.leituraMapas => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.movimentosTerra => ThemeEnum.representacoesEspaciais,
    SubthemeEnum.pontosCardeais => ThemeEnum.representacoesEspaciais,
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
    SubthemeEnum.espacoUrbanoBrasileiro => ThemeEnum.espacosUrbanosRurais,
    SubthemeEnum.globalizacaoMobilidade => ThemeEnum.espacosUrbanosRurais,
    SubthemeEnum.industriaTransformacao => ThemeEnum.espacosUrbanosRurais,
    SubthemeEnum.espacoRuralBrasileiro => ThemeEnum.espacosUrbanosRurais,
    SubthemeEnum.conflitosTerra => ThemeEnum.espacosUrbanosRurais,
    SubthemeEnum.mercadoAgropecuario => ThemeEnum.espacosUrbanosRurais,
    SubthemeEnum.geopolitica => ThemeEnum.culturaPolitica,
    SubthemeEnum.censoDemografico => ThemeEnum.culturaPolitica,
    SubthemeEnum.regioesAdministrativas => ThemeEnum.culturaPolitica,
    SubthemeEnum.demografia => ThemeEnum.culturaPolitica,
    SubthemeEnum.identidadesCulturais => ThemeEnum.culturaPolitica,
    SubthemeEnum.povosOriginarios => ThemeEnum.culturaPolitica,
  };

  String get route => '/${theme.value}/$value';
}
