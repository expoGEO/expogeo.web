import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_POP_05 = ContentModel(
  id: 'CP_POP_05',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.demografia,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Berenice Bento',
    collaborator: 'Berenice Bento',
  ),
  contentInfo: ContentInfo(
    title: 'Palestina, meu amor',
    description:
        'Exposição virtual que apresenta a experiência da pesquisadora na Palestina, trazendo relato e fotografias que mostram a geograficidade do Oriente Médio',
    subjects: ['Palestina', 'Fotografia', 'Exposição'],
    contentNote:
        'O colonialismo israelense ocupa todos os poros da vida palestina. Da burocracia à violência letal, nada escapa ao controle colonial microfisico',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 3),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://berenicebento.com/palestina-meu-amor/',
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
