import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_DES_03 = ContentModel(
  id: 'NMA_DES_03',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.desmatamento,
  intellectualIndicator: const IntellectualIndicator(creator: 'Imazon', collaborator: 'Imazon'),
  contentInfo: ContentInfo(
    title: 'Sistema de Alerta de Desmatamento - SAD',
    description: 'Site que disponibiliza diversas informações sobre o desmatamento na Amazônia',
    subjects: ['Desmatamento', 'Monitoramento', 'Site'],
    contentNote:
        'Contém diversas publicações de alertas e discussões científicas sobre o desmatamento na Amazônia, atualizadas mensalmente',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 18),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://imazon.org.br/categorias/sad/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
