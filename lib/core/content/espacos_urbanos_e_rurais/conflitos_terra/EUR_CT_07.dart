import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_CT_07 = ContentModel(
  id: 'EUR_CT_07',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.conflitosTerra,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Agência Pública de Jornalismo Investigativo',
    collaborator: 'Comissão Pastoral da Terra (CPT)',
  ),
  contentInfo: ContentInfo(
    title: 'Mapa dos Conflitos',
    description:
        'O Mapa dos Conflitos é um projeto da Agência Pública de Jornalismo Investigativo em parceria com a Comissão Pastoral da Terra (CPT) que, por meio de análise inédita de dados, investiga as ocorrências de conflitos no campo na Amazônia Legal na última década (2011-2020)',
    subjects: ['Conflitos de terra', 'Amazônia', 'WebSIG'],
    contentNote:
        'Foram analisados os conflitos no campo em comparação aos dados públicos relacionados a outras temáticas socioambientais como desmatamento, queimadas, mineração, água, agrotóxicos, violência e desigualdade',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://mapadosconflitos.apublica.org/mapa',
    issueYear: 2020,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
