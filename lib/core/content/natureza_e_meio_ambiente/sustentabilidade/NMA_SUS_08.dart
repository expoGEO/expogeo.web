import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_SUS_08 = ContentModel(
  id: 'NMA_SUS_08',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Chico Mendes de Bioconversação - ICMBio',
    collaborator: 'Instituto Chico Mendes de Bioconversação - ICMBio',
  ),
  contentInfo: ContentInfo(
    title: 'O valor das unidades de conservação para a sociedade brasileira',
    description:
        'Vídeo que promove a importância em preservar o paraíso natural brasileiro para as presentes e futuras gerações',
    subjects: ['Sustentabilidade', 'Unidades de conservação', 'Vídeo'],
    contentNote:
        'A riqueza biológica, cultural e social é estratégica para o Brasil. Todos nós usufruímos dos benefícios gerados pela natureza. As unidades de conservação significam a sobrevivência para os centros urbanos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/nAzfNTDR4d8',
    issueYear: 2018,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
