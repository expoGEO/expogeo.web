import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_GM_05 = ContentModel(
  id: 'EUR_GM_05',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Departamento Nacional de Infraestrutura de Transportes',
    collaborator: 'Departamento Nacional de Infraestrutura de Transportes',
  ),
  contentInfo: ContentInfo(
    title: 'Infraestrutura de Dados Espaciais - DNIT',
    description:
        'WebSIG que apresenta informações geográficas sobre a infraestrutura de transportes no Brasil',
    subjects: ['Sistema de transportes', 'Mobilidade', 'Brasil'],
    contentNote:
        'WebSIG que apresenta informações geográficas sobre a infraestrutura de transportes no Brasil',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://servicos.dnit.gov.br/vgeo/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
