import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_RA_03 = ContentModel(
  id: 'CP_RA_03',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.regioesAdministrativas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Universidade Federal do Paraná',
    collaborator: 'Museu de Arqueologia e Etnografia',
  ),
  contentInfo: ContentInfo(
    title: 'Entre conchas: modos de vida dos sambaquis',
    description:
        'Exposição virtual que apresenta monumentos construídos por populações indígenas pescadoras e coletoras que viveram principalmente no litoral brasileiro aproximadamente entre os anos 8.000 a.C. e 1.000 d.C',
    subjects: ['Região Sul', 'Sambaquis', 'Exposição'],
    contentNote:
        'Sambaqui é uma palavra de origem tupi-guarani, língua na qual. "Tambá" significa "monte" e "Ki" significa "concha". Sambaqui quer dizer, então, "monte de conchas". Os sambaquis são edificações de conchas, restos de fauna e habitações que podem conter até sepultamentos humanos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 3),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://mae.ufpr.br/entreconchas/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
