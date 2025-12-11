import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_GM_01 = ContentModel(
  id: 'EUR_GM_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Flightradar24',
    collaborator: 'Flightradar24',
  ),
  contentInfo: ContentInfo(
    title: 'Tráfego aéreo em tempo real',
    description: 'Site que apresenta dados em tempo real sobre tráfego aéreo no planeta',
    subjects: ['Globalização', 'Mobilidade', 'Tráfego aéreo'],
    contentNote: 'Site que apresenta dados em tempo real sobre tráfego aéreo no planeta',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Inglês',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.flightradar24.com/-15.72,-53.73/4',
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
