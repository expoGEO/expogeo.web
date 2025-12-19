import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_CG_05 = ContentModel(
  id: 'RE_CG_05',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.coordenadasGeograficas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Racha-cuca',
    collaborator: 'Racha-cuca',
  ),
  contentInfo: ContentInfo(
    title: 'Batalha naval',
    description:
        'Jogo batalha naval que permite compreender a lógica de cruzamento de pontos no sistema de coordenadas geográficas',
    subjects: ['Latitude', 'Longitude', 'Coordenadas geográficas'],
    contentNote:
        'Atividade interativa que auxilia na compreensão do cruzamento de pontos no sistema de coordenadas geográficas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 10),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://rachacuca.com.br/jogos/batalha-naval/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
