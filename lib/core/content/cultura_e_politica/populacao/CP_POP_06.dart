import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_POP_06 = ContentModel(
  id: 'CP_POP_06',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.demografia,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'Museum Alka of Sinj',
  ),
  contentInfo: ContentInfo(
    title: 'Croácia: corações e artesanato',
    description:
        'Exposição virtual que apresenta as cores, sons e especialidades da cultura croata',
    subjects: ['Croácia', 'Cultura', 'Exposição'],
    contentNote:
        'Exposição que apresenta a cultura, natureza, sons, festividades, costumes, danças, artesanato e outros tema deste importante país europeu',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 3),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/project/croatia-intangible-heritage',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
