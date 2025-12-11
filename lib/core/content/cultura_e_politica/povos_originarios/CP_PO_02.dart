import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_PO_02 = ContentModel(
  id: 'CP_PO_02',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Museu da pessoa',
    collaborator: 'Museu da pessoa',
  ),
  contentInfo: ContentInfo(
    title: 'Vidas indígenas',
    description:
        'Site que apresenta a exposição "Vidas indígenas" como parte integrante do Museu da pessoa',
    subjects: ['Indígenas', 'Cultura', 'Exposição'],
    contentNote:
        'As histórias que compõem esta exposição apresentam vivências de mulheres e homens indígenas em suas pluralidades, nas quais é possível perceber reflexões e relatos sobre movimento, território, corpo e ancestralidade',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://exposicaovidasindigenas.museudapessoa.org/',
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
