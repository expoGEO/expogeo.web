import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_IT_05 = ContentModel(
  id: 'EUR_IT_05',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Fundação CSN',
    collaborator: 'Centro cultural – Fundação CSN',
  ),
  contentInfo: ContentInfo(
    title: 'Memória História Futuro',
    description:
        'A exposição traz projeções de registros fotográficos que narram a linha do tempo da construção da Usina Presidente Vargas, na cidade de Volta Redonda (RJ)',
    subjects: ['Indústria', 'História', 'Fotografia'],
    contentNote:
        'Os registros fotográficos trazem uma reflexão sobre a formação histórica de Volta Redonda, gerada pela memória de pessoas vindas de várias partes do Brasil e até mesmo do exterior, plantada e forjada através da sua própria identidade',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 11, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://centroculturalfcsn.org.br/memoria-historia-futuro/',
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
