import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_TC_03 = ContentModel(
  id: 'NMA_TC_03',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.tempoClima,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'Google Arts and Culture',
  ),
  contentInfo: ContentInfo(
    title: 'A viagem ao Polo Sul',
    description:
        'Exposição virtual narra a história da primeira expedição a chegar ao ponto mais meridional do nosso planeta',
    subjects: ['Expedição', 'Polo Sul', 'Exposição'],
    contentNote:
        'Uma extensão congelada de branco até onde a vista alcança, onde o céu branco encontra o horizonte branco. Está muito frio, com temperaturas atingindo -89,2° C e ventos gelados atingindo até 320 km/h. Bem-vindo ao lugar mais remoto do nosso planeta: a Antártica',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 10),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://artsandculture.google.com/story/the-journey-to-the-south-pole/6QLys_jAalyhIA',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
