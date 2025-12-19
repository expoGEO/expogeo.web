import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_HC_04 = ContentModel(
  id: 'RE_HC_04',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.historiaCartografia,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Universidade Virtual do Estado de São Paulo',
    collaborator: 'Notícias UNIVESP',
  ),
  contentInfo: ContentInfo(
    title: 'A história da cartografia e a importância dos mapas',
    description:
        'Entrevista com o Prof. Dr. Paulo Miceli sobre a história da cartografia e a importância dos mapas para a evolução humana',
    subjects: ['Cartografia', 'Desenvolvimento humano', 'Entrevista'],
    contentNote:
        'Entrevista que destaca a importância dos mapas para localização no espaço geográfico e aborda aspectos culturais, estratégicos, bélicos e religiosos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 8),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://univesp.br/noticias/a-historia-da-cartografia-e-a-importancia-dos-mapas',
    issueYear: 2015,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
