import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_CT_04 = ContentModel(
  id: 'EUR_CT_04',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.conflitosTerra,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Comissão Pastoral da Terra (CPT)',
    collaborator: 'Comissão Pastoral da Terra (CPT)',
  ),
  contentInfo: ContentInfo(
    title: 'Conflitos no Campo Brasil 2023',
    description: 'Dados de conflitos ocorridos no campo no Brasil no ano de 2023',
    subjects: ['Agricultura', 'Movimento popular', 'Dados'],
    contentNote:
        'Comissão Pastoral da Terra realiza lançamento nacional do relatório Conflitos no Campo 2023, com os maiores índices de ocorrências em toda a história da publicação',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://cptnacional.org.br/2023/04/14/conflitos-no-campo-brasil-2023/',
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
