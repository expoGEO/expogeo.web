import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_ERB_03 = ContentModel(
  id: 'EUR_ERB_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Parque Histórico de Carambeí',
    collaborator: 'Museu Parque Histórico de Carambeí',
  ),
  contentInfo: ContentInfo(
    title: 'Caminhos do leite',
    description: 'Exposição fotográfica sobre a produção de leite no município de Carambeí - PR',
    subjects: ['Paisagem rural', 'Pecuária', 'Fotografia'],
    contentNote:
        'Desde os tempos medievais o povo holandês era reconhecido pela sua notória produção láctea. Leite, manteiga e queijo tornaram-se símbolos da identidade desse povo e esses produtos fortemente enraizados na cultura neerlandesa. Prova disso é o papel que o "leiteiro" desempenhou nesta sociedade',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 11, 28),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.aphc.com.br/caminhosdoleite/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
