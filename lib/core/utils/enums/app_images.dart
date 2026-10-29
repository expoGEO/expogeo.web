import "package:expogeo/core/utils/string/string_utils.dart";

enum AppImages {
  logoSimple(ImageFormat.png),
  logo(ImageFormat.png),
  capes,
  cnpq,
  faced,
  fapemig,
  observatorio(ImageFormat.png),
  ppged,
  ufu,
  baciasHidrograficas,
  biomas,
  censoDemografico,
  compositorMapas,
  conflitosTerra,
  coordenadasGeograficas,
  culturaPolitica,
  desmatamento,
  espacoRuralBrasleiro,
  espacoUrbanoBrasileiro,
  espacosUrbanoRural,
  estruturasFormasRelevo,
  fusoHorario,
  geopolitica,
  geotecnologias,
  globalizacaoMobilidade,
  historiaCartografia,
  identidadesCulturais,
  industriasTransformacoes,
  leituraMapas,
  meioAmbienteNatureza,
  mercadoAgropecuario,
  movimentosTerra,
  poluicaoAgua,
  poluicaoAr,
  pontosCardeais,
  populacao,
  povosOriginarios,
  queimadas,
  recursosMinerais,
  regioesBrasileiras,
  representacoesEspaciais,
  sustentabilidade,
  tempoClima,
  tiposClimaticos,
  usoAgua;

  const AppImages([this.format = ImageFormat.webp]);

  final ImageFormat format;

  String get path => "assets/images/${convertToSnakeCase(name)}.${format.name}";
}

enum ImageFormat { png, webp }
