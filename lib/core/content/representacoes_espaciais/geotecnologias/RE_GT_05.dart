import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_GT_05 = ContentModel(
  id: 'RE_GT_05',
  intellectualIndicator: const IntellectualIndicator(creator: 'Google', collaborator: 'Google'),
  contentInfo: ContentInfo(
    title: 'Google Earth',
    description: 'Websig que apresenta informações geográficas sobre o globo terrestre',
    subjects: ['Mapa colaborativo', 'Cartografia digital', 'Geotecnologia'],
    contentNote: 'Websig que apresenta informações geográficas sobre o globo terrestre',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://earth.google.com/web/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
