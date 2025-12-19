import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_RM_01 = ContentModel(
  id: 'NMA_RM_01',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.recursosMinerais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Serviço Geológico do Brasil',
    collaborator: 'Serviço Geológico do Brasil',
  ),
  contentInfo: ContentInfo(
    title: 'Sistema de Geociências do Serviço Geológico do Brasil',
    description:
        'WebSIG que fornece informações sobre Geologia, Geofísica, Geologia Marinha, Hidrologia, Gestão Territorial e Cartografia do Brasil',
    subjects: ['Brasil', 'Geologia', 'WebSIG'],
    contentNote:
        'WebSIG que fornece informações sobre Geologia, Geofísica, Geologia Marinha, Hidrologia, Gestão Territorial e Cartografia do Brasil',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 13),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://geoportal.sgb.gov.br/geosgb/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
