import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_SUS_05 = ContentModel(
  id: 'NMA_SUS_05',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.sustentabilidade,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'International Council on Monuments and Sites - ICOMOS',
  ),
  contentInfo: ContentInfo(
    title: 'Patrimônio no limite',
    description:
        'Exposição virtual que informa como as pessoas em todo o mundo estão a proteger os seus locais culturais contra as alterações climáticas',
    subjects: ['Sustentabilidade', 'Ação humana', 'Exposição'],
    contentNote:
        'Exposição virtual que informa como as pessoas em todo o mundo estão a proteger os seus locais culturais contra as alterações climáticas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/project/heritage-on-the-edge',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
