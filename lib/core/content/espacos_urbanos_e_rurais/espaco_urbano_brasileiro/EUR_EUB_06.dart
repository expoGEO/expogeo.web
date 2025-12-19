import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_EUB_06 = ContentModel(
  id: 'EUR_EUB_06',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.espacoUrbanoBrasileiro,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'BH Map',
    collaborator: 'Prefeitura de Belo Horizonte',
  ),
  contentInfo: ContentInfo(
    title: 'BH Map',
    description: 'WebSIG com informações geográficas da cidade de Belo Horizonte',
    subjects: ['WebSIG', 'Espaço urbano', 'Belo Horizonte'],
    contentNote: 'WebSIG com informações geográficas da cidade de Belo Horizonte',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://bhmap.pbh.gov.br/v2/mapa',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
