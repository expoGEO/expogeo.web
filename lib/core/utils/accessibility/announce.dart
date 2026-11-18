import 'package:flutter/semantics.dart';

/// Anuncia um texto a leitores de tela. O SDK fixado só tem `announce`, obsoleto; a troca por
/// `sendAnnouncement` fica só aqui.
void announceToScreenReader(
  String message,
  TextDirection textDirection, {
  Assertiveness assertiveness = Assertiveness.polite,
}) {
  // ignore: deprecated_member_use
  SemanticsService.announce(message, textDirection, assertiveness: assertiveness);
}
