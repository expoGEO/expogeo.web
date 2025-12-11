import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_PAG_04 = ContentModel(
  id: 'NMA_PAG_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Agência Nacional das Águas e Saneamento Básico - ANA',
    collaborator: 'Agência Nacional das Águas e Saneamento Básico - ANA',
  ),
  contentInfo: ContentInfo(
    title: 'Atlas das Águas',
    description:
        'Painel que disponibiliza informações geográficas e dados relacionados ao monitoramento das águas superficiais no Brasil',
    subjects: ['Qualidade da água', 'Monitoramento', 'Painel'],
    contentNote:
        'Painel que disponibiliza informações geográficas e dados relacionados ao monitoramento das águas superficiais no Brasil',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 18),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://app.powerbi.com/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
