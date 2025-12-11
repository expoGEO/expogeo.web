import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_BH_01 = ContentModel(
  id: 'NMA_BH_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Manual do Mundo',
    collaborator: 'Manual do Mundo',
  ),
  contentInfo: ContentInfo(
    title: 'Como funciona o encontro das águas',
    description:
        'Vídeo que aborda o encontro dos rios Negro e Solimões, e é possível ver esse encontro nitidamente, pois as águas não se misturam e têm cores diferentes',
    subjects: ['Bacias hidrográficas', 'Amazônia', 'Vídeo'],
    contentNote:
        'O rio Solimões é o maior e vem dos Andes, então ele sai com muita velocidade das montanhas e acaba arrancando terra pelo caminho, tendo uma água mais barrenta e opaca. Já o rio Negro vem de uma região mais plana e que alaga, então ele recebe muito mais folhas, galhos e troncos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 9),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/9r8qXlkFYaw',
    issueYear: 2019,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
