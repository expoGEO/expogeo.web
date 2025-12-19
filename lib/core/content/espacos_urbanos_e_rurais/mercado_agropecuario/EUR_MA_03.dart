import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_MA_03 = ContentModel(
  id: 'EUR_MA_03',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.mercadoAgropecuario,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Ministério da Agricultura e Pecuária',
    collaborator: 'Secretaria de Política Agrícola (SPA)',
  ),
  contentInfo: ContentInfo(
    title: 'Observatório da Agropecuária Brasileira - Pecuária',
    description:
        'O Observatório da Agropecuária Brasileira é uma inovadora solução tecnológica que sistematiza, integra e disponibiliza um gigantesco conjunto de dados e informações da agricultura e pecuária do País',
    subjects: ['Pecuária', 'Informações', 'Dados'],
    contentNote:
        'O Observatório da Agropecuária Brasileira tem a missão de transformar dados em informações assertivas e oferecer uma grande capacidade de integração e análise dessas informações numéricas, gráficas, cartográficas e geoespaciais das diversas cadeias produtivas do agronegócio',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://observatorio.agropecuaria.inmet.gov.br/paineis/pecuaria/bovinos/visaoGeral',
    issueYear: 2025,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
