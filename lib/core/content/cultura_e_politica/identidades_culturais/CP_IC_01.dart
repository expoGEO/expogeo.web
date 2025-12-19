import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_IC_01 = ContentModel(
  id: 'CP_IC_01',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.identidadesCulturais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Universidade de Brasília',
    collaborator: 'Museu digital',
  ),
  contentInfo: ContentInfo(
    title: 'Funeral Bororó',
    description:
        'Exposição virtual que apresenta informações sobre a sociedade Bororó e seus rituais funerários',
    subjects: ['Indígenas', 'Bororó', 'Exposição'],
    contentNote:
        'Em 1985, em uma imersão de um grupo de pesquisadores na sociedade Bororo, foram feitos registros fotográficos e audiovisuais, com o devido consentimento e autorização da população em questão, de um dos rituais mais simbólicos e ricos daquele povo - o Funeral',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 2),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'http://bororo.museuvirtual.unb.br/index.php/pt/apresentacao',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
