import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_PAR_04 = ContentModel(
  id: 'NMA_PAR_04',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Ministério da Saúde',
    collaborator: 'Secretaria de Vigilância em Saúde e Ambiente',
  ),
  contentInfo: ContentInfo(
    title: 'Painel - VIGIAR: Poluição atmosférica e saúde humana',
    description:
        'Painel que permite a visualização de informações geográficas e dados anuais das emissões de gases de efeito estufa no Brasil, documentos analíticos sobre a evolução das emissões',
    subjects: ['Poluição do Ar', 'Monitoramento', 'Painel'],
    contentNote:
        'O painel fornece informações de acordo com os padrões estipulados pelo Conselho Nacional de Meio Ambiente e da Organização Mundial da Saúde',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 18),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://app.powerbi.com/',
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
