import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_ERB_06 = ContentModel(
  id: 'EUR_ERB_06',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Canal Futura',
    collaborator: 'Canal Futura - Youtube',
  ),
  contentInfo: ContentInfo(
    title: 'Florestabilidade - Ep12 - Açaí',
    description:
        'Série educativa que visa difundir diversas formas de manejos da extração de produtos da floresta de forma sustentável',
    subjects: ['Paisagem rural', 'Agricultura', 'Documentário'],
    contentNote:
        'O episódio aborda o manejo de um fruto florestal não madeireiro: o açaí. Somos apresentados à árvore que gera esse fruto. Além disso, através de infográficos podemos ver os diferentes destinos de cada parte do açaí, sejam elas a casca, a polpa, o cacho, ou os caroços. Todas essas utilidades do fruto mostram que ele é um importante elemento econômico da floresta amazônica',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 11, 28),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/zt-nxmze3ME',
    issueYear: 2014,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
