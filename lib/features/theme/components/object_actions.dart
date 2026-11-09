import 'dart:async';

import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/accessibility/announce.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/core/utils/url/url_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _CopyStatus { idle, copied, failed }

class ObjectActions extends StatefulWidget {
  const ObjectActions({super.key, required this.address});

  final String address;

  @override
  State<ObjectActions> createState() => _ObjectActionsState();
}

class _ObjectActionsState extends State<ObjectActions> {
  static const String _copiedMessage = 'Link copiado';
  static const String _failedMessage = 'Não deu para copiar. Selecione o endereço abaixo.';

  final GlobalKey<SelectionAreaState> _selectionKey = GlobalKey();

  final FocusNode _addressFocusNode = FocusNode();

  _CopyStatus _status = _CopyStatus.idle;
  Timer? _timer;

  String get _address => widget.address.trim();

  @override
  void dispose() {
    _timer?.cancel();
    _addressFocusNode.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    _timer?.cancel();
    var status = _CopyStatus.copied;
    try {
      await Clipboard.setData(ClipboardData(text: _address));
    } catch (_) {
      status = _CopyStatus.failed;
    }
    if (!mounted) return;

    setState(() => _status = status);
    announceToScreenReader(
      status == _CopyStatus.copied ? _copiedMessage : _failedMessage,
      TextDirection.ltr,
    );

    if (status == _CopyStatus.copied) {
      _timer = Timer(AppTheme.dimensions.components.copyFeedbackDuration, () {
        if (mounted) setState(() => _status = _CopyStatus.idle);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _selectAddress());
    }
  }

  void _selectAddress() {
    final selection = _selectionKey.currentState;
    if (!mounted || selection == null) return;
    _addressFocusNode.requestFocus();
    selection.selectableRegion.selectAll();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final address = _address;
    final canOpen = UrlUtils.isOpenable(address);
    final copied = _status == _CopyStatus.copied;
    final gap = components.objectActionsGap;

    final mobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;

    final open = AppButton.primary(
      text: 'Acessar o recurso',
      externalUrl: canOpen ? address : null,
      trailingIcon: Icons.north_east,
      isDisabled: !canOpen,
      fullWidth: mobile,
    );
    final copy = AppButton.secondary(
      text: copied ? _copiedMessage : 'Copiar link',
      leadingIcon: Icons.link,
      isDisabled: !canOpen,
      onPressed: canOpen ? _copy : null,
      fullWidth: mobile,
    );
    final textStyle = AppTheme.typography
        .of(context)
        .small
        .copyWith(fontSize: components.objectAddressText, color: colors.inkSecondary);

    return Padding(
      padding: EdgeInsets.only(top: components.objectHeadActionsGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (mobile) ...[
            open,
            SizedBox(height: gap),
            copy,
          ] else
            Wrap(spacing: gap, runSpacing: gap, children: [open, copy]),
          if (!canOpen)
            Padding(
              padding: EdgeInsets.only(top: components.objectAddressTop),
              child: Semantics(
                container: true,
                child: Text('Endereço indisponível', style: textStyle.copyWith(color: colors.ink)),
              ),
            ),
          if (_status == _CopyStatus.failed)
            Padding(
              padding: EdgeInsets.only(top: components.objectAddressTop),
              child: Semantics(
                container: true,
                child: Text(_failedMessage, style: textStyle.copyWith(color: colors.error)),
              ),
            ),
          if (address.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: components.objectAddressTop),
              // Área própria, separada da seleção da página: assim selecionar tudo pega só o
              // endereço. No web ela traz uma visão de plataforma, que seria uma parada invisível
              // do Tab; o foco por código continua valendo.
              child: ExcludeFocusTraversal(
                child: SelectionContainer.disabled(
                  child: SelectionArea(
                    key: _selectionKey,
                    focusNode: _addressFocusNode,
                    child: Semantics(container: true, child: Text(address, style: textStyle)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
