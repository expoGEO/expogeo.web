import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_BIO_03 = ContentModel(
  id: 'NMA_BIO_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Rodrigo Albertini',
    collaborator: 'Rodrigo Albertini',
  ),
  contentInfo: ContentInfo(
    title: 'Contemplatio',
    description: 'Exposição virtual que apresenta fotografias da Mata Atlântica',
    subjects: ['Mata Atlântica', 'Fotografia', 'Exposição'],
    contentNote: 'Exposição virtual que apresenta fotografias da Mata Atlântica',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 13),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://rodrigoalbertini.com.br/mata-atlantica/',
    issueYear: 2018,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
