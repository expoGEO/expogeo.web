import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_PAR_02 = ContentModel(
  id: 'NMA_PAR_02',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.poluicaoAr,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Projeto Índice Mundial de Qualidade do Ar',
    collaborator: 'Embaixadas dos EUA na China',
  ),
  contentInfo: ContentInfo(
    title: 'Poluição do ar no mundo: Mapa da qualidade do ar em tempo real',
    description:
        'Site que permite a visualização de informações geográficas e dados transparentes sobre a qualidade do ar para mais de 130 países, abrangendo mais de 250 mil estações de monitoramento da qualidade do ar em 2 mil grandes cidades',
    subjects: ['Poluição do Ar', 'Monitoramento', 'Mapa'],
    contentNote:
        'A missão do projeto é promover a conscientização dos cidadãos sobre a poluição do ar e fornecer informações unificadas e mundiais sobre a qualidade do ar',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 18),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://aqicn.org/map/world/pt/',
    issueYear: 2007,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
