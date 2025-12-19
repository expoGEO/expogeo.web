import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_BIO_04 = ContentModel(
  id: 'NMA_BIO_04',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.biomas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Google Arts and Culture',
    collaborator: 'Museu Inhotim',
  ),
  contentInfo: ContentInfo(
    title: 'Do Tamboril à Braúna: conversas com quem gosta de árvores',
    description:
        'Exposição que apresenta o tamboril, árvore ícone do Inhotim e que observa a criação e desenvolvimento do Instituto ao longo dos anos, abrigando e inspirando plantas, animais, funcionários e visitantes',
    subjects: ['Árvore', 'Inhotim', 'Exposição'],
    contentNote:
        'As árvores possuem a capacidade de alterar o ambiente ao redor, através da adição de matéria orgânica no solo pela queda de folhas, ou pela ação da sombra que aumenta a umidade em seu entorno e diminui a temperatura',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 13),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://artsandculture.google.com/story/kwXxEKjYF9mnKg',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
