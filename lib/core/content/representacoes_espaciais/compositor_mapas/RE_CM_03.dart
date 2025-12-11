import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_CM_03 = ContentModel(
  id: 'RE_CM_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'OpenStreetMap',
    collaborator: 'OpenStreetMap',
  ),
  contentInfo: ContentInfo(
    title: 'uMap',
    description:
        'Site que funciona como compositor de mapas utilizando a base de dados geográficos',
    subjects: ['Cartografia', 'Compositor de mapas', 'Tecnologia'],
    contentNote:
        'Site que funciona como compositor de mapas utilizando a base de dados geográficos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 15),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://umap.openstreetmap.fr/pt/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
