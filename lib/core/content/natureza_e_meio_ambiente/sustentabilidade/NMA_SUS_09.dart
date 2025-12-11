import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_SUS_09 = ContentModel(
  id: 'NMA_SUS_09',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Global Forest Watch',
    collaborator: 'Global Forest Watch',
  ),
  contentInfo: ContentInfo(
    title: 'Observatório Global das Florestas',
    description: 'WebSIG que fornece dados e ferramentas para o monitoramento de florestas',
    subjects: ['Florestas', 'Monitoramento', 'WebSIG'],
    contentNote:
        'Usando tecnologia de ponta, o Observatório Global das Florestas permite que qualquer pessoa acesse informações quase em tempo real sobre onde e como as florestas estão mudando em todo o mundo',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.globalforestwatch.org/map/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
