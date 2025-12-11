import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_GP_03 = ContentModel(
  id: 'CP_GP_03',
  intellectualIndicator: const IntellectualIndicator(creator: 'Umap', collaborator: 'Umap'),
  contentInfo: ContentInfo(
    title: 'Notícias do conflito no Irã',
    description:
        'WebSIG que localiza os fatos mais relevantes em tempo real sobre o conflito armado no Irã e suas fronteiras',
    subjects: ['Conflito armado', 'Geopolítica', 'WebSIG'],
    contentNote:
        'WebSIG que localiza os fatos mais relevantes em tempo real sobre o conflito armado no Irã e suas fronteiras',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 5),
    language: 'Inglês – Utilizar o Google Tradutor para Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://iran.liveuamap.com/',
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
