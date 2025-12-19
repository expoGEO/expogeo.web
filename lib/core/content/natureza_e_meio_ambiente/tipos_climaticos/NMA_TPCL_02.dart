import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_TPCL_02 = ContentModel(
  id: 'NMA_TPCL_02',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.tiposClimaticos,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto de Pesquisas e Estudos Florestais - IPEF',
    collaborator: 'Clayton Alcarde Alvares e José Luiz Stape',
  ),
  contentInfo: ContentInfo(
    title: 'Regiões Bioclimáticas do Brasil',
    description:
        'Mapa que contém informações gráficas, textuais e numéricas sobre as regiões bioclimáticas do Brasil',
    subjects: ['Brasil', 'Tipos climáticos', 'Mapa'],
    contentNote:
        'O mapa apresenta 26 regiões climáticas no Brasil e contém 10 atributos de informações, entre eles: Localização; Altitude; Tipo de vegetação; Tipo de clima; Temperatura; Precipitação; Geadas e Deficiência hídrica',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.ipef.br/publicacoes/acervohistorico/geodatabase/bra_1_zoneamento.pdf',
    issueYear: 2012,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
