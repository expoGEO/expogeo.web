import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_GM_06 = ContentModel(
  id: 'EUR_GM_06',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.globalizacaoMobilidade,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'SP Trans',
    collaborator: 'Museu Virtual dos Transportes',
  ),
  contentInfo: ContentInfo(
    title: 'Galeria virtual do Museu SP Trans',
    description:
        'Exposição virtual que apresenta fotografias históricas dos mais variados modais de transportes utilizados na cidade de São Paulo',
    subjects: ['Sistema de transportes', 'Mobilidade', 'São Paulo'],
    contentNote:
        'Exposição virtual que apresenta fotografias históricas dos mais variados modais de transportes utilizados na cidade de São Paulo',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.sptrans.com.br/museu-virtual?p=1',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
