import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_BH_03 = ContentModel(
  id: 'NMA_BH_03',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.baciasHidrograficas,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Serviço Geológico do Brasil - SGB',
    collaborator: 'Serviço Geológico do Brasil - SGB',
  ),
  contentInfo: ContentInfo(
    title: 'Sistema de Informações de Águas Subterrâneas',
    description:
        'O SIAGAS é um sistema de informações de águas subterrâneas, desenvolvido pelo Serviço Geológico do Brasil - SGB, constituído por uma base de dados de poços permanentemente atualizada, e de módulos capazes de realizar consultas, pesquisas, extração e geração de relatórios',
    subjects: ['Bacias hidrográficas', 'Brasil', 'WebSIG'],
    contentNote:
        'O SIAGAS, desenvolvido e mantido pelo SGB a partir do mapeamento e pesquisa hidrogeológica em todo o país, permite a gestão adequada da informação hidrogeológica e a sua integração com outros sistemas',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://siagasweb.sgb.gov.br/layout/visualizar_mapa.php',
    issueYear: 2006,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
