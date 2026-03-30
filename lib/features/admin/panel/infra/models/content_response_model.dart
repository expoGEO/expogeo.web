import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

/// Modelo de resposta para conteúdo do Firestore
/// Estende ContentModel adicionando o ID do documento
class ContentResponseModel extends ContentModel {
  /// ID do documento no Firestore
  final String docId;

  const ContentResponseModel({
    required this.docId,
    required super.id,
    required super.theme,
    required super.subtheme,
    required super.intellectualIndicator,
    required super.contentInfo,
    required super.originInfo,
    required super.registrationInfo,
    required super.rightsInfo,
    super.preservationAction,
  });

  /// Converte ContentModel para ContentResponseModel
  factory ContentResponseModel.fromContentModel({
    required ContentModel content,
    required String docId,
  }) {
    return ContentResponseModel(
      docId: docId,
      id: content.id,
      theme: content.theme,
      subtheme: content.subtheme,
      intellectualIndicator: content.intellectualIndicator,
      contentInfo: content.contentInfo,
      originInfo: content.originInfo,
      registrationInfo: content.registrationInfo,
      rightsInfo: content.rightsInfo,
      preservationAction: content.preservationAction,
    );
  }

  /// Converte para JSON para salvar no Firestore
  Map<String, dynamic> toJson() => {
    'id': id,
    'themeId': theme.value,
    'subthemeId': subtheme.value,
    'intellectualIndicator': intellectualIndicator.toJson(),
    'contentInfo': contentInfo.toJson(),
    'originInfo': originInfo.toJson(),
    'registrationInfo': registrationInfo.toJson(),
    'rightsInfo': rightsInfo.toJson(),
    if (preservationAction != null) 'preservationAction': preservationAction!.toJson(),
  };

  /// Factory para criar a partir do JSON do Firestore
  /// Suporta tanto valores de enum quanto IDs Firestore
  factory ContentResponseModel.fromJson(Map<String, dynamic> json, String docId) {
    try {
      // Converte string em enum - suporta tanto valor enum quanto ID Firestore
      final themeValue = json['themeId'] as String;
      final subthemeValue = json['subthemeId'] as String;

      final theme = _themeFromStringOrId(themeValue);
      final subtheme = _subthemeFromStringOrId(subthemeValue);

      return ContentResponseModel(
        docId: docId,
        id: json['id'] as String,
        theme: theme,
        subtheme: subtheme,
        intellectualIndicator: IntellectualIndicator.fromJson(
          json['intellectualIndicator'] as Map<String, dynamic>,
        ),
        contentInfo: ContentInfo.fromJson(json['contentInfo'] as Map<String, dynamic>),
        originInfo: OriginInfo.fromJson(json['originInfo'] as Map<String, dynamic>),
        registrationInfo: RegistrationInfo.fromJson(
          json['registrationInfo'] as Map<String, dynamic>,
        ),
        rightsInfo: RightsInfo.fromJson(json['rightsInfo'] as Map<String, dynamic>),
        preservationAction: json['preservationOperation'] != null
            ? PreservationAction.fromJson(json['preservationAction'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      rethrow;
    }
  }
}

/// Converte um valor string (valor de enum ou ID Firestore) para ThemeEnum
ThemeEnum _themeFromStringOrId(String value) {
  // Tenta primeiro como valor de enum (ex: "cultura-politica")
  try {
    return ThemeEnum.values.firstWhere((e) => e.value == value);
  } catch (_) {
    // Se não encontrar, tenta como ID Firestore (ex: "CP", "EUR", "NMA", "RE")
    final mapping = {
      'CP': ThemeEnum.culturaPolitica,
      'EUR': ThemeEnum.espacosUrbanosRurais,
      'NMA': ThemeEnum.naturezaMeioAmbiente,
      'RE': ThemeEnum.representacoesEspaciais,
    };
    return mapping[value.toUpperCase()] ?? ThemeEnum.representacoesEspaciais;
  }
}

/// Converte um valor string (valor de enum ou ID Firestore) para SubthemeEnum
SubthemeEnum _subthemeFromStringOrId(String value) {
  // Tenta primeiro como valor de enum (ex: "censo-demografico")
  try {
    return SubthemeEnum.values.firstWhere((e) => e.value == value);
  } catch (_) {
    // Se não encontrar, tenta como ID Firestore (ex: "CP_CD", "EUR_IND")
    // Mapeamento baseado nos dados reais uploadados ao Firestore
    final mapping = {
      // Cultura e Política (CP)
      'CP_CD': SubthemeEnum.censoDemografico,
      'CP_GP': SubthemeEnum.geopolitica,
      'CP_IC': SubthemeEnum.identidadesCulturais,
      'CP_POP': SubthemeEnum.populacao,
      'CP_PO': SubthemeEnum.povosOriginarios,
      'CP_RA': SubthemeEnum.regioesAdministrativas,
      // Espaços Urbanos e Rurais (EUR)
      'EUR_CT': SubthemeEnum.conflitosTerra,
      'EUR_EUB': SubthemeEnum.espacoUrbanoBrasileiro,
      'EUR_ERB': SubthemeEnum.espacoRuralBrasileiro,
      'EUR_GM': SubthemeEnum.globalizacaoMobilidade,
      'EUR_IT': SubthemeEnum.industriaTransformacao,
      'EUR_MA': SubthemeEnum.mercadoAgropecuario,
      // Natureza e Meio Ambiente (NMA)
      'NMA_BH': SubthemeEnum.baciasHidrograficas,
      'NMA_BIO': SubthemeEnum.biomas,
      'NMA_DES': SubthemeEnum.desmatamento,
      'NMA_EFR': SubthemeEnum.estruturasFormasRelevo,
      'NMA_PA': SubthemeEnum.poluicaoAgua,
      'NMA_PAR': SubthemeEnum.poluicaoAr,
      'NMA_QUE': SubthemeEnum.queimadas,
      'NMA_RM': SubthemeEnum.recursosMinerais,
      'NMA_SUS': SubthemeEnum.sustentabilidade,
      'NMA_TC': SubthemeEnum.tempoClima,
      'NMA_TPCL': SubthemeEnum.tiposClimaticos,
      'NMA_UA': SubthemeEnum.usoAgua,
      // Representações Espaciais (RE)
      'RE_CM': SubthemeEnum.compositorMapas,
      'RE_CG': SubthemeEnum.coordenadasGeograficas,
      'RE_FH': SubthemeEnum.fusoHorario,
      'RE_GT': SubthemeEnum.geotecnologias,
      'RE_HC': SubthemeEnum.historiaCartografia,
      'RE_LM': SubthemeEnum.leituraMapas,
      'RE_PC': SubthemeEnum.pontosCardeais,
    };
    return mapping[value.toUpperCase()] ?? SubthemeEnum.coordenadasGeograficas;
  }
}
