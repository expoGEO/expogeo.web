import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('leitura do endereço', () {
    test('tema e subtema conhecidos', () {
      final selection = PanelSelection.fromQuery({
        'tema': 'natureza-meio-ambiente',
        'subtema': 'biomas',
      });
      expect(selection.theme, ThemeEnum.naturezaMeioAmbiente);
      expect(selection.subtheme, SubthemeEnum.biomas);
    });

    test('tema desconhecido é ignorado, com ou sem subtema', () {
      expect(PanelSelection.fromQuery({'tema': 'xyz'}), const PanelSelection());
      expect(
        PanelSelection.fromQuery({'tema': 'xyz', 'subtema': 'biomas'}),
        const PanelSelection(),
      );
      expect(PanelSelection.fromQuery({'subtema': 'biomas'}), const PanelSelection());
    });

    test('subtema de outro tema ou desconhecido fica só com o tema', () {
      const onlyTheme = PanelSelection(theme: ThemeEnum.culturaPolitica);
      expect(
        PanelSelection.fromQuery({'tema': 'cultura-politica', 'subtema': 'biomas'}),
        onlyTheme,
      );
      expect(PanelSelection.fromQuery({'tema': 'cultura-politica', 'subtema': 'xyz'}), onlyTheme);
    });

    test('Movimentos da Terra fica de fora, como no site', () {
      final selection = PanelSelection.fromQuery({
        'tema': 'representacoes-espaciais',
        'subtema': 'movimentos-terra',
      });
      expect(selection, const PanelSelection(theme: ThemeEnum.representacoesEspaciais));
    });
  });

  test('montagem dos endereços', () {
    expect(PanelAddress.objectsOf(), '/admin/painel/objetos');
    expect(
      PanelAddress.objectsOf(theme: ThemeEnum.naturezaMeioAmbiente),
      '/admin/painel/objetos?tema=natureza-meio-ambiente',
    );
    expect(
      PanelAddress.objectsOf(theme: ThemeEnum.naturezaMeioAmbiente, subtheme: SubthemeEnum.biomas),
      '/admin/painel/objetos?tema=natureza-meio-ambiente&subtema=biomas',
    );
    expect(PanelAddress.of(PanelView.themes), '/admin/painel/temas');
  });

  group('iniciais', () {
    test('com separador, a inicial das duas primeiras partes', () {
      expect(initialsOf('ana.souza@x.com'), 'AS');
      expect(initialsOf('ana_maria-souza@x.com'), 'AM');
    });

    test('sem separador, as duas primeiras letras', () {
      expect(initialsOf('curadoria@x.com'), 'CU');
      expect(initialsOf('a@x.com'), 'A');
    });

    test('e-mail vazio não tem iniciais', () {
      expect(initialsOf(''), '');
      expect(initialsOf('@x.com'), '');
    });
  });
}
