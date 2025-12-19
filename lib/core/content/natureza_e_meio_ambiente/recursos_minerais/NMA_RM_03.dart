import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';

ContentModel NMA_RM_03 = ContentModel(
  id: 'NMA_RM_03',
  theme: ThemeEnum.naturezaMeioAmbiente,
  subtheme: SubthemeEnum.recursosMinerais,
  intellectualIndicator: const IntellectualIndicator(
    creator: 'Universidade de São Paulo',
    collaborator: 'Museu de Geociências',
  ),
  contentInfo: ContentInfo(
    title: 'LitoLab – Laboratório de Preservação de Acervo Litológico da USP',
    description:
        'Site que tem o objetivo de suprir a falta de padronização de arquivamento e políticas de preservação do acervo geológico coletado por alunos, pesquisadores e docentes do Instituto de Geociências (IGC) da Universidade de São Paulo',
    subjects: ['Acervo litológico', 'Recurso mineral', 'Exposição'],
    contentNote:
        'A preservação do item e dos componentes adicionados à coleção corresponde a uma forma de proteger o testemunho da história científica. E, por sua vez, a proteção do bem destaca seu valor histórico e cultural, associado a seu valor científico e acadêmico',
  ),
  originInfo: OriginInfo(
    insertionDate: DateTime(2024, 12, 13),
    language: 'Português',
    type: ContentType.site,
    format: ContentFormat.outro,
    requirements: 'Acesso à internet',
  ),
  registrationInfo: RegistrationInfo(
    location: 'https://litolab.igc.usp.br/colecoes/',
    registrationRules:
        'Descrição de acordo com o Tema_Geral/Tema_Específico/Número_Referência da curadoria ExpoGEO',
  ),
  rightsInfo: const RightsInfo(rights: 'Licença livre'),
  preservationAction: PreservationAction(
    operation: 'Atualização do link ao longo do tempo',
    updateDate: DateTime(2026, 12),
  ),
);
