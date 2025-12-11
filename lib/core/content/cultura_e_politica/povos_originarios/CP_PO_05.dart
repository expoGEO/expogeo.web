import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_PO_05 = ContentModel(
  id: 'CP_PO_05',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Universidade Federal do Rio Grande do Sul',
    collaborator: 'Universidade Federal do Rio Grande do Sul',
  ),
  contentInfo: ContentInfo(
    title: 'Etnomapeamento - Contracartografias',
    description:
        'WebSIG que apresenta informações do Etnomapeamento realizado pela UFRGS nas comunidades Mbyá-guarani da Tekoá Anhentenguá e Pindó Mirim',
    subjects: ['Indígenas', 'Rio Grande do Sul', 'WebSIG'],
    contentNote:
        'Criado nas atividades do Projeto de Pesquisa "Modelagem da dinâmica espacial para geração de cenários de mudanças de uso e cobertura da terra no Estado do Rio Grande do Sul" e dos Projetos de Extensão "Subsídios geotecnológicos para elaboração de etnomapeamento da comunidade mbyá-guarani da Tekoá Anhetenguá" e "Elaboração de etnomapeamento e diagnóstico etnoambiental participativo da comunidade mbyá-guarani da Tekoá Pindó Mirim"',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.arcgis.com/apps/dashboards/00f4d5e67cd2472ab7b83e3392348919',
    issueYear: 2022,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
