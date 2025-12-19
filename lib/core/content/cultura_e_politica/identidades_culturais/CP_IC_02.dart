import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_IC_02 = ContentModel(
  id: 'CP_IC_02',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.identidadesCulturais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Museus - IBRAM',
    collaborator: 'Instituto Brasileiro de Museus - IBRAM',
  ),
  contentInfo: ContentInfo(
    title: 'Instituto Brasileiro de Museus - IBRAM',
    description: 'Descubra as riquezas da cultura brasileira por meio de seus museus',
    subjects: ['Museus brasileiros', 'Diversidade cultural', 'Exposição'],
    contentNote: 'Descubra as riquezas da cultura brasileira por meio de seus museus',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/project/instituto-brasileiro-de-museus-ibram',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
