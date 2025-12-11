import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_TPCL_01 = ContentModel(
  id: 'NMA_TPCL_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Wordwall',
    collaborator: 'Cursog9com',
  ),
  contentInfo: ContentInfo(
    title: 'Questionário - Climas do Brasil',
    description: 'Site que apresenta questionário sobre os tipos climáticos do Brasil',
    subjects: ['Brasil', 'Tipos climáticos', 'Questionário'],
    contentNote: 'O questionário contém sete questões sobre os tipos climáticos do Brasil',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://wordwall.net/pt/resource/16711443/climas-do-brasil',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
