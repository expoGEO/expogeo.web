import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_IC_03 = ContentModel(
  id: 'CP_IC_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Museu da Pessoa',
    collaborator: 'Museu da Pessoa',
  ),
  contentInfo: ContentInfo(
    title: 'Vidas em cordel',
    description:
        'A Exposição Vidas em Cordel celebra a tradição oral, a poesia popular e a ancestralidade que permeia cada linha das narrativas apresentadas',
    subjects: ['Literatura de cordel', 'Tradição oral', 'Exposição'],
    contentNote:
        'São histórias de lutas, amores, desafios e superações. Uma jornada pelas intrincadas teias da vida, contada através dos versos e rimas da literatura de cordel e marcada pelos traços da xilogravura',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://memo.museudapessoa.org/vidas-em-cordel/cordeis/',
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
