/// Nomes dos meses, de janeiro a dezembro.
const List<String> monthNames = [
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

extension DateTimeFormatting on DateTime {
  String get monthName => monthNames[month - 1];

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

  /// "2026-12-01", com os campos como estão, sem conversão de fuso: é como as datas são gravadas.
  String get isoDay =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';
}
