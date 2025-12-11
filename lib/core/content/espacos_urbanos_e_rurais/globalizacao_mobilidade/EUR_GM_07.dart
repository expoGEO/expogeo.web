import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_GM_07 = ContentModel(
  id: 'EUR_GM_07',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Museu da Pessoa',
    collaborator: '99',
  ),
  contentInfo: ContentInfo(
    title: 'Exposição virtual "Pessoas e Cidades – Histórias em movimento"',
    description:
        'A exposição Pessoas e Cidades, Histórias em Movimento, parceria da 99 com o Museu da Pessoa, evidencia que por trás de cada corrida há inúmeras histórias de vida, que vão muito além de um compartilhamento de viagem',
    subjects: ['Narrativas', 'Mobilidade', 'Transporte de aplicativo'],
    contentNote:
        'A exposição virtual evidencia que por trás de cada corrida há inúmeras histórias de vida, que vão muito além de um compartilhamento de viagem',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www2.museudapessoa.org/exposicoes/historias-em-movimento-99/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
