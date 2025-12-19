import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_BH_04 = ContentModel(
  id: 'NMA_BH_04',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.baciasHidrograficas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística - IBGE',
    collaborator: 'Instituto Brasileiro de Geografia e Estatística - IBGE',
  ),
  contentInfo: ContentInfo(
    title: 'Atlas Geográfico Escolar',
    description: 'Atlas que apresentação as principais divisões hidrográficas do Brasil',
    subjects: ['Bacias hidrográficas', 'Brasil', 'Atlas'],
    contentNote: 'Atlas que apresentação as principais divisões hidrográficas do Brasil',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 9),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://atlasescolar.ibge.gov.br/brasil/3046-diversidade-ambiental/recursos-hidricos.html',
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
