import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_CM_02 = ContentModel(
  id: 'RE_CM_02',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'National Geographic',
    collaborator: 'National Geographic',
  ),
  contentInfo: ContentInfo(
    title: 'MapMaker',
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
    location:
        'https://www.arcgis.com/apps/instant/atlas/index.html?appid=0cd1cdee853c413a84bfe4b9a6931f0d',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
