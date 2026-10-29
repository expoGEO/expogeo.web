import 'package:expogeo/core/components/structure/navbar/navbar_location.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  NavbarLocation at(String path) => NavbarLocation.fromUri(Uri.parse(path));

  test('página inicial não marca nenhum item', () {
    expect(at('/').section, isNull);
  });

  test('tema e subtema marcam Temas', () {
    expect(at('/representacoes-espaciais').section, NavbarSection.themes);
    expect(at('/representacoes-espaciais').theme, ThemeEnum.representacoesEspaciais);
    expect(at('/natureza-meio-ambiente/biomas').section, NavbarSection.themes);
    expect(at('/natureza-meio-ambiente/biomas').theme, ThemeEnum.naturezaMeioAmbiente);
  });

  test('Sobre e Contato', () {
    expect(at('/sobre').section, NavbarSection.about);
    expect(at('/contato').section, NavbarSection.contact);
  });

  test('admin e endereço inexistente não marcam nada', () {
    expect(at('/admin').section, isNull);
    expect(at('/nao-existe').section, isNull);
  });
}
