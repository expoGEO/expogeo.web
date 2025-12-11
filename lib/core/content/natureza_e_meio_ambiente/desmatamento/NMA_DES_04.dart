import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_DES_04 = ContentModel(
  id: 'NMA_DES_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro do Meio Ambiente e dos Recursos Naturais Renováveis - IBAMA',
    collaborator:
        'Instituto Brasileiro do Meio Ambiente e dos Recursos Naturais Renováveis - IBAMA',
  ),
  contentInfo: ContentInfo(
    title: 'Projeto de Monitoramento do Desmatamento dos Biomas Brasileiros por Satélite - PMDBBS',
    description:
        'Site que disponibiliza diversas informações sobre o desmatamento nos biomas brasileiros',
    subjects: ['Desmatamento', 'Monitoramento', 'Site'],
    contentNote:
        'Elaboração e execução do Sistema de Monitoramento por Satélite do Desmatamento nos Biomas Caatinga, Cerrado, Mata Atlântica, Pampa e Pantanal, com intuito de quantificar desmatamentos de áreas com vegetação nativa e de embasar ações de fiscalização e combate a desmatamentos ilegais naqueles biomas, cabendo ao Centro de Sensoriamento Remoto do Ibama - CSR a detecção dos desmatamentos',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://siscom.ibama.gov.br/monitora_biomas/PMDBBS%20-%20CAATINGA.html',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
