import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_CG_02 = ContentModel(
  id: 'RE_CG_02',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.coordenadasGeograficas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'GeoGebra',
    collaborator: 'Carmen Mathias e Jose Manuel Arranz',
  ),
  contentInfo: ContentInfo(
    title: 'Coordenadas geográficas',
    description:
        'Site que apresenta modelo digital de representação do sistema de coordenadas geográficas',
    subjects: ['Coordenadas geográficas', 'Longitude', 'Latitude'],
    contentNote:
        'Modelo digital que permite manipular coordenadas por valores em graus e visualizar o sistema com animação',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 10),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.geogebra.org/m/un9hcccd',
    issueYear: 2020,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
