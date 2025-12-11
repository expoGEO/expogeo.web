import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_PAG_02 = ContentModel(
  id: 'NMA_PAG_02',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Observatório Nacional dos Direitos à Água e ao Saneamento - ONDAS',
    collaborator: 'Observatório Nacional dos Direitos à Água e ao Saneamento - ONDAS',
  ),
  contentInfo: ContentInfo(
    title: 'Site do ONDAS',
    description:
        'O Observatório trabalha na perspectiva de que, a partir da produção e disseminação de dados, análises e estudos críticos, seja possível enfrentar, de modo mais efetivo, o processo de mercantilização da água e de privatização do saneamento, que tende a dificultar o acesso ao serviço, principalmente por parte da população mais pobre',
    subjects: ['Direito a água', 'Saneamento básico', 'Site'],
    contentNote:
        'O ONDAS nasceu com o propósito de promover a ação conjunta, autônoma e crítica de instituições acadêmicas e de movimentos sindicais e sociais de todo o país, assegurando, dessa forma, a efetivação ao direito universal ao saneamento',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 18),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://ondasbrasil.org/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
