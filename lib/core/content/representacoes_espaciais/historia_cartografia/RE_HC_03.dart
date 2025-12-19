import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_HC_03 = ContentModel(
  id: 'RE_HC_03',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.historiaCartografia,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Fundação Biblioteca Nacional',
    collaborator: 'Biblioteca Nacional Digital',
  ),
  contentInfo: ContentInfo(
    title: 'Historica Cartographica Brasilis: Tesouros dos sécs. XV a XX',
    description:
        'Exposição virtual que apresenta registros cartográficos do Brasil numa perspectiva histórica que compreende os séculos XV a XX',
    subjects: ['Cartografia histórica', 'Brasil', 'Acervo cartográfico'],
    contentNote:
        'Apresentação em imagens de mapas históricos digitalizados sobre a evolução do trabalho cartográfico e o mapeamento do território brasileiro',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 8),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.imagem,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://bndigital.bn.gov.br/exposicoes/historica-cartographica-brasilis-in-biblioteca-nacional/brasil-seculo-xx/',
    issueYear: 2016,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Documento em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
