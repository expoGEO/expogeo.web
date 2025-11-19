import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_LM_07 = ContentModel(
  id: 'RE_LM_07',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Longitude.one',
    collaborator: 'Lee Griggs, Daniel Huffman e Sam Caldwell',
  ),
  contentInfo: ContentInfo(
    title: 'Mapas topográficos tridimensionais',
    description:
        'Site que apresenta exposição cartográfica virtual sobre os relevos de diversos países em todos os continentes',
    subjects: ['Mapa temático', 'Topografia', 'Exposição virtual'],
    contentNote:
        'Site com exposição cartográfica virtual de relevos em diferentes continentes',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Inglês',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.longitude.one/other-maps',
    issueYear: 2022,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);


