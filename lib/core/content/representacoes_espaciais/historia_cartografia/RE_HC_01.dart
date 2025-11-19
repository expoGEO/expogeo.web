import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_HC_01 = ContentModel(
  id: 'RE_HC_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Museu da Marinha',
    collaborator: 'Museu da Marinha',
  ),
  contentInfo: ContentInfo(
    title: 'Cartografia: a coleção de cartas náuticas do Museu de Marinha',
    description:
        'Exposição virtual que apresenta cartas náuticas utilizadas pelos navegantes portugueses',
    subjects: ['Carta náutica', 'Cartografia', 'Representações espaciais'],
    contentNote:
        'Apresentação de cartas náuticas criadas pelos portugueses ao longo da expansão marítima colonial em diversas regiões do planeta',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 8),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.html,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/story/tQVx3nWL8xhMLg',
    issueYear: 2024,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre - Google'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
