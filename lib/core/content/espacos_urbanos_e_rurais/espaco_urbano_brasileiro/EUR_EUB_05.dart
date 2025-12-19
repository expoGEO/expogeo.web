import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_EUB_05 = ContentModel(
  id: 'EUR_EUB_05',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.espacoUrbanoBrasileiro,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Blueflower',
    collaborator: 'Blueflower',
  ),
  contentInfo: ContentInfo(
    title: 'TheoTown - Simulador de Cidade',
    description:
        'Jogo de simulação de construção de cidades no qual você pode gerenciar sua própria cidade simulada',
    subjects: ['Simulador', 'Espaço urbano', 'Gestão urbana'],
    contentNote:
        'Jogo de simulação de construção de cidades no qual você pode gerenciar sua própria cidade simulada',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Português',
    type: ContentType.aplicativo,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://abrir.link/pkKKJ',
    issueYear: 2024,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
