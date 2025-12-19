import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_ERB_05 = ContentModel(
  id: 'EUR_ERB_05',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.espacoRuralBrasileiro,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Interamericano de Cooperação para a Agricultura (IICA)',
    collaborator: 'Instituto Interamericano de Cooperação para a Agricultura (IICA)',
  ),
  contentInfo: ContentInfo(
    title: 'Agroart - Museo de arte visual - Crônicas rurais',
    description: 'Exposição fotográfica sobre a cultura rural das Américas',
    subjects: ['Paisagem rural', 'Agropecuária', 'Fotografia'],
    contentNote:
        'O Museu Agroart se propõe a difundir e integrar as diversas expressões artísticas das Américas, emanadas da rica e diversa cultura das zonas rurais do nosso hemisfério, nas dimensões social, ambiental e econômica',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://agroart.iica.int/room/14',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
