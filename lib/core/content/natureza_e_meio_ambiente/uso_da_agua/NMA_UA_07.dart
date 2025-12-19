import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_UA_07 = ContentModel(
  id: 'NMA_UA_07',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.usoAgua,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Agência Nacional das Águas - ANA',
    collaborator: 'Agência Nacional das Águas - ANA',
  ),
  contentInfo: ContentInfo(
    title: 'O Uso Racional da Água',
    description: 'Vídeo que aborda o uso racional da água',
    subjects: ['Água', 'Consumo', 'Vídeo'],
    contentNote: 'É necessário saber usar a água para não faltar',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 9),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/JtshF-n-mis',
    issueYear: 2015,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
