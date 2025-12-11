import 'package:expogeo/core/models/content_model.dart';

ContentModel CP_CD_05 = ContentModel(
  id: 'CP_CD_05',
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Fundação Getúlio Vargas',
    collaborator: 'Fundação Getúlio Vargas',
  ),
  contentInfo: ContentInfo(
    title: 'Atlas Histórico do Brasil',
    description:
        'O Atlas abrange um longo período histórico, que vai desde antes do "descobrimento" do Brasil até os dias de hoje',
    subjects: ['Demografia', 'História', 'Site'],
    contentNote:
        'Esta nova edição foi enriquecida com conteúdos textuais, fotográficos, sonoros e audiovisuais identificados, principalmente, no acervo histórico do próprio CPDOC, embora inclua também documentos localizados em outras instituições',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2025, 9, 16),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://atlas.fgv.br/',
    issueYear: 2023,
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
