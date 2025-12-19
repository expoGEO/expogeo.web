import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_POP_01 = ContentModel(
  id: 'CP_POP_01',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.demografia,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística',
    collaborator: 'Instituto Brasileiro de Geografia e Estatística',
  ),
  contentInfo: ContentInfo(
    title: 'Cidades e Estados do Brasil',
    description:
        'Site que apresenta diversas informações geográficas e dados demográficos de todos os municípios do país',
    subjects: ['Informação geográfica', 'Dado demográfico', 'Site'],
    contentNote:
        'Informações em diferentes escalas de análise: nacional, regional e local. Temas apresentados: população, economia, educação, indústria, história e fotos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 3),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://cidades.ibge.gov.br/brasil/panorama',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
