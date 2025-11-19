import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_PC_01 = ContentModel(
  id: 'RE_PC_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Wordwall',
    collaborator: 'Perfil: juliaalvesdemor',
  ),
  contentInfo: ContentInfo(
    title: 'Pontos cardeais e colaterais',
    description: 'Quiz sobre pontos cardeais e colaterais',
    subjects: ['Quiz', 'Pontos cardeais', 'Pontos colaterais'],
    contentNote:
        'Quiz que apresenta opções para preencher campos de resposta conforme a representação de uma rosa dos ventos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 8),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://wordwall.net/pt/resource/3684244/pontos-cardeais-e-colaterais',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);


