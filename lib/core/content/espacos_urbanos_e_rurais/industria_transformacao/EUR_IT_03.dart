import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_IT_03 = ContentModel(
  id: 'EUR_IT_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Confederação Nacional das Indústrias',
    collaborator: 'Confederação Nacional das Indústrias',
  ),
  contentInfo: ContentInfo(
    title: 'Perfil da indústria dos estados brasileiros',
    description:
        'Site que apresenta informações sobre produção industrial dos estados brasileiros com dados e gráficos estatísticos',
    subjects: ['Indústria', 'Produção', 'Dados estatísticos'],
    contentNote:
        'Site que apresenta informações sobre produção industrial dos estados brasileiros com dados e gráficos estatísticos. Temas de estudo: Setores econômicos, Porte industrial, Emprego e educação, Tributação',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 11, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://perfildaindustria.portaldaindustria.com.br/',
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
