import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_GP_04 = ContentModel(
  id: 'CP_GP_04',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.geopolitica,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Nexo Jornal',
    collaborator: 'Marcelo Viana Estevão de Moraes',
  ),
  contentInfo: ContentInfo(
    title: 'O retrocesso da grande estratégia geopolítica brasileira',
    description:
        'Reportagem que aborda os principais desafios geopolíticos impostos nos últimos anos e quais os cenários para a atuação diplomática brasileira no futuro',
    subjects: ['Brasil', 'Geopolítica', 'Reportagem'],
    contentNote:
        'A Unasul foi uma organização internacional integrada pelos 12 estados da América do Sul, criada com o objetivo de projetar o poder da região no redesenho da ordem global',
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
        'https://pp.nexojornal.com.br/ponto-de-vista/2021/07/26/o-retrocesso-da-grande-estrategia-geopolitica-brasileira',
    issueYear: 2021,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
