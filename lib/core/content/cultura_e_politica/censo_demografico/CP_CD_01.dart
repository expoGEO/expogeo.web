import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_CD_01 = ContentModel(
  id: 'CP_CD_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
    collaborator: 'Sistema IBGE de Recuperação Automática - SIDRA',
  ),
  contentInfo: ContentInfo(
    title: 'Censo Demográfico 2022 - População e Domicílios: Primeiros Resultados do Universo',
    description:
        'Site que apresenta informações de população e domicílio referentes aos dados coletados pelo Censo Demográfico 2022',
    subjects: ['Demografia', 'Censo demográfico', 'Site'],
    contentNote:
        'Os dados encontram-se organizados em temas (População, Domicílios e Territórios), apresentando um conjunto de tabelas, e estão disponíveis para os níveis Brasil, Grande Região, Unidade da Federação, Região Geográfica Intermediária, Região Geográfica Imediata, Concentração Urbana e Município',
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
        'https://sidra.ibge.gov.br/pesquisa/censo-demografico/demografico-2022/primeiros-resultados-populacao-e-domicilios',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
