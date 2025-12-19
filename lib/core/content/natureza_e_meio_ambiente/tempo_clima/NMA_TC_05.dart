import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_TC_05 = ContentModel(
  id: 'NMA_TC_05',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.tempoClima,
  intellectualIndicator: const IntellectualIndicator(creator: 'Windy', collaborator: 'Windy'),
  contentInfo: ContentInfo(
    title: 'Windy',
    description: 'WebSIG que contém informações sobre dados climáticos ao redor do mundo',
    subjects: ['Ventos', 'Meteorologia', 'WebSIG'],
    contentNote:
        'Camadas de informação: Chuva; Trovão; Ventos; Temperatura; Ondas e Radares meteorológicos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 10),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.windy.com/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
