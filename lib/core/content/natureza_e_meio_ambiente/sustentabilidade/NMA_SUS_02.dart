import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_SUS_02 = ContentModel(
  id: 'NMA_SUS_02',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Prefeitura Municipal de Carambeí',
    collaborator: 'Museu Parque Histórico de Carambeí',
  ),
  contentInfo: ContentInfo(
    title: 'Abra as portas para o sustentável',
    description:
        'Exposição virtual que apresenta o conceito de sustentabilidade associado a diversas práticas cotidianas',
    subjects: ['Sustentabilidade', 'Conceito', 'Exposição'],
    contentNote:
        'Não existe uma definição universalmente aceita de sustentabilidade. Na verdade, existem muitos pontos de vista diferentes sobre este conceito e como ele pode ser alcançado',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.aphc.com.br/casadasustentabilidade/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
