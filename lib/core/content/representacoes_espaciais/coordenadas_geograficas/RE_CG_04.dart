import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_CG_04 = ContentModel(
  id: 'RE_CG_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Público – Site de notícias',
    collaborator: 'Gonçalo Dias',
  ),
  contentInfo: ContentInfo(
    title: 'Longitude: um problema científico e tecnológico',
    description:
        'Matéria sobre como medir a longitude nas viagens marítimas tornou-se uma questão científica premente',
    subjects: ['Viagens marítimas', 'Longitude', 'Ciência'],
    contentNote:
        'Matéria do portal “Público” sobre a busca pela determinação do sistema de coordenadas geográficas, especialmente a questão da longitude',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 10),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.texto,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://www.publico.pt/2018/10/15/ciencia/ensaio/longitude-um-problema-cientifico-e-tecnologico-1847011',
    issueYear: 2018,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);


