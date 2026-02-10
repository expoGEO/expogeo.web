import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_PC_02 = ContentModel(
  id: 'RE_PC_02',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.pontosCardeais,
  intellectualIndicator: const IntellectualIndicator(
    creator:
        'Núcleo de Educação a Distância da Universidade Federal do Rio de Janeiro (NEaD - UFRJ)',
    collaborator:
        'Núcleo de Educação a Distância da Universidade Federal do Rio de Janeiro (NEaD - UFRJ)',
  ),
  contentInfo: ContentInfo(
    title: 'Você sabe como funciona uma bússola?',
    description:
        'Vídeo explicando o funcionamento de uma bússola e como ela permite nos orientarmos na superfície da Terra',
    subjects: ['Bússola', 'Vídeo', 'Pontos colaterais'],
    contentNote:
        'Vídeo explicando o funcionamento de uma bússola e como ela permite nos orientarmos na superfície da Terra',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 2, 4),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/h01K7-bD8Jg',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
