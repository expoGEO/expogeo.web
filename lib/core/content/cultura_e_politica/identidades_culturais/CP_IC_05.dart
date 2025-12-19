import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_IC_05 = ContentModel(
  id: 'CP_IC_05',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.identidadesCulturais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Associação de Amigos do Jardim Botânico',
    collaborator: 'Associação de Amigos do Jardim Botânico',
  ),
  contentInfo: ContentInfo(
    title: 'Spix e Martius: uma viagem pelo Brasil',
    description:
        'A Exposição apresenta as dinâmicas das populações que viviam no Brasil nos anos 1817 e 1820',
    subjects: ['Brasil', 'Território', 'Expedições'],
    contentNote:
        'A Exposição apresenta as dinâmicas das populações que viviam no Brasil nos anos 1817 e 1820',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.expodigitalspixemartius.com.br/home.html',
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
