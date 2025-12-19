import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_IT_02 = ContentModel(
  id: 'EUR_IT_02',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.industriaTransformacao,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Confederação Nacional das Indústrias',
    collaborator: 'Confederação Nacional das Indústrias',
  ),
  contentInfo: ContentInfo(
    title: 'Perfil da indústria brasileira - A indústria brasileira no mundo',
    description:
        'Site que apresenta informações sobre produção industrial brasileira com dados e gráficos estatísticos',
    subjects: ['Indústria', 'Produção', 'Dados estatísticos'],
    contentNote:
        'Site que apresenta informações sobre produção industrial brasileira com dados e gráficos estatísticos. Tema de estudo: Indústria brasileira no mundo',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 11, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://industriabrasileira.portaldaindustria.com.br/grafico/total/mundo/#/industria-total',
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
