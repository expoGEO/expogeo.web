import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/utils/date/date.dart';
import 'package:flutter/material.dart';

class ContentModel {
  final String id;
  final ThemeEnum theme;
  final SubthemeEnum subtheme;
  final IntellectualIndicator intellectualIndicator;
  final ContentInfo contentInfo;
  final OriginInfo originInfo;
  final RegistrationInfo registrationInfo;
  final RightsInfo rightsInfo;
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
}

class IntellectualIndicator {
  final String creator;
  final String? collaborator;

  const IntellectualIndicator({required this.creator, this.collaborator});

  factory IntellectualIndicator.fromJson(Map<String, dynamic> json) {
    return IntellectualIndicator(
      creator: json['creator'] as String,
      collaborator: json['collaborator'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'creator': creator,
    if (collaborator != null) 'collaborator': collaborator,
  };
}

class ContentInfo {
  final String title;
  final String description;
  final List<String> subjects;
  final String? contentNote;

  const ContentInfo({
    required this.title,
    required this.description,
    required this.subjects,
    this.contentNote,
  });

  factory ContentInfo.fromJson(Map<String, dynamic> json) {
    return ContentInfo(
      title: json['title'] as String,
      description: json['description'] as String,
      subjects: List<String>.from(json['subjects'] as List? ?? []),
      contentNote: json['contentNote'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'subjects': subjects,
    if (contentNote != null) 'contentNote': contentNote,
  };
}

class OriginInfo {
  final DateTime insertionDate;
  final String language;
  final ContentType type;
  final ContentFormat format;
  final String? requirements;

  const OriginInfo({
    required this.insertionDate,
    required this.language,
    required this.type,
    required this.format,
    this.requirements,
  });

  factory OriginInfo.fromJson(Map<String, dynamic> json) {
    return OriginInfo(
      insertionDate: DateTime.parse(json['insertionDate'] as String),
      language: json['language'] as String,
      type: ContentType.fromString(json['type'] as String),
      format: ContentFormat.fromString(json['format'] as String),
      requirements: json['requirements'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'insertionDate': insertionDate.isoDay,
    'language': language,
    'type': type.name,
    'format': format.name,
    if (requirements != null) 'requirements': requirements,
  };
}

class RegistrationInfo {
  final String location; // URL do recurso
  final int? issueYear; // Ano de emissão
  final String? registrationRules;

  const RegistrationInfo({required this.location, this.issueYear, this.registrationRules});

  factory RegistrationInfo.fromJson(Map<String, dynamic> json) {
    return RegistrationInfo(
      location: json['location'] as String? ?? '',
      issueYear: json['issueYear'] as int?,
      registrationRules: json['registrationRules'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'location': location,
    if (issueYear != null) 'issueYear': issueYear,
    if (registrationRules != null) 'registrationRules': registrationRules,
  };
}

class RightsInfo {
  final String rights;

  const RightsInfo({required this.rights});

  factory RightsInfo.fromJson(Map<String, dynamic> json) {
    return RightsInfo(rights: json['rights'] as String? ?? '');
  }

  Map<String, dynamic> toJson() => {'rights': rights};
}

class PreservationAction {
  final String operation;
  final DateTime? updateDate;

  const PreservationAction({required this.operation, this.updateDate});

  factory PreservationAction.fromJson(Map<String, dynamic> json) {
    return PreservationAction(
      operation: json['operation'] as String? ?? '',
      updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'operation': operation,
    if (updateDate != null) 'updateDate': updateDate!.isoDay,
  };
}

enum ContentType {
  site('Site'),
  video('Vídeo'),
  imagem('Imagem'),
  documento('Documento'),
  aplicativo('Aplicativo'),
  outro('Outro');

  final String value;
  const ContentType(this.value);

  IconData get icon => switch (this) {
    ContentType.site => Icons.language,
    ContentType.video => Icons.play_circle_outline,
    ContentType.imagem => Icons.image_outlined,
    ContentType.documento => Icons.description_outlined,
    ContentType.aplicativo => Icons.apps_outlined,
    ContentType.outro => Icons.info_outline,
  };

  /// Aceita o nome (`site`) ou o rótulo (`Site`), porque há objetos gravados dos dois jeitos.
  static ContentType fromString(String value) {
    for (final type in ContentType.values) {
      if (type.name == value) return type;
    }
    for (final type in ContentType.values) {
      if (type.value == value) return type;
    }
    return ContentType.outro;
  }
}

enum ContentFormat {
  texto('Texto'),
  html('HTML'),
  pdf('PDF'),
  video('Vídeo'),
  imagem('Imagem'),
  audio('Áudio'),
  outro('Outro');

  final String value;
  const ContentFormat(this.value);

  /// Aceita o nome (`html`) ou o rótulo (`HTML`), porque há objetos gravados dos dois jeitos.
  static ContentFormat fromString(String value) {
    for (final format in ContentFormat.values) {
      if (format.name == value) return format;
    }
    for (final format in ContentFormat.values) {
      if (format.value == value) return format;
    }
    return ContentFormat.outro;
  }
}
