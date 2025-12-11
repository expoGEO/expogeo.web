import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_UA_01 = ContentModel(
  id: 'NMA_UA_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Cultural Vale',
    collaborator: 'Memorial Minas Gerais Vale',
  ),
  contentInfo: ContentInfo(
    title: 'O recado das águas',
    description:
        'Esta exposição segue os caminhos dos trabalhos de campo no Vale do rio Peruaçu, Norte de Minas Gerais - por ocasião da pesquisa de mestrado intitulada "Nas margens do rio Peruaçu, a apropriação da natureza e a natureza das práticas", no âmbito do Programa de pós graduação em geografia da UFMG',
    subjects: ['Água', 'Rio Peruaçu', 'Exposição'],
    contentNote:
        'O rio Peruaçu vem apresentando uma progressiva diminuição de sua vazão hídrica. Se antes era um rio onde se nadava, pescava e cultivava alimentos, com o passar do tempo tornou-se cenário de uma profunda escassez hídrica',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 5),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://memorialvale.com.br/virtual/recado-das-aguas/',
    issueYear: 2021,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
