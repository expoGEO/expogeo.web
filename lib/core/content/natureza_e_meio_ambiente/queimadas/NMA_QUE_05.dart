import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_QUE_05 = ContentModel(
  id: 'NMA_QUE_05',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Letras Ambientais',
    collaborator: 'Letras Ambientais',
  ),
  contentInfo: ContentInfo(
    title: 'Como é feito o monitoramento por satélite das queimadas no Brasil?',
    description:
        'Reportagem que explica como é feito o monitoramento por satélite das queimadas no Brasil',
    subjects: ['Queimadas', 'Monitoramento', 'Reportagem'],
    contentNote:
        'A intensidade do fogo ativo é expressa, na imagem de satélite, pelas cores que vão do laranja (menor energia) a vermelha (mais alta energia), associadas às queimadas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://www.letrasambientais.org.br/posts/como-e-feito-o-monitoramento-por-satelite-das-queimadas-no-brasil-',
    issueYear: 2022,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
