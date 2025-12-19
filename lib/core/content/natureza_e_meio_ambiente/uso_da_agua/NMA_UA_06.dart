import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_UA_06 = ContentModel(
  id: 'NMA_UA_06',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.usoAgua,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Banco do Brasil',
    collaborator: 'Programa Água Brasil',
  ),
  contentInfo: ContentInfo(
    title: 'Consumo Responsável',
    description:
        'Vídeo que aborda o consumo de recursos básicos, como água, energia, alimentos, vestuário, cuidados com a saúde, educação, entre outros. A cada ano, o Dia da Sobrecarga da Terra, que marca o dia em que já consumimos todos os recursos naturais disponíveis, chega mais cedo',
    subjects: ['Água', 'Consumo', 'Vídeo'],
    contentNote:
        'Precisamos do consumo para poder sobreviver, mas da forma como vivemos hoje, nos acostumamos a comprar muito mais do que precisamos e consumir de forma desenfreada já virou um hábito. Que tal repensar nossos hábitos?',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 9),
    language: 'Português',
    type: ContentType.video,
    format: ContentFormat.video,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://youtu.be/KIV3ASpM19M',
    issueYear: 2015,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
