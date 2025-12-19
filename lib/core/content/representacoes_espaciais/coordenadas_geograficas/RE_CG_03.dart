import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_CG_03 = ContentModel(
  id: 'RE_CG_03',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.coordenadasGeograficas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Canal Youtube: Você sabia?',
    collaborator: 'Canal Youtube: Você sabia?',
  ),
  contentInfo: ContentInfo(
    title: 'Latitude e Longitude',
    description: 'Vídeo com resumo sobre os principais conceitos de latitude e longitude',
    subjects: ['Coordenadas geográficas', 'Longitude', 'Latitude'],
    contentNote:
        'Vídeo do canal “Você sabia?” com resumo sobre os conceitos de latitude e longitude',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 10),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.youtube.com/watch?v=iyxUaN3xmPM',
    issueYear: 2017,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
