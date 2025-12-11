import 'package:expogeo/core/models/content_model.dart';

ContentModel NMA_PAG_01 = ContentModel(
  id: 'NMA_PAG_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Agência Nacional de Águas e Saneamento Básico - ANA',
    collaborator: 'Agência Nacional de Águas e Saneamento Básico - ANA',
  ),
  contentInfo: ContentInfo(
    title: 'Qualidade da água superficial no Brasil',
    description:
        'Site que apresenta as formas de monitoramento utilizadas no Brasil para avaliar a qualidade das águas superficiais',
    subjects: ['Qualidade da água', 'Monitoramento', 'Site'],
    contentNote:
        'A qualidade da água nos corpos hídricos é determinada pelas condições naturais e ações humanas praticadas na bacia hidrográfica',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 18),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://qualidadedaagua.ana.gov.br/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
