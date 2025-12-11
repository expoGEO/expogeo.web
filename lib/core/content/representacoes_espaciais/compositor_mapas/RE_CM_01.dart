import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_CM_01 = ContentModel(
  id: 'RE_CM_01',
  intellectualIndicator: const IntellectualIndicator(creator: 'Google', collaborator: 'Google'),
  contentInfo: ContentInfo(
    title: 'Google MyMaps',
    description:
        'Site que funciona como compositor de mapas utilizando a base de dados geográficos Google Maps',
    subjects: ['Cartografia', 'Compositor de mapas', 'Tecnologia'],
    contentNote:
        'Site que funciona como compositor de mapas utilizando a base de dados geográficos Google Maps',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 15),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.google.com/intl/pt-BR/maps/about/mymaps/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
