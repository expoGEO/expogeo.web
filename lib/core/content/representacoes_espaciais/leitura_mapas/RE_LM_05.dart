import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_LM_05 = ContentModel(
  id: 'RE_LM_05',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Museu Virtual do Vale do Mucuri',
    collaborator: 'Museu Virtual do Vale do Mucuri',
  ),
  contentInfo: ContentInfo(
    title: 'Cartografia do Mucuri',
    description:
        'Site que apresenta exposição cartográfica virtual sobre o Vale do Mucuri',
    subjects: ['Mapa temático', 'Vale do Mucuri', 'Exposição virtual'],
    contentNote:
        'Exposição com diversos mapas temáticos sobre o Vale do Mucuri',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.imagem,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://museuvirtualvaledomucuri.com.br/cartografia-do-mucuri/',
    issueYear: 2018,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);


