import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_IC_06 = ContentModel(
  id: 'CP_IC_06',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.identidadesCulturais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
    collaborator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
  ),
  contentInfo: ContentInfo(
    title: 'Atlas Geográfico Escolar',
    description:
        'O Atlas apresenta o tema de características demográficas da população brasileira por cor ou raça',
    subjects: ['Brasil', 'Dados demográficos', 'Atlas'],
    contentNote: 'Informações apresentadas em formatos de mapas temáticos e gráfico',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://atlasescolar.ibge.gov.br/brasil/3053-caracteristicas-demograficas/cor-ou-raca.html',
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
