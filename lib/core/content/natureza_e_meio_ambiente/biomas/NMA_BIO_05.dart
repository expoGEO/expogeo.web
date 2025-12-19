import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_BIO_05 = ContentModel(
  id: 'NMA_BIO_05',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.biomas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'MapBiomas',
    collaborator: 'MapBiomas',
  ),
  contentInfo: ContentInfo(
    title: 'MapBiomas',
    description:
        'WebSIG que fornece mapas e dados anuais de cobertura e uso da terra do Brasil para o período de 1985 a 2023',
    subjects: ['Brasil', 'Biomas', 'WebSIG'],
    contentNote:
        'Esta coleção é fruto de nove anos de trabalho do projeto MapBiomas e está em constante desenvolvimento',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 13),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://plataforma.brasil.mapbiomas.org/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
