import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_GT_03 = ContentModel(
  id: 'RE_GT_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Ministério do Planejamento e Orçamento',
    collaborator: 'Instituto Brasileiro de Geografia e Estatística',
  ),
  contentInfo: ContentInfo(
    title: 'Infraestrutura Nacional de Dados Espaciais (INDE)',
    description:
        'Websig que apresenta informações geográficas sobre características do território brasileiro',
    subjects: ['Mapa temático', 'Geografia brasileira', 'Geotecnologia'],
    contentNote:
        'Websig com informações geográficas do território brasileiro provenientes de diversas instituições oficiais em níveis federal, estadual e municipal',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://visualizador.inde.gov.br/',
    issueYear: 2008,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
