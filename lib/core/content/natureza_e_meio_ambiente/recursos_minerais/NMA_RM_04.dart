import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_RM_04 = ContentModel(
  id: 'NMA_RM_04',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.recursosMinerais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'MM Gerdau - Museu das Minas e do Metal',
  ),
  contentInfo: ContentInfo(
    title: 'Diversidade Mineral',
    description:
        'Exposição virtual que apresenta a história da mineração e da metalurgia de forma lúdica e interativa, bem como o universo da Geociências e seus encantos',
    subjects: ['Diversidade', 'Recurso mineral', 'Exposição'],
    contentNote:
        'A diversidade mineral de parte do acervo pode ser vista nesta exposição pela beleza dos minerais, formas, cores, relevância científica nacional e internacional e curiosidades',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 13),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/story/1AWRUQDg2xxeJg',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
