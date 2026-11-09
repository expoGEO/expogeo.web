import 'package:flutter/semantics.dart';

/// Anuncia um texto a leitores de tela.
///
/// O Flutter 3.35.5, fixado no projeto, ainda não tem `sendAnnouncement`; ao subir o SDK,
/// a troca fica só aqui.
void announceToScreenReader(
  String message,
  TextDirection textDirection, {
  Assertiveness assertiveness = Assertiveness.polite,
}) {
  // ignore: deprecated_member_use
  SemanticsService.announce(message, textDirection, assertiveness: assertiveness);
}
