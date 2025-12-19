import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_BH_02 = ContentModel(
  id: 'NMA_BH_02',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.baciasHidrograficas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Agência Nacional de Águas - ANA',
    collaborator: 'Agência Nacional de Águas - ANA',
  ),
  contentInfo: ContentInfo(
    title: 'Hidroweb',
    description:
        'WebSIG com acesso a uma base de dados que contém todas as informações coletadas pela Rede Hidrometeorológica Nacional (RHN), reunindo dados de níveis fluviais, vazões, precipitações, climatologia, qualidade da água e sedimentos',
    subjects: ['Bacias hidrográficas', 'Brasil', 'WebSIG'],
    contentNote:
        'Ferramenta importante com dados coletados por estações hidrometeorológicas que são essenciais para a gestão dos recursos hídricos e diversos setores econômicos, como geração de energia, irrigação, navegação e indústria',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 9),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.snirh.gov.br/hidroweb/mapa',
    issueYear: 2005,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
