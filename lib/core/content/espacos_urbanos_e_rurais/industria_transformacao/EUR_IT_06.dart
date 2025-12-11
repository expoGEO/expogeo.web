import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_IT_06 = ContentModel(
  id: 'EUR_IT_06',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Pinacoteca de São Paulo',
    collaborator: 'Pinacoteca de São Paulo',
  ),
  contentInfo: ContentInfo(
    title: 'A máquina do mundo: Arte e indústria no Brasil 1901 – 2021',
    description:
        'A mostra examina as várias maneiras pelas quais a indústria impacta a produção de artistas no Brasil desde o início do século passado, numa perspectiva inédita sobre os últimos 120 anos da história da arte brasileira',
    subjects: ['Indústria', 'História', 'Arte'],
    contentNote:
        'O título da exposição se origina na ideia do mundo como uma máquina, composto essencialmente de um engenho universal cujo princípio mecânico regeria o cosmos, os corpos celestes e os elementos da natureza',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 11, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://pinacoteca.org.br/programacao/exposicoes/a-maquina-do-mundo-arte-e-industria-no-brasil-1901-2021/',
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
