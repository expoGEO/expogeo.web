import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_BIO_07 = ContentModel(
  id: 'NMA_BIO_07',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.biomas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Ministério do Meio Ambiente e Mudança do Clima',
    collaborator: 'Ministério do Meio Ambiente e Mudança do Clima',
  ),
  contentInfo: ContentInfo(
    title: 'Mapas Temáticos do MacroZEE da Amazônia Legal',
    description:
        'O Macrozoneamento Ecológico-Econômico (MacroZEE) da Amazônia Legal foi elaborado mediante um amplo processo de discussão no âmbito da Comissão Coordenadora do Zoneamento Ecológico-Econômico do Território Nacional (CCZEE) e do Grupo de Trabalho para a Elaboração do Macrozoneamento Ecológico-Econômico da Amazônia Legal',
    subjects: ['Amazônia', 'Zoneamento', 'Mapas'],
    contentNote:
        'Mapas sobre Terras públicas na vegetação natural, Incorporação de terras, Fluxos da produção agropecuária, entre outros',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://www.gov.br/mma/pt-br/assuntos/controle-ao-desmatamento-queimadas-e-ordenamento-ambiental-territorial/zoneamento-ecologico-economico/estrutura-e-funcionamento/mapas-tematicos',
    issueYear: 2025,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
