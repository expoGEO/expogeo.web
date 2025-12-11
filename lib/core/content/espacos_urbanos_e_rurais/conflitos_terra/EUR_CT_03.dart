import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_CT_03 = ContentModel(
  id: 'EUR_CT_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Agência Pública',
    collaborator: 'Itamar Vieira Junior',
  ),
  contentInfo: ContentInfo(
    title: 'Os conflitos de terra em 5 minutos',
    description:
        'A animação mostra como os conflitos surgem, se intensificam, e mais pessoas morrem nessa luta',
    subjects: ['Agricultura', 'Movimento popular', 'Exposição'],
    contentNote:
        'É comum escutar que o Brasil é um país violento. Aborda-se nesta animação sobre a violência no campo, que tem tudo a ver com os conflitos por terra',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/ECBcFxPeKww',
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
