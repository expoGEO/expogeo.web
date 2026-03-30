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
}
