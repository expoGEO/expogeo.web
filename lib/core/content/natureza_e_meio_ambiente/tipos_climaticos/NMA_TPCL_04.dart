import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_TPCL_04 = ContentModel(
  id: 'NMA_TPCL_04',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.tiposClimaticos,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística - IBGE',
    collaborator: 'Instituto Brasileiro de Geografia e Estatística - IBGE',
  ),
  contentInfo: ContentInfo(
    title: 'Atlas Geográfico Escolar',
    description: 'Atlas que aborda o tema clima e correntes marítimas do mundo',
    subjects: ['Clima', 'Corrente marítima', 'Atlas'],
    contentNote:
        'As zonas climáticas são definidas por faixas onde a incidência da radiação e iluminação solar são distintas. As correntes marítimas indicam a temperatura e a direção predominante de grandes porções do oceano e influenciam significativamente os padrões climáticos regionais',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 10),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://atlasescolar.ibge.gov.br/mundo/2990-dinamica-dos-climas/clima-e-correntes-maritimas.html',
    issueYear: 2024,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
