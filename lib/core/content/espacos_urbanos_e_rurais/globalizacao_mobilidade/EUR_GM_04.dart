import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_GM_04 = ContentModel(
  id: 'EUR_GM_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Biblioteca Central da Marinha',
    collaborator: 'Google Arts and Culture',
  ),
  contentInfo: ContentInfo(
    title: 'A primeira travessia aérea do Atlântico Sul',
    description:
        'Exposição virtual que apresenta a trajetória de Sacadura Cabral e Gago Coutinho, ambos oficias de Marinha, que executaram a primeira travessia aérea do Atlântico Sul, ligando Portugal ao Rio de Janeiro',
    subjects: ['Globalização', 'Mobilidade', 'Travessia aérea'],
    contentNote:
        'Exposição virtual que apresenta a trajetória de Sacadura Cabral e Gago Coutinho, que executaram a primeira travessia aérea do Atlântico Sul',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://g.co/arts/QNB6gDXGm4ZTD5Lz8',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre - Google'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
