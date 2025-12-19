import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_PAR_01 = ContentModel(
  id: 'NMA_PAR_01',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.poluicaoAr,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'The Index Project',
  ),
  contentInfo: ContentInfo(
    title: 'Das pipas aos carros: combatendo a poluição do ar com design',
    description:
        'Exposição que apresenta soluções estranhas e maravilhosas para melhorar a qualidade do ar global',
    subjects: ['Poluição do Ar', 'Soluções Ambientais', 'Exposição'],
    contentNote:
        'Exposição que apresenta soluções estranhas e maravilhosas para melhorar a qualidade do ar global',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 18),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/story/IgWBa972xtv9Jw',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
