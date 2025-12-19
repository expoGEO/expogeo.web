import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_BIO_06 = ContentModel(
  id: 'NMA_BIO_06',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.biomas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Universidade de Brasília',
    collaborator: 'Museu Virtual',
  ),
  contentInfo: ContentInfo(
    title: 'Cerrado: Patrimônio dos brasileiros',
    description:
        'Exposição virtual que apresenta informações, fotografias e mapas do cerrado brasileiro',
    subjects: ['Cerrado', 'Brasil', 'Exposição'],
    contentNote:
        'O Cerrado é o segundo maior bioma brasileiro, tendo apenas menor área que a Amazônia. Localizado no centro do país que corresponde a cerca de 22% do território nacional',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 13),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'http://cerrado.museuvirtual.unb.br/index.php/meios/relevo-geologia',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
