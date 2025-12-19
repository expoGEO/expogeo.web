import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_GM_02 = ContentModel(
  id: 'EUR_GM_02',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.globalizacaoMobilidade,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Marine Traffic',
    collaborator: 'Marine Traffic',
  ),
  contentInfo: ContentInfo(
    title: 'Tráfego marítimo em tempo real',
    description: 'Site que apresenta dados em tempo real sobre tráfego marítimo no planeta',
    subjects: ['Globalização', 'Mobilidade', 'Tráfego marítimo'],
    contentNote: 'Site que apresenta dados em tempo real sobre tráfego marítimo no planeta',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Inglês',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.marinetraffic.com',
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
