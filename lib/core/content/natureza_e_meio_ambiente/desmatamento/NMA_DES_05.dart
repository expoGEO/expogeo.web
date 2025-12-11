import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_DES_05 = ContentModel(
  id: 'NMA_DES_05',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Ministério Público do Estado do Tocantins - MPTO',
    collaborator: 'Centro de Apoio Operacional de Habilitação, Urbanismo e Meio Ambiente - CAOMA',
  ),
  contentInfo: ContentInfo(
    title: 'Painel de Monitoramento do Desmatamento no Tocantins',
    description:
        'Site que funciona como um painel desenvolvido pelo MPTO com os dados de desmatamento no Estado do Tocantins',
    subjects: ['Desmatamento', 'Monitoramento', 'Painel'],
    contentNote:
        'Site que funciona como um painel desenvolvido pelo MPTO com os dados de desmatamento no Estado do Tocantins',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 18),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://storymaps.arcgis.com/stories/ca3768747cdc4274bade5ed9179bed0d',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
