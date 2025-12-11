import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_RM_02 = ContentModel(
  id: 'NMA_RM_02',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Universidade de São Paulo',
    collaborator: 'Instituto de Geociências',
  ),
  contentInfo: ContentInfo(
    title: 'Areias',
    description:
        'Acervo de exemplares de amostras de sedimentos de diversas regiões do mundo que podem ser usados para estudos, de forma geral sendo principalmente focado em atividades didáticas da área de Geociências',
    subjects: ['Areia', 'Recurso mineral', 'Exposição'],
    contentNote:
        'Acervo de exemplares de amostras de sedimentos de diversas regiões do mundo que podem ser usados para estudos de forma geral, sendo principalmente focado em atividades didáticas da área de Geociências',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 13),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://areias.igc.usp.br/',
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
