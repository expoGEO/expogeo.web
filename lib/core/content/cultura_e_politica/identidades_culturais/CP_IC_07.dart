import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_IC_07 = ContentModel(
  id: 'CP_IC_07',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.identidadesCulturais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Local Lingual',
    collaborator: 'Local Lingual',
  ),
  contentInfo: ContentInfo(
    title: 'Local Lingual - Map',
    description: 'Site que permite ouvir dialetos ao redor do mundo',
    subjects: ['Dialetos', 'Diversidade cultural', 'Mundo'],
    contentNote: 'Site que permite ouvir dialetos ao redor do mundo',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Inglês – Ativar a tradução do Google Tradutor',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://localingual.com/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
