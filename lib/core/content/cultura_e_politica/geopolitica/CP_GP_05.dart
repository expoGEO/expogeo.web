import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_GP_05 = ContentModel(
  id: 'CP_GP_05',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.geopolitica,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Fundação Alexandre de Gusmão',
    collaborator: 'Fundação Alexandre de Gusmão',
  ),
  contentInfo: ContentInfo(
    title: 'Exposição Brasil 200 anos',
    description:
        'Percursos da diplomacia brasileira a partir do acervo do Itamaraty no Rio de Janeiro',
    subjects: ['Brasil', 'Diplomacia', 'Exposição'],
    contentNote:
        'Percursos da diplomacia brasileira a partir do acervo do Itamaraty no Rio de Janeiro',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://funag.gov.br/bicentenario/pagina2.php',
    issueYear: 2022,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
