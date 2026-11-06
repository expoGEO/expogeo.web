import 'dart:async';

import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/button/inline_link.dart';
import 'package:expogeo/core/components/form/marked_text.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/url/mail_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

enum _CopyStatus { idle, copied, failed }

class ContactConfirmation extends StatefulWidget {
  const ContactConfirmation({super.key, required this.draft, required this.onBack});

  final MailDraft draft;
  final VoidCallback onBack;

  @override
  State<ContactConfirmation> createState() => _ContactConfirmationState();
}

class _ContactConfirmationState extends State<ContactConfirmation> {
  static const String _title = 'Seu e-mail está pronto';
  static const String _copy = 'Copiar mensagem';
  static const String _copied = 'Mensagem copiada';
  static const String _copyFailed = 'Erro ao copiar';

  final FocusNode _titleFocus = FocusNode(skipTraversal: true);
  _CopyStatus _copyStatus = _CopyStatus.idle;
  Timer? _copyTimer;

  @override
  void initState() {
    super.initState();
    // O botão que abriu a confirmação saiu da tela, e o foco do teclado sairia com ele. A caixa é
    // mais baixa que o formulário: sem a rolagem, o topo dela pode parar sob a navbar. O anúncio é
    // explícito porque o motor web não aplica `liveRegion` a títulos.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _titleFocus.requestFocus();
      SemanticsService.announce(_title, TextDirection.ltr);
      Scrollable.ensureVisible(
        context,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    });
  }

  @override
  void dispose() {
    _copyTimer?.cancel();
    _titleFocus.dispose();
    super.dispose();
  }

  Future<void> _copyMessage() async {
    _copyTimer?.cancel();
    var status = _CopyStatus.copied;
    try {
      await Clipboard.setData(ClipboardData(text: widget.draft.copyText));
    } catch (_) {
      status = _CopyStatus.failed;
    }
    if (!mounted) return;

    setState(() => _copyStatus = status);
    SemanticsService.announce(
      status == _CopyStatus.copied ? _copied : _copyFailed,
      TextDirection.ltr,
    );
    _copyTimer = Timer(AppTheme.dimensions.components.copyFeedbackDuration, () {
      if (mounted) setState(() => _copyStatus = _CopyStatus.idle);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final to = widget.draft.to;
    final (copyText, copyIcon) = switch (_copyStatus) {
      _CopyStatus.idle => (_copy, Icons.link),
      _CopyStatus.copied => (_copied, Icons.check),
      _CopyStatus.failed => (_copyFailed, Icons.error_outline),
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: components.mailConfirmationPaddingV,
        horizontal: components.mailConfirmationPaddingH,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r18),
        border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Container(
              width: components.mailConfirmationIcon,
              height: components.mailConfirmationIcon,
              decoration: BoxDecoration(color: colors.successSurface, shape: BoxShape.circle),
              child: Icon(
                Icons.mail_outline,
                size: components.mailConfirmationIconGlyph,
                color: colors.success,
              ),
            ),
          ),
          SizedBox(height: components.mailConfirmationGap),
          Focus(
            focusNode: _titleFocus,
            child: Semantics(
              header: true,
              headingLevel: 2,
              child: Text(
                _title,
                textAlign: TextAlign.center,
                style: styles.confirmationTitle.copyWith(color: colors.ink),
              ),
            ),
          ),
          SizedBox(height: components.mailConfirmationGap),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: components.mailConfirmationTextMaxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MarkedText(
                  'Abrimos o seu programa de e-mail com a mensagem preenchida. Aperte **Enviar** '
                  'por lá para concluir.',
                  textAlign: TextAlign.center,
                  style: styles.regular.copyWith(color: colors.inkSecondary),
                ),
                SizedBox(height: components.mailConfirmationGap),
                Text.rich(
                  TextSpan(
                    style: styles.small.copyWith(color: colors.inkSecondary),
                    children: [
                      const TextSpan(text: 'Não abriu? Copie a mensagem e escreva para '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: InlineLink(text: to, url: 'mailto:$to', style: styles.small),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: components.mailConfirmationGap + components.mailConfirmationButtonsTop),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: components.mailConfirmationButtonsGap,
            runSpacing: components.mailConfirmationButtonsGap,
            children: [
              AppButton.secondary(text: copyText, leadingIcon: copyIcon, onPressed: _copyMessage),
              AppButton.ghost(text: 'Voltar ao formulário', onPressed: widget.onBack),
            ],
          ),
        ],
      ),
    );
  }
}
