import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_PO_03 = ContentModel(
  id: 'CP_PO_03',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.povosOriginarios,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Museu Nacional/UFRJ',
    collaborator: 'Projeto Museu Nacional Vive',
  ),
  contentInfo: ContentInfo(
    title: 'Os primeiros brasileiros',
    description:
        'A exposição virtual revela a diversidade e as narrativas dos povos indígenas por meio de fotografias, músicas, vídeos e peças etnográficas que não foram atingidas pelo incêndio do Museu Nacional em 2018',
    subjects: ['Indígenas', 'Cultura', 'Exposição'],
    contentNote:
        'Apresenta registros e marcas da colonização e evidenciar a riqueza, o dinamismo e a vitalidade das culturas indígenas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://osprimeirosbrasileiros.mn.ufrj.br/pt/apresentacao/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
