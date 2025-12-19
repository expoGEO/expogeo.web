import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_IC_08 = ContentModel(
  id: 'CP_IC_08',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.identidadesCulturais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'SlaveVoyages',
    collaborator: 'Herbert S. Klein, David Richardson, David Eltis e Stephen Behrendt',
  ),
  contentInfo: ContentInfo(
    title: 'SlaveVoyages',
    description:
        'O site SlaveVoyages oferece registros sobre as origens e o transporte forçado de mais de doze milhões de africanos através do Atlântico e dentro das Américas',
    subjects: ['Povos escravizados', 'História', 'Site'],
    contentNote:
        'Este banco de dados oferece insights sobre as experiências daqueles que sobreviveram à Travessia do Meio através do Atlântico e foram forçados a embarcar em navios subsequentes logo após chegarem a um porto nas Américas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Inglês – Ativar a tradução do Google Tradutor',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.slavevoyages.org/voyage/trans-atlantic#timelapse',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
