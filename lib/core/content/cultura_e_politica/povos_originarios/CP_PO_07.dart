import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_PO_07 = ContentModel(
  id: 'CP_PO_07',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Museu da Língua Portuguesa',
    collaborator: 'Museu da Língua Portuguesa',
  ),
  contentInfo: ContentInfo(
    title: 'Nhe\'e Porã: memória e transformação',
    description:
        'A exposição apresenta de maneira poética, potente e acessível, a diversidade linguística como expressão das culturas indígenas do país, mas também como importante instrumento de resistência dessas populações',
    subjects: ['Indígenas', 'Linguagem', 'Exposição'],
    contentNote:
        'A exposição contou com a colaboração de mais de 50 especialistas indígenas, entre linguistas, artistas e criadores',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://nheepora.mlp.org.br/',
    issueYear: 2023,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
