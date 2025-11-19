import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_GT_02 = ContentModel(
  id: 'RE_GT_02',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística',
    collaborator: 'Instituto Brasileiro de Geografia e Estatística',
  ),
  contentInfo: ContentInfo(
    title: 'Mapas interativos',
    description:
        'Websig que apresenta informações geográficas sobre características do território brasileiro',
    subjects: ['Mapa temático', 'Geografia brasileira', 'Geotecnologia'],
    contentNote:
        'Websig com dados geográficos sobre características do território brasileiro (geologia, relevo, solos, climas e outros temas)',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://mapasinterativos.ibge.gov.br/sigibge/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);


