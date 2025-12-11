import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_CT_06 = ContentModel(
  id: 'EUR_CT_06',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Despejo Zero',
    collaborator: 'Despejo Zero',
  ),
  contentInfo: ContentInfo(
    title: 'Mapeamento Nacional de Conflitos pela Terra e Moradia',
    description:
        'O Mapeamento Nacional de Conflitos pela Terra e Moradia visa identificar e denunciar um problema crônico e frequente que vem sendo sistematicamente invisibilizado no Brasil: os conflitos fundiários que resultam em despejos e remoções forçadas de pessoas do seu local de moradia e sobrevivência',
    subjects: ['Conflitos de terra', 'Movimento popular', 'WebSIG'],
    contentNote:
        'Entende-se por conflito fundiário a disputa pela posse ou propriedade de um imóvel, bem como o impacto de empreendimentos públicos e privados, envolvendo famílias de baixa renda ou grupos sociais vulnerabilizados que necessitem ou demandem a proteção do Estado na garantia do direito à moradia e à cidade',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://mapa.despejozero.org.br/?modo=mapa&recorteTerritorial=mr',
    issueYear: 2020,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
