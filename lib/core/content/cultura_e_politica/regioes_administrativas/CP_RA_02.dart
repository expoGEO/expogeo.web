import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_RA_02 = ContentModel(
  id: 'CP_RA_03',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Governo do Estado de São Paulo',
    collaborator: 'Núcleo de Ação Educativa',
  ),
  contentInfo: ContentInfo(
    title: 'Oeste Paulista',
    description:
        'Exposição virtual que apresenta documentos históricos sobre o processo de ocupação e urbanização de uma das mais importantes regiões de São Paulo',
    subjects: ['São Paulo', 'Desenvolvimento', 'Exposição'],
    contentNote:
        'Refletir sobre esse processo é fundamental para entender a região sudeste e, assim, termos maior clareza quanto aos cenários futuros',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 3),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://www.arquivoestado.sp.gov.br/exposicao_oeste/index.php',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
