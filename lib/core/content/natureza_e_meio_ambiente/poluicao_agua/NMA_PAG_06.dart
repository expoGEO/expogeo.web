import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_PAG_06 = ContentModel(
  id: 'NMA_PAG_06',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Agência Nacional das Águas e Saneamento Básico - ANA',
    collaborator: 'Agência Nacional das Águas e Saneamento Básico - ANA',
  ),
  contentInfo: ContentInfo(
    title: 'A Lei das Águas no Brasil',
    description: 'Vídeo educativo da ANA que explica a Lei das Águas do Brasil (Lei nº 9.433/97)',
    subjects: ['Lei das Águas', 'Brasil', 'Vídeo'],
    contentNote: 'Vídeo educativo da ANA que explica a Lei das Águas do Brasil (Lei nº 9.433/97)',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 18),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/bH08pGb50-k',
    issueYear: 2014,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
