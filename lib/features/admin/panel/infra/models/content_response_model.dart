import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

class ContentResponseModel extends ContentModel {
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

  /// O mesmo objeto com [code] como código e como id do documento.
  ContentResponseModel withCode(String code) => ContentResponseModel(
    docId: code,
    id: code,
    theme: theme,
    subtheme: subtheme,
    intellectualIndicator: intellectualIndicator,
    contentInfo: contentInfo,
    originInfo: originInfo,
    registrationInfo: registrationInfo,
    rightsInfo: rightsInfo,
    preservationAction: preservationAction,
  );

  /// Documento como os objetos já cadastrados: siglas no `themeId`/`subthemeId` e os nomes ao lado.
  Map<String, dynamic> toJson() => {
    'id': id,
    'themeId': theme.id,
    'themeTitle': theme.name,
    'subthemeId': subtheme.id,
    'subthemeTitle': subtheme.name,
    'intellectualIndicator': intellectualIndicator.toJson(),
    'contentInfo': contentInfo.toJson(),
    'originInfo': originInfo.toJson(),
    'registrationInfo': registrationInfo.toJson(),
    'rightsInfo': rightsInfo.toJson(),
    if (preservationAction != null) 'preservationAction': preservationAction!.toJson(),
  };

  /// Aceita no `themeId` e no `subthemeId` tanto o valor do enum quanto a sigla do Firestore.
  factory ContentResponseModel.fromJson(Map<String, dynamic> json, String docId) {
    try {
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
        preservationAction: _preservationOf(json['preservationAction']),
      );
    } catch (e) {
      rethrow;
    }
  }
}

/// Um valor ruim na preservação tira só esses campos, e não o objeto do site.
PreservationAction? _preservationOf(Object? raw) {
  if (raw is! Map<String, dynamic>) return null;
  try {
    return PreservationAction.fromJson(raw);
  } catch (_) {
    return null;
  }
}

ThemeEnum _themeFromStringOrId(String value) {
  try {
    return ThemeEnum.values.firstWhere((e) => e.value == value);
  } catch (_) {
    // Senão, a sigla gravada no Firestore (ex: "CP", "EUR").
    final mapping = {
      'CP': ThemeEnum.culturaPolitica,
      'EUR': ThemeEnum.espacosUrbanosRurais,
      'NMA': ThemeEnum.naturezaMeioAmbiente,
      'RE': ThemeEnum.representacoesEspaciais,
    };
    return mapping[value.toUpperCase()] ?? ThemeEnum.representacoesEspaciais;
  }
}

SubthemeEnum _subthemeFromStringOrId(String value) {
  try {
    return SubthemeEnum.values.firstWhere((e) => e.value == value);
  } catch (_) {
    // Senão, a sigla gravada no Firestore (ex: "CP_CD").
    final mapping = {
      'CP_CD': SubthemeEnum.censoDemografico,
      'CP_GP': SubthemeEnum.geopolitica,
      'CP_IC': SubthemeEnum.identidadesCulturais,
      'CP_POP': SubthemeEnum.populacao,
      'CP_PO': SubthemeEnum.povosOriginarios,
      'CP_RA': SubthemeEnum.regioesAdministrativas,
      'EUR_CT': SubthemeEnum.conflitosTerra,
      'EUR_EUB': SubthemeEnum.espacoUrbanoBrasileiro,
      'EUR_ERB': SubthemeEnum.espacoRuralBrasileiro,
      'EUR_GM': SubthemeEnum.globalizacaoMobilidade,
      'EUR_IT': SubthemeEnum.industriaTransformacao,
      'EUR_MA': SubthemeEnum.mercadoAgropecuario,
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
