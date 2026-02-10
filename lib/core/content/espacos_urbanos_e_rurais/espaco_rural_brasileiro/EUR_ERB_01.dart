import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_ERB_01 = ContentModel(
  id: 'EUR_ERB_01',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.espacoRuralBrasileiro,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Medeiros Braga',
    collaborator: 'Movimento dos Trabalhadores Rurais Sem Terra - MST',
  ),
  contentInfo: ContentInfo(
    title: 'O Cordel da Reforma Agrária',
    description: 'Cordel que aborda questões relacionadas à luta por reforma agrária no Brasil',
    subjects: ['Agricultura', 'Reforma Agrária', 'Cordel'],
    contentNote: 'Cordel que aborda questões relacionadas à luta por reforma agrária no Brasil',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 02, 04),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.texto,
    requirements: 'Acesso à internet - Necessita criar login e senha de usuário',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://mst.org.br/2009/06/30/o-cordel-da-reforma-agraria-2/',
    issueYear: 2007,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
