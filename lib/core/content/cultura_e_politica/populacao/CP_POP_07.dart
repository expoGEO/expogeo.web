import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_POP_07 = ContentModel(
  id: 'CP_POP_07',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.demografia,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Pontifícia Universidade Católica do Rio Grande do Sul',
    collaborator: 'Museu de Ciências e Tecnologia',
  ),
  contentInfo: ContentInfo(
    title: 'Práticas Adaptativas Culturais Brasil-Austrália',
    description:
        'Exposição virtual que ao comparar duas narrativas amplas, únicas e diversas da interação indígena com o meio ambiente, no Brasil e na Austrália, ilustra a complexidade da adaptação humana sobre nosso relacionamento com o meio ambiente e a sociedade contemporânea',
    subjects: ['Brasil', 'Austrália', 'Cultura'],
    contentNote:
        'Brasil e Austrália têm dezenas de milhares de anos de interação humana com seus ambientes únicos e variados. A dinâmica desses grupos indígenas e a pluralidade de vozes de seus descendentes contemporâneos são essenciais para explorar a complexa relação entre ecossistemas naturais, adaptação humana e modificação do meio ambiente',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 3),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.pucrs.br/mct/brasil-e-australia/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
