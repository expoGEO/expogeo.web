import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_EFR_05 = ContentModel(
  id: 'NMA_EFR_05',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.estruturasFormasRelevo,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Novo Tempo',
    collaborator: 'Origens NT',
  ),
  contentInfo: ContentInfo(
    title: 'Datação: a grande catástrofe',
    description: 'Documentário que aborda a constituição dos continentes no planeta Terra',
    subjects: ['Datação', 'Tempo geológico', 'Documentário'],
    contentNote: 'Documentário que aborda a constituição dos continentes no planeta Terra',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/TfuzPIIMNss',
    issueYear: 2016,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
