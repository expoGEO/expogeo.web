import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_GM_03 = ContentModel(
  id: 'EUR_GM_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'WebGL Globe',
    collaborator: 'WebGL Globe',
  ),
  contentInfo: ContentInfo(
    title: 'WebGL Globe - Plataforma de dados geográficos',
    description: 'Site que apresenta dados geográficos sobre diversos temas em nível global',
    subjects: ['Globalização', 'Dados geográficos', 'Modelagem 3D'],
    contentNote: 'Site que apresenta dados geográficos sobre diversos temas em nível global',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Inglês',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://experiments.withgoogle.com/chrome/globe',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre - Google'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
