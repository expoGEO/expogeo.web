import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_SUS_10 = ContentModel(
  id: 'NMA_SUS_10',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Empresa Brasileira de Pesquisa Agropecuária - EMBRAPA',
    collaborator: 'Empresa Brasileira de Pesquisa Agropecuária - EMBRAPA',
  ),
  contentInfo: ContentInfo(
    title: 'Paisagens sustentáveis',
    description:
        'O WebSIG Paisagens Sustentáveis Brasil é uma ferramenta que disponibiliza o maior acervo de dados provenientes de levantamentos realizados com a tecnologia LiDAR (em português, um Sistema de Varredura a Laser) no Brasil, com dados de inventários florestais em localidades nos biomas Amazônia, Cerrado e Mata Atlântica',
    subjects: ['Florestas', 'Monitoramento', 'WebSIG'],
    contentNote:
        'Sua utilização permite gerar simulações tridimensionais de objetos na superfície da Terra, fornecendo informações do terreno e da estrutura da vegetação',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.paisagenslidar.cnptia.embrapa.br/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
