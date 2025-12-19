import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_SUS_01 = ContentModel(
  id: 'NMA_SUS_01',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.sustentabilidade,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Governo do Estado de São Paulo',
    collaborator: 'Instituto Butantã',
  ),
  contentInfo: ContentInfo(
    title: 'Serpentes e Gentes',
    description:
        'Exposição virtual que apresenta o mundo das serpentes e a sua importância para o meio natural, além de diversas curiosidades sobre venenos e tipos de serpentes',
    subjects: ['Serpentes', 'Sustentabilidade', 'Exposição'],
    contentNote:
        'O Brasil possui cerca de 400 espécies de serpentes com uma diversidade enorme de cores e formas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://serpentesegentes.butantan.gov.br/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
