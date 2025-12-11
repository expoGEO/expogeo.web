import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_EFR_04 = ContentModel(
  id: 'NMA_EFR_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Novo Tempo',
    collaborator: 'Origens NT',
  ),
  contentInfo: ContentInfo(
    title: 'Pangeia: a grande catástrofe',
    description: 'Documentário que aborda a constituição dos continentes no planeta Terra',
    subjects: ['Pangeia', 'Continentes', 'Documentário'],
    contentNote: 'Documentário que aborda a constituição dos continentes no planeta Terra',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 11),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/EwlYZWOUlg4',
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
