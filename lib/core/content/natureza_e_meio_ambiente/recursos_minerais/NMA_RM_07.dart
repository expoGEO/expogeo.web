import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_RM_07 = ContentModel(
  id: 'NMA_RM_07',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.recursosMinerais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Novo Tempo',
    collaborator: 'Origens NT',
  ),
  contentInfo: ContentInfo(
    title: 'História registrada nas rochas',
    description:
        'Documentário que explica a importância da Geologia enquanto conhecimento científico que ajuda na compreensão da evolução do planeta Terra',
    subjects: ['Geologia', 'Ciência', 'Documentário'],
    contentNote:
        'Desde a água até as rochas, desde os vales às montanhas e dos profundos oceanos até o espaço, por onde quer que olhamos, encontramos geologia. Esta é ciência da Terra, que acima de tudo nos proporciona um ponto de referência para compreender o passado, presente e futuro deste maravilhoso planeta',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 13),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/GaJNMvY1mLU',
    issueYear: 2017,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
