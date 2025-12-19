import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_PO_08 = ContentModel(
  id: 'CP_PO_08',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.povosOriginarios,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
    collaborator: 'Diretoria de Geociências',
  ),
  contentInfo: ContentInfo(
    title: 'Atlas Geográfico Escolar',
    description:
        'Site que apresenta o tema de características demográficas de povos e comunidades tradicionais com dados para todos os estados do Brasil',
    subjects: ['Indígenas', 'Dados demográficos', 'Atlas'],
    contentNote:
        'Compõe dados demográficos em diferentes representações, como mapas, gráficos e tabelas',
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
        'https://atlasescolar.ibge.gov.br/brasil/3105-caracteristicas-demograficas/povos-e-comunidades-tradicionais.html',
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
