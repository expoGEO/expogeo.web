import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_QUE_01 = ContentModel(
  id: 'NMA_QUE_01',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.queimadas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Ministério da Ciência, Tecnologias e Informação - MCTI',
    collaborator: 'Instituto Nacional de Pesquisas Espaciais - INPE',
  ),
  contentInfo: ContentInfo(
    title: 'BDQueimadas',
    description:
        'WebSIG que fornece informação para a mitigação da mudança do clima e para melhoria da gestão de recursos naturais',
    subjects: ['Queimadas', 'Monitoramento', 'WebSIG'],
    contentNote: 'Plataforma digital para monitoramento e alerta de fogo na vegetação',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://terrabrasilis.dpi.inpe.br/queimadas/bdqueimadas/#ma',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
