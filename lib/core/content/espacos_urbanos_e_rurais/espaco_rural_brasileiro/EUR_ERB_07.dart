import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_ERB_07 = ContentModel(
  id: 'EUR_ERB_07',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística (IBGE)',
    collaborator: 'Canal IBGE - Youtube',
  ),
  contentInfo: ContentInfo(
    title: 'Censo agropecuário: o que é, sua estrutura e para que serve - IBGE Explica',
    description:
        'Vídeo educativo que responde a questões como: O que é censo? E o que é censo agropecuário? O que caracteriza um estabelecimento agropecuário? E os produtores rurais? Quais informações são levantadas em um censo agropecuário? E para que elas servem?',
    subjects: ['Censo Agropecuário', 'Estatística', 'Vídeo'],
    contentNote:
        'Vídeo educativo que responde a questões como: O que é censo? E o que é censo agropecuário? O que caracteriza um estabelecimento agropecuário? E os produtores rurais? Quais informações são levantadas em um censo agropecuário? E para que elas servem?',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 11, 28),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/cW6h020IZhs',
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
