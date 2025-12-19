import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel CP_RA_01 = ContentModel(
  id: 'CP_RA_01',
  theme: ThemeEnum.culturaPolitica,
  subtheme: SubthemeEnum.regioesAdministrativas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Federal do Paraná - União da Vitória',
    collaborator: 'Curso Técnico em Meio Ambiente integrado ao Ensino Médio',
  ),
  contentInfo: ContentInfo(
    title: 'Potencialidades da Região Amazônica',
    description:
        'WebSIG com informações sobre atividades culturais, gastronomia, flora e fauna da região amazônica',
    subjects: ['Região Norte', 'Amazônia', 'WebSIG'],
    contentNote:
        'WebSIG com informações sobre atividades culturais, gastronomia, flora e fauna da região amazônica',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 3),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://umap.openstreetmap.fr/pt-br/map/potencialidades-da-regiao-amazonica-percepcoes_934235#5/-5.266/-62.622',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
