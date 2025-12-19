import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_PC_03 = ContentModel(
  id: 'RE_PC_03',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.pontosCardeais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Câmara dos Deputados',
    collaborator: 'Plenarinho',
  ),
  contentInfo: ContentInfo(
    title: 'Pontos cardeais para você se orientar',
    description: 'Texto sobre orientação espacial e pontos cardeais',
    subjects: ['Orientação espacial', 'Pontos cardeais', 'Geografia'],
    contentNote:
        'Resumo sobre pontos cardeais como referências usadas para orientação em mapas, válidas para todos os lugares',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 8),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.texto,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://plenarinho.leg.br/index.php/2018/08/pontos-cardeais-para-voce-se-orientar/',
    issueYear: 2018,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
