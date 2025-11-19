import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_FH_03 = ContentModel(
  id: 'RE_FH_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Wordwall',
    collaborator: 'Perfil: Profluizão',
  ),
  contentInfo: ContentInfo(
    title: 'Fusos horários',
    description: 'Quiz interativo sobre o tema dos fusos horários',
    subjects: ['Fuso horário', 'Longitude', 'Movimentos da Terra'],
    contentNote: 'Quiz sobre o tema de estudo fuso horário',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://wordwall.net/pt/resource/30059696/fusos-hor%C3%A1rios',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);


