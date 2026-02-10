import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_EFR_06 = ContentModel(
  id: 'NMA_EFR_06',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.estruturasFormasRelevo,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística - IBGE',
    collaborator: 'Instituto Brasileiro de Geografia e Estatística - IBGE',
  ),
  contentInfo: ContentInfo(
    title: 'Atlas Geográfico Escolar',
    description: 'Atlas que apresenta informações sobre o relevo do Brasil',
    subjects: ['Brasil', 'Relevo', 'Atlas'],
    contentNote:
        'O Atlas apresenta mapas, perfil topográfico, modelagem 3D de relevo e vídeo sobre o relevo e fundo oceânico brasileiro',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://atlasescolar.ibge.gov.br/brasil/3024-diversidade-ambiental/3039-relevo.html',
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
