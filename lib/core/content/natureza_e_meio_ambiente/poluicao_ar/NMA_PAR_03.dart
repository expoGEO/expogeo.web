import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_PAR_03 = ContentModel(
  id: 'NMA_PAR_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Observatório do Clima',
    collaborator: 'EcoStage',
  ),
  contentInfo: ContentInfo(
    title: 'Sistema de Estimativas de Emissões e Remoções de Gases de Efeito Estufa - SEEG',
    description:
        'Site que permite a visualização de informações geográficas, dados e produção de estimativas anuais das emissões de gases de efeito estufa no Brasil, documentos analíticos sobre a evolução das emissões',
    subjects: ['Poluição do Ar', 'Monitoramento', 'Site'],
    contentNote:
        'O SEEG estima emissões nos cinco setores que são fontes de gases de efeito estufa no Brasil – Agropecuária, Energia, Mudanças de Uso da Terra, Processos Industriais e Resíduos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 18),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://plataforma.seeg.eco.br/',
    issueYear: 2024,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
