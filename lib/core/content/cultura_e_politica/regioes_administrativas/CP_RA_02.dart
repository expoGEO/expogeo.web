import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_RA_02 = ContentModel(
  id: 'CP_RA_02',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.regioesAdministrativas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
    collaborator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
  ),
  contentInfo: ContentInfo(
    title: 'Quantas pessoas moram no Brasil e onde vivem?',
    description:
        'Vídeo com informações sobre quantos somos, onde vivemos, como vivemos, como somos, e tantas outras perguntas que só são respondidas pelo Censo Demográfico, única pesquisa que vai a todas as residências em todos os municípios do país',
    subjects: ['Brasil', 'População', 'Regiões'],
    contentNote:
        'Neste vídeo, você vai conhecer o total de habitantes que os recenseadores contaram no Censo 2022, tanto no país quanto nas regiões e estados brasileiros. Onde moram mais pessoas? Quais os estados com menos habitantes?',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2026, 2, 4),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/BAIR2C7CFRU',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
