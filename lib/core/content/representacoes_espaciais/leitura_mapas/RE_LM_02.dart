import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel RE_LM_02 = ContentModel(
  id: 'RE_LM_02',
  theme: ThemeEnum.representacoesEspaciais,
  subtheme: SubthemeEnum.leituraMapas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Instituto Brasileiro de Geografia e Estatística',
    collaborator: 'Portal de mapas - IBGE',
  ),
  contentInfo: ContentInfo(
    title: 'Mapas - IBGE',
    description: 'Site com diversos mapas sobre o Brasil e o mundo',
    subjects: ['Mapa temático', 'Brasil', 'Atlas geográfico'],
    contentNote: 'Portal do IBGE com extensa relação de mapas temáticos sobre o Brasil e o mundo',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 10, 11),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.imagem,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://portaldemapas.ibge.gov.br/portal.php#homepage',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Objeto digital em domínio público'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
