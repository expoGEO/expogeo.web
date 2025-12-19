import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_CG_01 = ContentModel(
  id: 'RE_CG_01',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.coordenadasGeograficas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística',
    collaborator: 'Instituto Brasileiro de Geografia e Estatística',
  ),
  contentInfo: ContentInfo(
    title: 'Coordenadas geográficas',
    description:
        'Site que apresenta os principais conceitos sobre coordenadas geográficas, longitude e latitude',
    subjects: ['Coordenadas geográficas', 'Longitude', 'Latitude'],
    contentNote:
        'Site do IBGE que apresenta resumo sobre os principais conceitos sobre coordenadas geográficas, longitude e latitude',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 10),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.texto,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://atlasescolar.ibge.gov.br/cartografia/21730-coordenadas-geograficas.html',
    issueYear: 2024,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
