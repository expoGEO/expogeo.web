import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_CT_05 = ContentModel(
  id: 'EUR_CT_05',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Memorial da Democracia',
    collaborator: 'Instituto Lula',
  ),
  contentInfo: ContentInfo(
    title: 'Conflitos no Campo',
    description:
        'Durante as décadas de 1940 a 1960, ocorreram no Brasil diferentes formas de conflito no campo. Em quase todos os estados, os camponeses se insurgiram contra a dominação de fazendeiros e coronéis, a expropriação territorial de grandes proprietários e grileiros e a exploração econômica nas fazendas e empresas agrícolas',
    subjects: ['Agricultura', 'Movimento popular', 'Dados'],
    contentNote:
        'Esse processo extremamente tenso possibilitou estender de muitos direitos trabalhistas ao campo, especialmente por meio do Estatuto do Trabalhador Rural, aprovado em 1963 pelo presidente João Goulart. As oligarquias rurais, no entanto reagiram violentamente à organização dos camponeses e à sua crescente participação política',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://memorialdademocracia.com.br/conflitos',
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
