import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_HC_05 = ContentModel(
  id: 'RE_HC_05',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.historiaCartografia,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Fundação Oswaldo Cruz',
    collaborator: 'Escola Politécnica de Saúde Joaquim Venâncio',
  ),
  contentInfo: ContentInfo(
    title: 'A história da cartografia',
    description: 'Apostila sobre a história da cartografia',
    subjects: ['Cartografia', 'Cartógrafos', 'Modelos cartográficos'],
    contentNote:
        'Apostila que apresenta modelos cartográficos desenvolvidos ao longo da evolução humana',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 8),
    language: 'Português',
    type: ContentType.documento,
    format: ContentFormat.texto,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://cogetes.epsjv.fiocruz.br/storage/Textos-e-Materiais-de-Estudo-Ciclo-05_PedroQuental-b_5ebaf70ec6c28.pdf',
    issueYear: 2008,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
