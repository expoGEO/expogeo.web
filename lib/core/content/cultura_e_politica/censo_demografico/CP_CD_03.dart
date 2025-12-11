import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_CD_03 = ContentModel(
  id: 'CP_CD_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
    collaborator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
  ),
  contentInfo: ContentInfo(
    title: 'Censo Demográfico 2022 – Panorama - Mapas',
    description:
        'WebSIG que apresenta informações referentes aos dados coletados pelo Censo Demográfico 2022',
    subjects: ['Demografia', 'Censo demográfico', 'WebSIG'],
    contentNote:
        'Os dados encontram-se organizados em temas (População, Domicílios e Territórios), apresentando um conjunto de mapas disponíveis',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 5),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://censo2022.ibge.gov.br/panorama/mapas.html?recorte=N3&tema=populacao',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
