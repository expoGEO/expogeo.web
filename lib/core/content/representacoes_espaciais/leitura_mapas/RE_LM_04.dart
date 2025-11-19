import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_LM_04 = ContentModel(
  id: 'RE_LM_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Virtual para o Desenvolvimento Sustentável',
    collaborator: 'Instituto Virtual para o Desenvolvimento Sustentável',
  ),
  contentInfo: ContentInfo(
    title: 'Exposição Virtual – Mapas Estáticos',
    description: 'Site com diversos mapas estatísticos sobre a região amazônica',
    subjects: ['Mapa temático', 'Estatística', 'Amazônia'],
    contentNote:
        'Site do IVIDES com diversos mapas estatísticos sobre a região amazônica',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.imagem,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://ivides.org/exposicao-virtual-mapas-estaticos',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);


