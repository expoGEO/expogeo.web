import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_EFR_02 = ContentModel(
  id: 'NMA_EFR_02',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.estruturasFormasRelevo,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator:
        'Patrimônio Mundial - UNESCO e Escritório do Patrimônio Mundial, Província Autônoma Especial de Jeju',
  ),
  contentInfo: ContentInfo(
    title: 'Ilha Vulcânica de Jeju e Tubos de Lava - República da Coreia',
    description:
        'Exposição virtual que aborda as paisagens da Ilha Vulcânica de Jeju e Tubos de Lava - República da Coreia',
    subjects: ['Relevo', 'Ilha de Jeju', 'Exposição'],
    contentNote:
        'A Ilha Vulcânica e Tubos de Lava de Jeju é uma propriedade serial coerente composta por três componentes. A qualidade inigualável do sistema de tubos de lava Geomunoreum e a exibição de características vulcânicas diversas e acessíveis nos outros dois componentes demonstram uma contribuição distinta e importante para a compreensão do vulcanismo global',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/story/PwURWFnBDOBRKg',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
