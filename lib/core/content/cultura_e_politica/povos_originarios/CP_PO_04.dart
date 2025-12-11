import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_PO_04 = ContentModel(
  id: 'CP_PO_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Jornalismo TV Cultura',
    collaborator: 'Jornalismo TV Cultura',
  ),
  contentInfo: ContentInfo(
    title: 'Krenak, Uma História de Resistência',
    description:
        'O vídeo mostra uma cultura indígena que esteve à beira da extinção. O povo suportou toda a violência do estado brasileiro, da época do Brasil colonial até às ações arbitrárias praticadas contra eles durante a ditadura militar, a partir dos anos 60',
    subjects: ['Indígenas', 'Krenak', 'Vídeo'],
    contentNote:
        'os Krenak enfrentaram a poluição de seu ambiente com o rompimento de uma barragem em Mariana, em 2005, e tiveram que buscar alternativas para replantar as árvores e ter de volta a água que a natureza lhes deu e os homens que vieram de longe tomaram',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/D4eqFpUM3P0',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
