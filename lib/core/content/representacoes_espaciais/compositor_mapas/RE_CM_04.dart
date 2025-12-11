import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_CM_04 = ContentModel(
  id: 'RE_CM_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
    collaborator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
  ),
  contentInfo: ContentInfo(
    title: 'Mapeamento temático',
    description: 'Site que informações sobre a composição de mapas temáticos',
    subjects: ['Cartografia', 'Elaboração de mapas', 'Tecnologia'],
    contentNote: 'Site que informações sobre a composição de mapas temáticos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 15),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://atlasescolar.ibge.gov.br/cartografia/21738-mapeamento-tematico.html',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
