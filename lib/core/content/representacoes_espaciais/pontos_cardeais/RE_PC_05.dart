import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_PC_05 = ContentModel(
  id: 'RE_PC_05',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.pontosCardeais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Museu de Sichuan',
    collaborator: 'Museu de Sichuan',
  ),
  contentInfo: ContentInfo(
    title: 'A bússola chinesa e o nascimento da navegação',
    description:
        'Exposição virtual sobre a invenção da bússola na China Antiga e sua importância para a ciência, tecnologia e civilização',
    subjects: ['Orientação espacial', 'Bússola', 'Tecnologia'],
    contentNote:
        'Exposição na plataforma Google Arts & Culture mostrando como marinheiros chineses adotaram a bússola para navegação astronômica e terrestre no fim do século XI',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 8),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.html,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://artsandculture.google.com/story/the-chinese-compass-and-the-birth-of-navigation-sichuan-museum/NwUh8_iQJNTQLw?hl=pt-BR',
    issueYear: 2023,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
