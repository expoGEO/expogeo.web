import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_RM_06 = ContentModel(
  id: 'NMA_RM_06',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Governo do Estado de Minas Gerais',
    collaborator: 'A Companhia de Desenvolvimento de Minas Gerais - CODEMGE',
  ),
  contentInfo: ContentInfo(
    title: 'Portal da Geologia',
    description:
        'Site que oferece de forma interativa mapas geológicos relacionados ao Estado de Minas Gerais',
    subjects: ['Geologia', 'Minas Gerais', 'Mapas'],
    contentNote:
        'Site que oferece de forma interativa mapas geológicos relacionados ao Estado de Minas Gerais',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 13),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'http://www.portalgeologia.com.br/index.php/mapa/',
    issueYear: 2024,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
