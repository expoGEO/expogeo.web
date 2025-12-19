import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_TC_01 = ContentModel(
  id: 'NMA_TC_01',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.tempoClima,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Ministério da Ciência, Tecnologia e Inovação',
    collaborator: 'Centro de Previsão de Tempo e Estudos Climáticos – CPTEC/INPE',
  ),
  contentInfo: ContentInfo(
    title: 'Previsão do tempo',
    description:
        'Site que apresenta diversas informações sobre a previsão do tempo nos municípios brasileiros',
    subjects: ['Previsão do tempo', 'Climatologia', 'Site'],
    contentNote: 'São apresentados os temas: Clima; Previsão Numérica de tempo; Satélite e Ondas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 10),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.cptec.inpe.br/',
    issueYear: 2024,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
