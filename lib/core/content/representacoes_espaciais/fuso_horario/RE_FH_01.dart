import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_FH_01 = ContentModel(
  id: 'RE_FH_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística',
    collaborator: 'Instituto Brasileiro de Geografia e Estatística',
  ),
  contentInfo: ContentInfo(
    title: 'Fuso horário',
    description: 'Mapa da delimitação dos fusos horários no planeta',
    subjects: ['Fuso horário', 'Longitude', 'Divisão regional'],
    contentNote: 'Mapa que apresenta a divisão regional dos fusos horários no planeta',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.imagem,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://atlasescolar.ibge.gov.br/mundo/2984-divisoes-politicas-e-regionais/fuso-horario.html',
    issueYear: 2024,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);


