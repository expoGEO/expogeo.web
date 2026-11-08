import 'package:expogeo/core/components/button/app_button.dart';
import 'package:expogeo/core/components/state/state_message_box.dart';
import 'package:flutter/material.dart';

/// Falha ao carregar o conteúdo principal de uma página, com nova tentativa.
class StateErrorBox extends StatelessWidget {
  const StateErrorBox({super.key, required this.title, required this.onRetry});

  static const String message = 'Confira sua conexão com a internet e tente de novo.';
  static const String retryLabel = 'Tentar de novo';

  final String title;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return StateMessageBox(
      icon: Icons.error_outline,
      tone: StateMessageTone.error,
      title: title,
      message: message,
      action: AppButton.primary(text: retryLabel, onPressed: onRetry),
    );
  }
}
