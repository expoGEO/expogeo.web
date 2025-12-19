import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_IT_04 = ContentModel(
  id: 'EUR_IT_04',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.industriaTransformacao,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Museu da cana',
    collaborator: 'Museu da cana',
  ),
  contentInfo: ContentInfo(
    title: 'A História da Cana de Açúcar no Brasil e no Mundo',
    description:
        'A exposição traz a apresentação de forma cronológica, sobre a História da Cana de Açúcar no Brasil e Mundo',
    subjects: ['Indústria', 'História', 'Cana de açúcar'],
    contentNote:
        'A Exposição "A História da Cana de Açúcar no Brasil e no Mundo", é representada em 16 painéis com ilustrações e textos que refazem a história da cana-de-açúcar, desde seu cultivo inicial na Nova Guiné em 8000 a.C., passando por sua chegada em terras paulistas pelas mãos de Martin Afonso de Souza por volta de 1500, refaz o percurso da cultura pelo mundo até nossa época',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 11, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://sites.google.com/view/museudacana/a-exposi%C3%A7%C3%A3o?authuser=0',
    issueYear: 2015,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
