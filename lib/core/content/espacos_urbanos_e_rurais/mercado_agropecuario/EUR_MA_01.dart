import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_MA_01 = ContentModel(
  id: 'EUR_MA_01',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.mercadoAgropecuario,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator:
        'Além da Carne, Sky Greens, WikiFoods, Original Unverpackt, Proveniência e INDEX: Design para Melhorar a Vida',
  ),
  contentInfo: ContentInfo(
    title: '5 designs que definem o futuro da alimentação',
    description:
        'Da agricultura vertical às embalagens de alimentos comestíveis, o que e como comeremos no futuro?',
    subjects: ['Agropecuária', 'Alimentação', 'Exposição virtual'],
    contentNote:
        'Da agricultura vertical às embalagens de alimentos comestíveis, o que e como comeremos no futuro?',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://g.co/arts/ZXR2K7KSqsfXb2bt6',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
