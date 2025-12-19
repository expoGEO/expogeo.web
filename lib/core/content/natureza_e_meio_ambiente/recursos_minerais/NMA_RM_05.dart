import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_RM_05 = ContentModel(
  id: 'NMA_RM_05',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.recursosMinerais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'MM Gerdau - Museu das Minas e do Metal',
    collaborator: 'MM Gerdau - Museu das Minas e do Metal',
  ),
  contentInfo: ContentInfo(
    title: 'Usina Wigg: uma contribuição para a história do ferro',
    description:
        'Exposição virtual que nos convida a uma volta ao passado, utilizando como ponto de partida as ruínas arqueológicas da antiga Usina Wigg',
    subjects: ['Mineração', 'Ferro', 'Exposição'],
    contentNote:
        'A fábrica é um marco da siderurgia e produção de ferro em Minas Gerais, tornando-se referência para os processos modernos de fundição no início da indústria siderúrgica brasileira, no final do século XIX',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 13),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://usinawigg.mmgerdau.org.br/',
    issueYear: 2024,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
