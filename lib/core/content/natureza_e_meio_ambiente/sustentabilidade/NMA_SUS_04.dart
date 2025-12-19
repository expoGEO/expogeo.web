import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_SUS_04 = ContentModel(
  id: 'NMA_SUS_04',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.sustentabilidade,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'Museu do Amanhã',
  ),
  contentInfo: ContentInfo(
    title: 'Planeta em metamorfose',
    description:
        'Exposição virtual que informa como os processos naturais do planeta estão sendo profundamente modificados pelo impacto da ação humana',
    subjects: ['Sustentabilidade', 'Ação humana', 'Exposição'],
    contentNote:
        'Mudanças climáticas, interferência no ciclo das águas e uma taxa acelerada de extinção de espécies são algumas evidências de que temos nos transformado em uma força geológica. Pensar como este impacto afeta a própria espécie humana é um um dos grandes desafios do tempo em que vivemos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/story/SQUBWNrRk-XCIw',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
