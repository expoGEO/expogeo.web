import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_PO_01 = ContentModel(
  id: 'CP_PO_01',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.povosOriginarios,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Museu das culturas indígenas',
    collaborator: 'Museu das culturas indígenas',
  ),
  contentInfo: ContentInfo(
    title: 'Decoloniza SP - Terra indígena',
    description:
        'Site que apresenta a exposição "Decoloniza SP - Terra indígena" como parte integrante do Museu das culturas indígenas',
    subjects: ['Indígenas', 'Cultura', 'Exposição'],
    contentNote: 'Temas apresentados: Pinturas Yanomami, Toré Pankararu e Grafismo Guarani',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://museudasculturasindigenas.org.br/decoloniza-sp-terra-indigena/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
