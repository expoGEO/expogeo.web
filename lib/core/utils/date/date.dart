extension DateTimeFormatting on DateTime {
  String get monthName {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    return months[month - 1];
  }

  String get formattedDate => '$day de $monthName de $year';

  String get _shortMonthName {
    const months = [
      'jan',
      'fev',
      'mar',
      'abr',
      'mai',
      'jun',
      'jul',
      'ago',
      'set',
      'out',
      'nov',
      'dez',
    ];

    return months[month - 1];
  }

  /// "12 mar 2025", com os campos como gravados, sem conversão de fuso.
  String get shortDate => '$day $_shortMonthName $year';

  /// "dez 2026", com os campos como gravados, sem conversão de fuso.
  String get monthYear => '$_shortMonthName $year';
}
