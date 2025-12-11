import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_PAG_05 = ContentModel(
  id: 'NMA_PAG_05',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Agência Nacional das Águas e Saneamento Básico - ANA',
    collaborator: 'Agência Nacional das Águas e Saneamento Básico - ANA',
  ),
  contentInfo: ContentInfo(
    title: 'Atlas das Águas - Segurança Hídrica',
    description:
        'WebSIG que disponibiliza informações geográficas e dados relacionados ao monitoramento das águas superficiais no Brasil',
    subjects: ['Qualidade da água', 'Monitoramento', 'WebSIG'],
    contentNote:
        'WebSIG que disponibiliza informações geográficas e dados relacionados ao monitoramento das águas superficiais no Brasil',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 18),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://portal1.snirh.gov.br/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
