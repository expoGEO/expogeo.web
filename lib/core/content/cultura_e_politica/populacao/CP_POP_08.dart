import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_POP_08 = ContentModel(
  id: 'CP_POP_08',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.populacao,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia Estatística',
    collaborator: 'Instituto Brasileiro de Geografia Estatística',
  ),
  contentInfo: ContentInfo(
    title: 'Expectativa de vida no Brasil • IBGE Explica',
    description:
        'Vídeo que apresenta o conceito de expectativa de vida e como esse indicador demográfico ajuda a compreender o sistema da previdência social',
    subjects: ['Brasil', 'Expectativa de vida', 'Vídeo'],
    contentNote:
        'Conheça dados importantes sobre este indicador, também chamado de esperança de vida ao nascer, que influencia em decisões que afetam a todos nós, como a definição de políticas públicas e cálculos da previdência',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 3),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/pPE19O138qE',
    issueYear: 2019,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
