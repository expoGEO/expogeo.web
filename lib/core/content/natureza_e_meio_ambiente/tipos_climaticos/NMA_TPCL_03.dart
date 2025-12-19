import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_TPCL_03 = ContentModel(
  id: 'NMA_TPCL_03',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.tiposClimaticos,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística - IBGE',
    collaborator: 'Diretoria de Geociências',
  ),
  contentInfo: ContentInfo(
    title: 'Atlas Geográfico Escolar',
    description: 'Atlas que apresenta informações sobre os tipos climáticos do Brasil',
    subjects: ['Brasil', 'Tipos climáticos', 'Atlas'],
    contentNote:
        'O Atlas apresenta mapas e vídeos sobre os tipos climáticos, climas zonais e mudanças climáticas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://atlasescolar.ibge.gov.br/brasil/3037-diversidade-ambiental/clima.html',
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
