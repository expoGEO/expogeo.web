import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_UA_05 = ContentModel(
  id: 'NMA_UA_05',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.usoAgua,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Novo Tempo',
    collaborator: 'Origens - NT',
  ),
  contentInfo: ContentInfo(
    title: 'Essência da vida',
    description:
        'Documentário que apresenta a importância da água para o sustento da vida no planeta Terra',
    subjects: ['Água', 'Vida', 'Documentário'],
    contentNote:
        'Entre todas as substâncias complexas encontradas no universo, a água é aparentemente uma das mais simples e, ainda assim, a mais fundamental para o funcionamento do nosso planeta',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 9),
    language: 'Português',
    type: ContentType.documento,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/Cst5qxzCBfc',
    issueYear: 2017,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
