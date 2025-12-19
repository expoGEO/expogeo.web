import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Modelo que representa um conteúdo educacional com seus metadados completos
class ContentModel {
  /// Identificador único do conteúdo (ex: RE_CG_01)
  final String id;

  /// Tema do conteúdo
  final ThemeEnum theme;

  /// Subtema do conteúdo
  final SubthemeEnum subtheme;

  /// Indicativo Intelectual do Objeto Digital
  final IntellectualIndicator intellectualIndicator;

  /// Conteúdo do Objeto Digital
  final ContentInfo contentInfo;

  /// Informação de Origem do Objeto Digital
  final OriginInfo originInfo;

  /// Informação de Registro do Objeto Digital
  final RegistrationInfo registrationInfo;

  /// Direitos do Objeto Digital
  final RightsInfo rightsInfo;

  /// Ações de Preservação para o Objeto Digital
  final PreservationAction? preservationAction;

  const ContentModel({
    required this.id,
    required this.theme,
    required this.subtheme,
    required this.intellectualIndicator,
    required this.contentInfo,
    required this.originInfo,
    required this.registrationInfo,
    required this.rightsInfo,
    this.preservationAction,
  });

  String? get route {
    return switch (originInfo.type) {
      ContentType.video => '/${theme.value}/${subtheme.value}/$id',
      ContentType.imagem => '/${theme.value}/${subtheme.value}/$id',
      ContentType.documento => '/${theme.value}/${subtheme.value}/$id',
      _ => null,
    };
  }
}

/// Indicativo Intelectual do Objeto Digital
class IntellectualIndicator {
  final String creator;
  final String? collaborator;

  const IntellectualIndicator({required this.creator, this.collaborator});
}

/// Conteúdo do Objeto Digital
class ContentInfo {
  final String title;
  final String description;
  final List<String>
  subjects; // Lista de assuntos (ex: ["Coordenadas geográficas", "Longitude", "Latitude"])
  final String? contentNote; // Nota de Conteúdo

  const ContentInfo({
    required this.title,
    required this.description,
    required this.subjects,
    this.contentNote,
  });
}

/// Informação de Origem do Objeto Digital
class OriginInfo {
  final DateTime insertionDate; // Data de inserção
  final String language;
  final ContentType type;
  final ContentFormat format;
  final String? requirements; // Requisitos necessários

  const OriginInfo({
    required this.insertionDate,
    required this.language,
    required this.type,
    required this.format,
    this.requirements,
  });
}

/// Informação de Registro do Objeto Digital
class RegistrationInfo {
  final String location; // URL do recurso
  final int? issueYear; // Data de emissão
  final String? registrationRules; // Regras de registro

  const RegistrationInfo({required this.location, this.issueYear, this.registrationRules});
}

/// Direitos do Objeto Digital
class RightsInfo {
  final String rights; // Descrição dos direitos (ex: "Objeto digital em domínio público")

  const RightsInfo({required this.rights});
}

/// Ações de Preservação para o Objeto Digital
class PreservationAction {
  final String operation; // Operação (ex: "Atualização do link ao longo do tempo")
  final DateTime? updateDate; // Data de atualização

  const PreservationAction({required this.operation, this.updateDate});
}

/// Tipos de conteúdo disponíveis
enum ContentType {
  site('Site'),
  video('Vídeo'),
  imagem('Imagem'),
  documento('Documento'),
  aplicativo('Aplicativo'),
  outro('Outro');

  final String label;
  const ContentType(this.label);

  IconData get icon => switch (this) {
    ContentType.site => Icons.language,
    ContentType.video => Icons.play_circle_outline,
    ContentType.imagem => Icons.image_outlined,
    ContentType.documento => Icons.description_outlined,
    ContentType.aplicativo => Icons.apps_outlined,
    ContentType.outro => Icons.info_outline,
  };

  Color get color => switch (this) {
    ContentType.site => AppTheme.colors.primaryBlue,
    ContentType.video => AppTheme.colors.primaryRed,
    ContentType.imagem => AppTheme.colors.primaryGreen,
    ContentType.documento => AppTheme.colors.primaryOrange,
    ContentType.aplicativo => AppTheme.colors.secondaryBlue,
    ContentType.outro => AppTheme.colors.mediumGray,
  };
}

/// Formatos de conteúdo disponíveis
enum ContentFormat {
  texto('Texto'),
  html('HTML'),
  pdf('PDF'),
  video('Vídeo'),
  imagem('Imagem'),
  audio('Áudio'),
  outro('Outro');

  final String label;
  const ContentFormat(this.label);
}
