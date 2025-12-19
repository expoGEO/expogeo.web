import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_ERB_04 = ContentModel(
  id: 'EUR_ERB_04',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.espacoRuralBrasileiro,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Parque Histórico de Carambeí',
    collaborator: 'Museu Parque Histórico de Carambeí',
  ),
  contentInfo: ContentInfo(
    title: 'Prato cheio — A alimentação na colônia holandesa de Carambeí em fotos (1911 – 1960)',
    description:
        'Exposição fotográfica sobre a cultura da colônia holandesa no município de Carambeí - PR',
    subjects: ['Paisagem rural', 'Pecuária', 'Fotografia'],
    contentNote:
        'A mostra fotográfica digital remonta a utilização da fotografia nos estudos do passado, neste caso em específico os registros fotográficos das práticas alimentares do imigrante holandês',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 11, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.aphc.com.br/pratocheio/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
