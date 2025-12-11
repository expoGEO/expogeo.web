import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_CT_02 = ContentModel(
  id: 'EUR_CT_02',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Movimento dos Trabalhadores Rurais Sem Terra (MST)',
    collaborator: 'Movimento dos Trabalhadores Rurais Sem Terra (MST)',
  ),
  contentInfo: ContentInfo(
    title: 'MST 40 anos',
    description:
        'Mais de 150 inscrições com as mais variadas formas de expressar as diversas dimensões da luta pela terra enriquecem e nos ajudam a pensar a Reforma Agrária em seu espectro mais amplo',
    subjects: ['Agricultura', 'Movimento popular', 'Exposição'],
    contentNote:
        'Nesta exposição online, você poderá conferir o belíssimo resultado deste trabalho, com destaques às 40 artes selecionadas que irão compor outros materiais ao longo do ano. Novamente, nosso mais fraterno agradecimento as pessoas que permitiram o sucesso desta iniciativa',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://mst.org.br/especiais/exposicao-mst-40-anos/',
    issueYear: 2023,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
