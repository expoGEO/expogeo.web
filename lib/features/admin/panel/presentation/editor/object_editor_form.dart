import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Campos do editor, na ordem em que as pendências são listadas.
enum EditorField {
  theme,
  subtheme,
  title,
  description,
  subjects,
  note,
  creator,
  collaborator,
  location,
  type,
  format,
  language,
  issueYear,
  requirements,
  registrationRules,
  rights,
  preservation,
  reviewMonth,
  reviewYear,
}

/// Um campo que impede o salvamento, com o texto da lista de pendências.
class EditorProblem {
  const EditorProblem(this.field, this.label);

  final EditorField field;

  /// Como aparece em "Falta preencher para salvar:", por exemplo "o título".
  final String label;

  @override
  bool operator ==(Object other) =>
      other is EditorProblem && other.field == field && other.label == label;

  @override
  int get hashCode => Object.hash(field, label);

  @override
  String toString() => label;
}

/// Estado do formulário do editor de objeto: valores, foco por campo, pendências e o objeto
/// montado para gravar.
class ObjectEditorForm extends ChangeNotifier {
  ObjectEditorForm.create({ThemeEnum? theme, SubthemeEnum? subtheme})
    : _theme = theme,
      _subtheme = theme != null && subtheme?.theme == theme ? subtheme : null {
    language.text = defaultLanguage;
    requirements.text = defaultRequirements;
    preservation.text = defaultPreservation;
    _start();
  }

  ObjectEditorForm.edit({
    required ThemeEnum theme,
    required SubthemeEnum subtheme,
    required ContentModel content,
  }) : _theme = theme,
       _subtheme = subtheme,
       _type = content.originInfo.type,
       _format = content.originInfo.format {
    title.text = content.contentInfo.title;
    description.text = content.contentInfo.description;
    subjects.text = content.contentInfo.subjects.join(', ');
    note.text = content.contentInfo.contentNote ?? '';
    creator.text = content.intellectualIndicator.creator;
    collaborator.text = content.intellectualIndicator.collaborator ?? '';
    location.text = content.registrationInfo.location;
    language.text = content.originInfo.language;
    issueYear.text = content.registrationInfo.issueYear?.toString() ?? '';
    requirements.text = content.originInfo.requirements ?? '';
    registrationRules.text = content.registrationInfo.registrationRules ?? '';
    rights.text = content.rightsInfo.rights;
    preservation.text = content.preservationAction?.operation ?? '';
    final review = content.preservationAction?.updateDate;
    _reviewMonth = review?.month;
    _reviewYear = review?.year;
    _start();
  }

  static const String defaultLanguage = 'Português';
  static const String defaultRequirements = 'Acesso à internet';
  static const String defaultPreservation = 'Atualização do link ao longo do tempo';

  /// Anos da próxima revisão em volta do atual: um antes, para objetos já cadastrados, e cinco
  /// à frente.
  static const int reviewYearsBefore = 1;
  static const int reviewYearsAfter = 5;

  static final RegExp _web = RegExp(r'^https?://\S+', caseSensitive: false);
  static final RegExp _year = RegExp(r'^\d{4}$');

  final title = TextEditingController();
  final description = TextEditingController();
  final subjects = TextEditingController();
  final note = TextEditingController();
  final creator = TextEditingController();
  final collaborator = TextEditingController();
  final location = TextEditingController();
  final language = TextEditingController();
  final issueYear = TextEditingController();
  final requirements = TextEditingController();
  final registrationRules = TextEditingController();
  final rights = TextEditingController();
  final preservation = TextEditingController();

  final Map<EditorField, FocusNode> _focus = {
    for (final field in EditorField.values) field: FocusNode(debugLabel: field.name),
  };

  ThemeEnum? _theme;
  SubthemeEnum? _subtheme;
  ContentType? _type;
  ContentFormat? _format;
  int? _reviewMonth;
  int? _reviewYear;

  late List<Object?> _initial;

  List<TextEditingController> get _controllers => [
    title,
    description,
    subjects,
    note,
    creator,
    collaborator,
    location,
    language,
    issueYear,
    requirements,
    registrationRules,
    rights,
    preservation,
  ];

  void _start() {
    _initial = _values;
    for (final controller in _controllers) {
      controller.addListener(notifyListeners);
    }
  }

  List<Object?> get _values => [
    _theme,
    _subtheme,
    _type,
    _format,
    _reviewMonth,
    _reviewYear,
    for (final controller in _controllers) controller.text,
  ];

  /// Algo mudou desde que o editor abriu; voltar ao valor de antes não conta.
  bool get hasChanges => !listEquals(_initial, _values);

  FocusNode focusOf(EditorField field) => _focus[field]!;

  ThemeEnum? get theme => _theme;
  SubthemeEnum? get subtheme => _subtheme;
  ContentType? get type => _type;
  ContentFormat? get format => _format;
  int? get reviewMonth => _reviewMonth;
  int? get reviewYear => _reviewYear;

  /// Trocar o tema limpa o subtema, que é de outro tema.
  set theme(ThemeEnum? value) {
    if (value == _theme) return;
    _theme = value;
    _subtheme = null;
    notifyListeners();
  }

  set subtheme(SubthemeEnum? value) {
    if (value == _subtheme) return;
    _subtheme = value;
    notifyListeners();
  }

  set type(ContentType? value) {
    if (value == _type) return;
    _type = value;
    notifyListeners();
  }

  set format(ContentFormat? value) {
    if (value == _format) return;
    _format = value;
    notifyListeners();
  }

  set reviewMonth(int? value) {
    if (value == _reviewMonth) return;
    _reviewMonth = value;
    notifyListeners();
  }

  set reviewYear(int? value) {
    if (value == _reviewYear) return;
    _reviewYear = value;
    notifyListeners();
  }

  /// Anos da lista da próxima revisão, com o ano gravado mesmo quando fora do intervalo.
  List<int> reviewYears(DateTime today) {
    final years = {
      for (var year = today.year - reviewYearsBefore; year <= today.year + reviewYearsAfter; year++)
        year,
      ?_reviewYear,
    };
    return years.toList()..sort();
  }

  static bool _isBlank(TextEditingController controller) => controller.text.trim().isEmpty;

  /// O que impede o salvamento, na ordem da tela.
  List<EditorProblem> missing() {
    final location = this.location.text.trim();
    final year = issueYear.text.trim();
    final reviewIncomplete = (_reviewMonth == null) != (_reviewYear == null);

    return [
      if (_theme == null) const EditorProblem(EditorField.theme, 'o tema'),
      if (_subtheme == null) const EditorProblem(EditorField.subtheme, 'o subtema'),
      if (_isBlank(title)) const EditorProblem(EditorField.title, 'o título'),
      if (_isBlank(description)) const EditorProblem(EditorField.description, 'a descrição'),
      if (_subjectList().isEmpty) const EditorProblem(EditorField.subjects, 'os assuntos'),
      if (_isBlank(creator)) const EditorProblem(EditorField.creator, 'o criador'),
      if (location.isEmpty)
        const EditorProblem(EditorField.location, 'o endereço do recurso')
      else if (!_web.hasMatch(location))
        const EditorProblem(EditorField.location, 'o endereço do recurso (comece com https://)'),
      if (_type == null) const EditorProblem(EditorField.type, 'o tipo'),
      if (_format == null) const EditorProblem(EditorField.format, 'o formato'),
      if (_isBlank(language)) const EditorProblem(EditorField.language, 'o idioma'),
      if (year.isNotEmpty && !_year.hasMatch(year))
        const EditorProblem(EditorField.issueYear, 'o ano de emissão (use 4 algarismos)'),
      if (_isBlank(rights)) const EditorProblem(EditorField.rights, 'os direitos'),
      if (_isBlank(preservation))
        const EditorProblem(EditorField.preservation, 'a ação de preservação'),
      if (reviewIncomplete)
        EditorProblem(
          _reviewMonth == null ? EditorField.reviewMonth : EditorField.reviewYear,
          'a próxima revisão do link (escolha o mês e o ano)',
        ),
    ];
  }

  /// O erro mostrado abaixo do campo, ou nulo.
  String? problemOf(EditorField field) {
    if (field == EditorField.reviewMonth || field == EditorField.reviewYear) {
      final incomplete = (_reviewMonth == null) != (_reviewYear == null);
      final empty = field == EditorField.reviewMonth ? _reviewMonth == null : _reviewYear == null;
      return incomplete && empty ? 'Escolha o mês e o ano.' : null;
    }
    final problem = missing().where((problem) => problem.field == field).firstOrNull;
    if (problem == null) return null;
    return switch (field) {
      EditorField.theme ||
      EditorField.subtheme ||
      EditorField.type ||
      EditorField.format => 'Escolha ${problem.label}.',
      EditorField.location when location.text.trim().isNotEmpty =>
        'Comece o endereço com https:// ou http://.',
      EditorField.issueYear => 'Use 4 algarismos, como 2024.',
      _ => 'Preencha ${problem.label}.',
    };
  }

  /// Assuntos separados por vírgula, sem vazios e sem repetidos; fica a primeira grafia.
  List<String> _subjectList() {
    final seen = <String>{};
    return [
      for (final subject in subjects.text.split(',').map((subject) => subject.trim()))
        if (subject.isNotEmpty && seen.add(subject.toLowerCase())) subject,
    ];
  }

  static String? _optional(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  /// O objeto para gravar. Só chame sem pendências.
  ContentResponseModel build({
    required String code,
    required String docId,
    required DateTime insertionDate,
  }) {
    final month = _reviewMonth;
    final year = _reviewYear;
    return ContentResponseModel(
      docId: docId,
      id: code,
      theme: _theme!,
      subtheme: _subtheme!,
      intellectualIndicator: IntellectualIndicator(
        creator: creator.text.trim(),
        collaborator: _optional(collaborator),
      ),
      contentInfo: ContentInfo(
        title: title.text.trim(),
        description: description.text.trim(),
        subjects: _subjectList(),
        contentNote: _optional(note),
      ),
      originInfo: OriginInfo(
        insertionDate: insertionDate,
        language: language.text.trim(),
        type: _type!,
        format: _format!,
        requirements: _optional(requirements),
      ),
      registrationInfo: RegistrationInfo(
        location: location.text.trim(),
        issueYear: int.tryParse(issueYear.text.trim()),
        registrationRules: _optional(registrationRules),
      ),
      rightsInfo: RightsInfo(rights: rights.text.trim()),
      preservationAction: PreservationAction(
        operation: preservation.text.trim(),
        updateDate: month != null && year != null ? DateTime(year, month) : null,
      ),
    );
  }

  /// O que a prévia do cartão mostra, com textos de exemplo nos campos vazios. O cartão
  /// recebe o subtema à parte; o daqui só preenche o modelo enquanto não há escolha.
  ContentModel preview({required String code}) {
    final subtheme = _subtheme ?? SubthemeEnum.values.first;
    String or(TextEditingController controller, String sample) {
      final text = controller.text.trim();
      return text.isEmpty ? sample : text;
    }

    return ContentModel(
      id: code,
      theme: subtheme.theme,
      subtheme: subtheme,
      intellectualIndicator: IntellectualIndicator(creator: or(creator, 'Criador')),
      contentInfo: ContentInfo(
        title: or(title, 'Título do objeto'),
        description: or(description, 'A descrição aparece aqui.'),
        subjects: const [],
      ),
      originInfo: OriginInfo(
        insertionDate: DateTime(2000),
        language: language.text,
        type: _type ?? ContentType.site,
        format: _format ?? ContentFormat.outro,
      ),
      registrationInfo: RegistrationInfo(location: location.text),
      rightsInfo: RightsInfo(rights: rights.text),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focus.values) {
      node.dispose();
    }
    super.dispose();
  }
}
