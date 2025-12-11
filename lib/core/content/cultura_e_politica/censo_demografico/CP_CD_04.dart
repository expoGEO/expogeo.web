import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_CD_04 = ContentModel(
  id: 'CP_CD_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
    collaborator: 'IBGE Educa - Jovens',
  ),
  contentInfo: ContentInfo(
    title: 'Características dos domicílios - Censo 2022',
    description:
        'Site que apresenta informações referentes aos dados coletados pelo Censo Demográfico 2022',
    subjects: ['Demografia', 'Censo demográfico', 'Site'],
    contentNote:
        'Dados sobre os diversos aspectos dos domicílios da população brasileira que podem te ajudar em suas pesquisas, seja para a escola ou para sua curiosidade',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 5),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://educa.ibge.gov.br/jovens/conheca-o-brasil/populacao/22064-caracteristicas-dos-domicilios-censo-2022.html',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
