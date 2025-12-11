import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_BIO_02 = ContentModel(
  id: 'NMA_BIO_02',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Empresa Brasileira de Pesquisa Agropecuária - EMBRAPA',
    collaborator: 'Empresa Brasileira de Pesquisa Agropecuária - EMBRAPA',
  ),
  contentInfo: ContentInfo(
    title: 'Nossa Caatinga, Nossa Riqueza',
    description: 'Exposição virtual que apresenta fotografias da Caatinga brasileira',
    subjects: ['Caatinga', 'Fotografia', 'Exposição'],
    contentNote: 'Exposição virtual que apresenta fotografias da Caatinga brasileira',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 13),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.embrapa.br/exposicao-caatinga',
    issueYear: 2023,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
