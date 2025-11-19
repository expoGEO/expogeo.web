import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_LM_01 = ContentModel(
  id: 'RE_LM_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística',
    collaborator: 'IBGE Educa - Jovens',
  ),
  contentInfo: ContentInfo(
    title: 'Mapas',
    description: 'Site com diversos mapas sobre o Brasil e o mundo',
    subjects: ['Mapa temático', 'Brasil', 'Atlas geográfico'],
    contentNote:
        'Site do IBGE Educa-Jovens com extensa relação de mapas temáticos sobre o Brasil e o mundo',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.imagem,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://educa.ibge.gov.br/jovens/jovens-mapas.html',
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


