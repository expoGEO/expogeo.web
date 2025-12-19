import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_ERB_01 = ContentModel(
  id: 'EUR_ERB_01',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.espacoRuralBrasileiro,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'EMBRAPA - Territorial',
    collaborator: 'EMBRAPA - Territorial',
  ),
  contentInfo: ContentInfo(
    title: 'Sistema de observação e monitoramento da agricultura brasileira - SOMA Brasil',
    description:
        'WebSIG que apresenta informações geográficas sobre meio físico biótico, logística, monitoramento da agricultura e quadro agrário brasileiro',
    subjects: ['Agricultura', 'Monitoramento', 'WebSIG'],
    contentNote:
        'WebSIG que apresenta informações geográficas sobre meio físico biótico, logística, monitoramento da agricultura e quadro agrário brasileiro',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 11, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet - Necessita criar login e senha de usuário',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://mapas.cnpm.embrapa.br/somabrasil/webgis.html',
    issueYear: 2014,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
