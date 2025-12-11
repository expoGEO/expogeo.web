import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_ERB_08 = ContentModel(
  id: 'EUR_ERB_08',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
    collaborator: 'Diretoria de Geociências',
  ),
  contentInfo: ContentInfo(
    title: 'Atlas do Espaço Rural Brasileiro',
    description:
        'Atlas que visa retratar o Brasil com informações necessárias ao conhecimento de sua realidade e ao exercício da cidadania',
    subjects: ['Atlas', 'Espaço rural', 'Informação geográfica'],
    contentNote:
        'O Atlas do espaço rural brasileiro traz um temário que, apesar de amplo, está longe de pretender cobrir todos os aspectos e questões inseridas na complexa temática que envolve o mundo rural brasileiro na contemporaneidade',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 11, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.ibge.gov.br/apps/atlasrural/#/home/',
    issueYear: 2017,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
