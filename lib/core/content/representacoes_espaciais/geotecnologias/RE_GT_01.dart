import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_GT_01 = ContentModel(
  id: 'RE_GT_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística',
    collaborator: 'Instituto Brasileiro de Geografia e Estatística',
  ),
  contentInfo: ContentInfo(
    title: 'Cidades e Estados do Brasil',
    description:
        'Websig que apresenta informações geográficas sobre todos os municípios brasileiros',
    subjects: ['Mapa temático', 'Demografia', 'Geotecnologia'],
    contentNote:
        'Websig que apresenta informações geográficas sobre todos os municípios brasileiros',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://cidades.ibge.gov.br/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);


