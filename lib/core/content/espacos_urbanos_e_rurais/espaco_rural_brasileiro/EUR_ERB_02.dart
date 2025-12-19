import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel EUR_ERB_02 = ContentModel(
  id: 'EUR_ERB_02',
  theme: ThemeEnum.espacosUrbanosRurais,
  subtheme: SubthemeEnum.espacoRuralBrasileiro,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'IFSC - Agronomia',
    collaborator: 'Vilson Schenato',
  ),
  contentInfo: ContentInfo(
    title: 'Retratos do Rural',
    description: 'Exposição fotográfica sobre o espaço rural',
    subjects: ['Paisagem rural', 'Agricultura', 'Fotografia'],
    contentNote:
        'Exposição fotográfica sobre o espaço rural. Projeto de Extensão da disciplina Sociologia Rural Agronomia / IFSC',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 11, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://schenato25.wixsite.com/fotos-rural',
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
