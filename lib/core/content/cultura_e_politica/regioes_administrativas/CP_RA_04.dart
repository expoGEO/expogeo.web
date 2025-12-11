import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_RA_04 = ContentModel(
  id: 'CP_RA_05',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
    collaborator: 'Diretoria de Geociências',
  ),
  contentInfo: ContentInfo(
    title: 'Atlas Geográfico Escolar',
    description:
        'Atlas virtual que apresenta informações sobre a federação e o território brasileiro',
    subjects: ['Regiões administrativas', 'Brasil', 'Atlas'],
    contentNote:
        'Os temas apresentados são capitanias hereditárias, império 1872, república 1940, malha municipal 1940, malha municipal 2021, criação de municípios',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 3),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://atlasescolar.ibge.gov.br/brasil/3035-federacao-e-territorio/evolucao-da-divisao-politico-administrativa.html',
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
