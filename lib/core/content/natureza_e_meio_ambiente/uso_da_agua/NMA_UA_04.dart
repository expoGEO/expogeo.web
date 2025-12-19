import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_UA_04 = ContentModel(
  id: 'NMA_UA_04',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.usoAgua,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Confúcio para Negócios - Fundação Armando Alvares Penteado',
    collaborator: 'Museu de Arte Brasileira - Fundação Armando Alvares Penteado',
  ),
  contentInfo: ContentInfo(
    title: 'Liangzhu: reino das águas',
    description:
        'Exposição virtual com quatro salões virtuais que reproduzem a cultura e as características da cidade de Liangzhu. É possível vivenciar o estilo de vida dessa civilização devido a um recurso de tecnologia avançada',
    subjects: ['Recursos Hídricos', 'China', 'Exposição virtual'],
    contentNote:
        'Conceitos de identidade cultural, de organização social, política e desenvolvimento da sociedade e da cultura no final do período Neolítico e o início da Idade do Bronze, na China',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 9),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'http://en.chinaculture.org/liangzhu/file/Portugal/mainPortugal/',
    issueYear: 2021,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
