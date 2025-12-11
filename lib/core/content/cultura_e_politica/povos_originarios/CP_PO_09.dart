import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_PO_09 = ContentModel(
  id: 'CP_PO_09',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Native Land Digital',
    collaborator: 'Native Land Digital',
  ),
  contentInfo: ContentInfo(
    title: 'Native Land Digital Map',
    description:
        'WebSIG que apresenta informações sobre as nações indígenas ao redor do globo terrestre',
    subjects: ['Indígenas', 'Nações', 'WebSIG'],
    contentNote:
        'O mapa é um documento vivo, informado pelas contribuições de comunidades indígenas, detentores de conhecimento indígena e suas histórias. Ele não pretende representar limites oficiais ou legais',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Inglês',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet e solicitar tradução da página pelo Google Tradutor',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://native-land.ca/',
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
