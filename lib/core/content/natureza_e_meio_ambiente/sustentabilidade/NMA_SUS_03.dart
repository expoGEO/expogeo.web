import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_SUS_03 = ContentModel(
  id: 'NMA_SUS_03',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.sustentabilidade,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Governo do Estado de São Paulo',
    collaborator: 'Instituto Biológico',
  ),
  contentInfo: ContentInfo(
    title: 'Planeta inseto',
    description:
        'Exposição virtual que apresenta diversas espécies de insetos e as suas contribuições para o equilíbrio da natureza',
    subjects: ['Sustentabilidade', 'Insetos', 'Exposição'],
    contentNote:
        'Os temas abordados são: O que são insetos; Besouro; Formigas; Abelhas; Bicho da seda; Controle biológico; Baratas; Controle biológico e Laboratório etnomológico',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 17),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://view.genially.com/5f29d093dfd2410db87427fa/interactive-image-visitacao-virtual-ao-planeta-inseto',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
