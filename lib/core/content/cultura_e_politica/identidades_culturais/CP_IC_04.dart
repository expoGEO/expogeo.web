import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_IC_04 = ContentModel(
  id: 'CP_IC_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Rio memórias',
    collaborator: 'Rio memórias',
  ),
  contentInfo: ContentInfo(
    title: 'Rio: suas ruas, sua gente',
    description:
        'A Exposição fotográfica que apresenta o Rio de Janeiro a partir da historicidade e memória urbana',
    subjects: ['Rio de Janeiro', 'Urbanidade', 'Fotografia'],
    contentNote:
        'A Exposição fotográfica que apresenta o Rio de Janeiro a partir da historicidade e memória urbana',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://riomemorias.com.br/exposicoes_galerias/rio-suas-ruas-sua-gente/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
