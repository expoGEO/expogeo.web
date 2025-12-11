import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_EUB_02 = ContentModel(
  id: 'EUR_EUB_02',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Arquivo Nacional',
    collaborator: 'Arquivo Nacional – Exposições virtuais',
  ),
  contentInfo: ContentInfo(
    title: 'Pontos de vista: fotografia e cidade em álbuns do Arquivo Nacional',
    description:
        'Apresenta imagens oriundas de quatro álbuns que se debruçam sobre Rio de Janeiro, Paris, Manaus e cidades americanas',
    subjects: ['Fotografia', 'Espaço urbano', 'História urbana'],
    contentNote:
        'Apresentação de fotografias históricas de áreas urbanas que promove uma reflexão sobre a evolução do espaço geográfico',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://exposicoesvirtuais.an.gov.br/index.php/galerias/10-exposicoes/380-pontos-de-vista-fotografia-e-cidade-em-%C3%A1lbuns-do-arquivo-nacional.html',
    issueYear: 2023,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
