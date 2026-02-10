import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_TPCL_04 = ContentModel(
  id: 'NMA_TPCL_04',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.tiposClimaticos,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Robson Renato',
    collaborator: 'Recanto das letras',
  ),
  contentInfo: ContentInfo(
    title: 'Os climas do Brasil',
    description: 'Poesia criada para explicar os tipos climáticos do Brasil',
    subjects: ['Clima', 'Poesia', 'Brasil'],
    contentNote: 'Poesia criada para explicar os tipos climáticos do Brasil',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 10),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.recantodasletras.com.br/cordel/5547478',
    issueYear: 2016,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
