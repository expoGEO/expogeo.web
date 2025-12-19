import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_QUE_02 = ContentModel(
  id: 'NMA_QUE_02',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.queimadas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Centro Gestor e Operacional do Sistema de Proteção da Amazônia - CENSIPAM',
    collaborator: 'Centro Gestor e Operacional do Sistema de Proteção da Amazônia - CENSIPAM',
  ),
  contentInfo: ContentInfo(
    title: 'Painel do Fogo',
    description: 'WebSIG que fornece informação sobre os eventos de queimadas no Brasil',
    subjects: ['Queimadas', 'Monitoramento', 'WebSIG'],
    contentNote: 'Mapa Interativo de Incêndios e Queimadas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://panorama.sipam.gov.br/painel-do-fogo/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
