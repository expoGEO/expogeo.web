import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_LM_06 = ContentModel(
  id: 'RE_LM_06',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Universidade de Estado de São Paulo',
    collaborator: 'Biblioteca Brasiliana Guita e José Mindlin',
  ),
  contentInfo: ContentInfo(
    title: 'Atlas dos Viajantes no Brasil',
    description:
        'WebSIG com informações associadas aos caminhos percorridos por diferentes viajantes e suas explorações no Brasil',
    subjects: ['WebSIG', 'Viajantes', 'Brasil'],
    contentNote:
        'WebSIG que reúne informações sobre caminhos percorridos por viajantes em suas explorações no Brasil',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://viajantes.bbm.usp.br/',
    issueYear: 2021,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);


