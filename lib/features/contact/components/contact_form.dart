import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/form/form_text_field.dart';
import 'package:expogeo/core/components/form/marked_text.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/constants/app_links.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/core/utils/url/mail_draft.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:expogeo/core/utils/validators/form_validators.dart';
import 'package:expogeo/features/contact/components/contact_confirmation.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  static const int _name = 0;
  static const int _email = 1;
  static const int _subject = 2;
  static const int _message = 3;

  static final List<FormValidator> _validators = [
    FormValidators.required('Escreva seu nome.'),
    FormValidators.email('Escreva um e-mail válido, como nome@exemplo.com.'),
    FormValidators.required('Diga em poucas palavras o assunto.'),
    FormValidators.required('Escreva a mensagem.'),
  ];

  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<TextEditingController> _controllers = List.generate(
    _validators.length,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(_validators.length, (_) => FocusNode());
  final List<GlobalKey> _fieldKeys = List.generate(_validators.length, (_) => GlobalKey());

  bool _attempted = false;
  MailDraft? _draft;

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _value(int index) => _controllers[index].text.trim();

  int get _firstInvalid =>
      _validators.indexed.firstWhere((rule) => rule.$2(_controllers[rule.$1].text) != null).$1;

  void _submit() {
    setState(() => _attempted = true);
    if (!_formKey.currentState!.validate()) {
      _focusField(_firstInvalid);
      return;
    }

    final draft = MailDraft(
      to: AppLinks.email,
      subject: _value(_subject),
      body: '${_value(_message)}\n\n${_value(_name)}\n${_value(_email)}',
    );
    setState(() => _draft = draft);
    UrlUtils.openUrl(draft.mailtoUrl, sameTab: true);
  }

  void _back() {
    setState(() {
      _draft = null;
      _attempted = false;
    });
    _focusField(_name);
  }

  // Focar não rola a página, e o campo poderia ficar sob a navbar. A rolagem vem um quadro antes:
  // o nó semântico de um campo fora da tela só nasce depois dela, e sem ele não se recebe texto.
  Future<void> _focusField(int index) async {
    await WidgetsBinding.instance.endOfFrame;
    final fieldContext = _fieldKeys[index].currentContext;
    if (!mounted || fieldContext == null || !fieldContext.mounted) return;

    await Scrollable.ensureVisible(
      fieldContext,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
    );
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) _focusNodes[index].requestFocus();
  }

  Widget _field(
    int index, {
    required String label,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
  }) {
    return FormTextField(
      key: _fieldKeys[index],
      label: label,
      controller: _controllers[index],
      focusNode: _focusNodes[index],
      validator: _validators[index],
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => _focusNodes[index + 1].requestFocus(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft = _draft;
    if (draft != null) return ContactConfirmation(draft: draft, onBack: _back);

    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final gap = SizedBox(height: components.formFieldGap);
    final mobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;
    final submit = AppButton.primary(
      text: 'Abrir no meu e-mail',
      leadingIcon: Icons.mail_outline,
      fullWidth: mobile,
      onPressed: _submit,
    );

    return Form(
      key: _formKey,
      // Só depois da primeira tentativa; `onUserInteraction` deixaria de fora campos não tocados.
      autovalidateMode: _attempted ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _field(
              _name,
              label: 'Nome',
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.name],
            ),
            gap,
            _field(
              _email,
              label: 'E-mail',
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            gap,
            _field(_subject, label: 'Assunto'),
            gap,
            FormTextField(
              key: _fieldKeys[_message],
              label: 'Mensagem',
              controller: _controllers[_message],
              focusNode: _focusNodes[_message],
              validator: _validators[_message],
              multiline: true,
            ),
            gap,
            if (mobile) submit else Align(alignment: Alignment.centerLeft, child: submit),
            SizedBox(height: components.formHintTop),
            Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: components.formHintMaxWidth),
                child: MarkedText(
                  'Vamos abrir o seu programa de e-mail com a mensagem já preenchida. Falta só '
                  'você apertar **Enviar** por lá.',
                  style: styles.small.copyWith(color: colors.inkSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
