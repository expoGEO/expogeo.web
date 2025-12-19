import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_PAG_03 = ContentModel(
  id: 'NMA_PAG_03',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.poluicaoAgua,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Agência Nacional das Águas e Saneamento Básico - ANA',
    collaborator: 'Portal Qualidade das Águas',
  ),
  contentInfo: ContentInfo(
    title: 'Avaliação de Qualidade das Águas',
    description:
        'Site que disponibiliza diversas informações sobre o monitoramento das águas superficiais no Brasil',
    subjects: ['Qualidade da água', 'Monitoramento', 'Site'],
    contentNote:
        'O monitoramento e a avaliação da qualidade das águas superficiais e subterrâneas são fatores primordiais para a adequada gestão dos recursos hídricos, permitindo a caracterização e a análise de tendências em bacias hidrográficas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 18),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.ana.gov.br/portalpnqa/avaliacao.aspx',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
