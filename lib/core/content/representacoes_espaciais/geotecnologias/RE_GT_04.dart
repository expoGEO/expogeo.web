import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_GT_04 = ContentModel(
  id: 'RE_GT_04',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.geotecnologias,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'OpenStreetMap',
    collaborator: 'OpenStreetMap',
  ),
  contentInfo: ContentInfo(
    title: 'OpenStreetMap',
    description:
        'Websig que apresenta informações geográficas colaborativas sobre o globo terrestre',
    subjects: ['Mapa colaborativo', 'Cartografia urbana', 'Geotecnologia'],
    contentNote:
        'Websig que apresenta informações geográficas colaborativas sobre o globo terrestre',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.openstreetmap.org',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
