import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_BIO_01 = ContentModel(
  id: 'NMA_BIO_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Universidade de Brasília',
    collaborator: 'Universidade de Brasília',
  ),
  contentInfo: ContentInfo(
    title: 'aVoar Cerrado',
    description:
        'Iniciativa de educação e divulgação científica, baseada na avifauna do bioma Cerrado. Trata-se de uma iniciativa pedagógica que busca aproximar a sociedade e o fazer científico',
    subjects: ['Aves', 'Cerrado', 'Site'],
    contentNote:
        'Prática de Ciência Cidadã voltadas para a popularização da observação de aves, por meio de diversos produtos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 13),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://avoarcerrado.unb.br/index.php',
    issueYear: 2023,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
