import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_PO_06 = ContentModel(
  id: 'CP_PO_06',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Arquivo Nacional',
    collaborator: 'Arquivo Nacional',
  ),
  contentInfo: ContentInfo(
    title: 'Itinerários indígenas',
    description:
        'Itinerários Indígenas trata de deslocamentos de diversas ordens, com outras leituras do território, do tempo histórico, dos povos indígenas e do acervo do Arquivo Nacional',
    subjects: ['Itinerários indígenas', 'Narrativas', 'Exposição'],
    contentNote:
        'Diferentes itinerários percorridos por cronistas, religiosos, naturalistas, militares, fotógrafos, antropólogos e administradores, que tiveram contato com os indígenas aos quais impuseram cartografias, língua, cultura, crenças e também a violência física',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://exposicoesvirtuais.an.gov.br/index.php/galerias/10-exposicoes/357-itiner%C3%A1rios-ind%C3%ADgenas.html',
    issueYear: 2018,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
