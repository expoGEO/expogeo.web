import 'package:expogeo/core/models/content_model.dart';

ContentModel EUR_CT_01 = ContentModel(
  id: 'EUR_CT_01',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Arquivo Nacional',
    collaborator: 'Arquivo Nacional - Exposições virtuais',
  ),
  contentInfo: ContentInfo(
    title: 'A Marcha para o Oeste: a conquista do Brasil Central',
    description:
        'A exposição A Marcha para o Oeste: a conquista do Brasil Central (1943-1967) apresenta fotografias do acervo da Fundação Brasil Central (FBC) do Arquivo Nacional, sob a guarda de sua unidade regional sediada em Brasília',
    subjects: ['Agricultura', 'História', 'Arte'],
    contentNote:
        'A região chamada de Brasil Central, como tal, nunca existiu oficialmente até o século XX. Era, na verdade, um vasto território habitado por distintos povos indígenas e com uma população escassa e dispersa, ainda desconhecida pelo restante do país',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location:
        'https://exposicoesvirtuais.an.gov.br/index.php/galerias/10-exposicoes/314-a-marcha-para-o-oeste-a-conquista-do-brasil-central.html',
    issueYear: 2020,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
