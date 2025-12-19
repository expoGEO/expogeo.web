import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_BH_05 = ContentModel(
  id: 'NMA_BH_05',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.baciasHidrograficas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Agência Nacional de Águas - ANA',
    collaborator: 'Agência Nacional de Águas - ANA',
  ),
  contentInfo: ContentInfo(
    title: 'Atlas Esgotos: Despoluição de Bacias Hidrográficas',
    description:
        'O Atlas Esgotos traz a análise da situação do esgotamento sanitário nas 5.570 cidades brasileiras e dos impactos do lançamento dos esgotos nos rios, lagos e reservatórios do País',
    subjects: ['Esgotos', 'Brasil', 'WebSIG'],
    contentNote:
        'Como muitos municípios não possuem tratamento de esgotos adequado ou sequer disponibilizam o serviço para sua população, o lançamento desses efluentes nos corpos hídricos comprometem a qualidade e os usos das águas, causando implicações danosas à saúde pública e ao equilíbrio do meio ambiente',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://portall.snirh.gov.br/ana/apps/webappviewer/index.html?id=6d866c5d54c64b17bd53af4bdcfb4b91',
    issueYear: 2024,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
