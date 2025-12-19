import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_FH_02 = ContentModel(
  id: 'RE_FH_02',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.fusoHorario,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Programa de Educação Tutorial – GEOPET/UFU',
    collaborator: 'Celso Tamborin, Rafael Araujo, Stefany Mamede e Henrique Vian',
  ),
  contentInfo: ContentInfo(
    title: 'Movimentos da Terra e fusos horários',
    description:
        'Vídeo que apresenta a relação entre os movimentos da Terra e a delimitação dos fusos horários no planeta',
    subjects: ['Fuso horário', 'Longitude', 'Movimentos da Terra'],
    contentNote:
        'Vídeo do canal no YouTube “GEOPET-UFU” que apresenta a relação entre os movimentos da Terra e a delimitação dos fusos horários',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/HcR1FpHzsyA',
    issueYear: 2020,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
