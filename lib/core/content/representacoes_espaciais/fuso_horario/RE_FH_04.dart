import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_FH_04 = ContentModel(
  id: 'RE_FH_04',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.fusoHorario,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Sociedade Beneficente Israelita Brasileira Albert Einstein',
    collaborator: 'Sociedade Beneficente Israelita Brasileira Albert Einstein',
  ),
  contentInfo: ContentInfo(
    title: 'Jet lag e outros transtornos do ritmo circadiano',
    description:
        'Matéria sobre medicina do sono que explica o fenômeno Jet-lag e sua relação com o sistema de fuso horário',
    subjects: ['Fuso horário', 'Jet-lag', 'Medicina do sono'],
    contentNote:
        'Matéria no site do hospital Albert Einstein sobre medicina do sono, explicando o fenômeno Jet-lag e sua relação com o sistema de fusos horários',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.texto,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://www.einstein.br/especialidades/medicina-do-sono/doencas-sintomas/jet-lag',
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
