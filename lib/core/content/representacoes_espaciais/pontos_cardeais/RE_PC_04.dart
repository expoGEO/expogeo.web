import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_PC_04 = ContentModel(
  id: 'RE_PC_04',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.pontosCardeais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Brasil Escola',
    collaborator: 'Larissa Mesquita',
  ),
  contentInfo: ContentInfo(
    title: 'Rosa dos ventos, pontos cardeais e pontos colaterais',
    description: 'Videoaula sobre orientação espacial e pontos cardeais',
    subjects: ['Orientação espacial', 'Pontos cardeais', 'Geografia'],
    contentNote:
        'Videoaula que explica a função da rosa dos ventos, pontos cardeais e colaterais como referências de localização',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 8),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.youtube.com/watch?v=jY6Z4ID33o&feature=youtu.be',
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
