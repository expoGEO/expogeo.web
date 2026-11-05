import 'package:expogeo/core/utils/date/date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

  for (final (index, month) in months.indexed) {
    test('mês ${index + 1} sai como "$month"', () {
      final date = DateTime(2025, index + 1, 12);

      expect(date.shortDate, '12 $month 2025');
      expect(date.monthYear, '$month 2025');
    });
  }

  test('dia sem zero à esquerda', () => expect(DateTime(2025, 3, 2).shortDate, '2 mar 2025'));

  test('data gravada em UTC não desloca o dia', () {
    final date = DateTime.parse('2026-12-01T00:00:00.000Z');

    expect(date.shortDate, '1 dez 2026');
    expect(date.monthYear, 'dez 2026');
  });
}
