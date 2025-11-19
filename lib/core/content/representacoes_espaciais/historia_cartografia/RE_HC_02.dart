import 'package:expogeo/core/models/content_model.dart';

ContentModel RE_HC_02 = ContentModel(
  id: 'RE_HC_02',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Missão para as Comemorações do V Centenário da Circum-Navegação',
    collaborator: 'João Paulo Oliveira e Costa',
  ),
  contentInfo: ContentInfo(
    title: 'Magalhães e a revolução geográfica',
    description:
        'Exposição virtual que apresenta o impacto da viagem de Fernão de Magalhães no conhecimento do planeta Terra, representado pela cartografia da época',
    subjects: ['Grandes navegações', 'Fernão de Magalhães', 'Cartografia'],
    contentNote:
        'Apresentação com vídeos, imagens e mapas sobre a viagem de Fernão de Magalhães e a descoberta do Estreito de Magalhães no extremo sul americano',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 8),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.html,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/story/WAVhuvi6NODg0Q',
    issueYear: 2022,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre - Google'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);


