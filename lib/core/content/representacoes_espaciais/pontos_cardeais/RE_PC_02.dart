import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_PC_02 = ContentModel(
  id: 'RE_PC_02',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.pontosCardeais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Wordwall',
    collaborator: 'Perfil: Regianet37',
  ),
  contentInfo: ContentInfo(
    title: 'Caça-palavras pontos cardeais e colaterais',
    description: 'Caça-palavras sobre pontos cardeais e colaterais',
    subjects: ['Caça-palavras', 'Pontos cardeais', 'Pontos colaterais'],
    contentNote:
        'Atividade de caça-palavras que apresenta opções para preencher campos de resposta conforme a rosa dos ventos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 8),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://wordwall.net/pt/resource/12076008/ca%C3%A7a-palavras-pontos-cardeais-e-colaterais',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
