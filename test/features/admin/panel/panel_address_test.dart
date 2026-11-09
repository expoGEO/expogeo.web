import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_address.dart';
import 'package:expogeo/features/admin/panel/presentation/panel_list_memory.dart';
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

    test('tipo e busca', () {
      final selection = PanelSelection.fromQuery({
        'tema': 'natureza-meio-ambiente',
        'subtema': 'biomas',
        'tipo': 'video',
        'q': '  Cerrado  ',
      });
      expect(selection.type, ContentType.video);
      expect(selection.query, 'Cerrado');
      expect(selection.hasNarrowingFilter, isTrue);
    });

    test('tipo desconhecido ou pelo rótulo é ignorado; busca em branco vira nula', () {
      expect(PanelSelection.fromQuery({'tipo': 'xyz'}), const PanelSelection());
      expect(PanelSelection.fromQuery({'tipo': 'Vídeo'}), const PanelSelection());
      expect(PanelSelection.fromQuery({'q': '   '}), const PanelSelection());
      expect(const PanelSelection(theme: ThemeEnum.culturaPolitica).hasNarrowingFilter, isFalse);
    });

    test('tema desconhecido não leva junto o tipo e a busca', () {
      expect(
        PanelSelection.fromQuery({'tema': 'xyz', 'tipo': 'site', 'q': 'mapa'}),
        const PanelSelection(type: ContentType.site, query: 'mapa'),
      );
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

  test('montagem com tipo e busca, ida e volta', () {
    const selection = PanelSelection(
      theme: ThemeEnum.naturezaMeioAmbiente,
      subtheme: SubthemeEnum.baciasHidrograficas,
      type: ContentType.documento,
      query: 'São Paulo',
    );
    final address = PanelAddress.objectsWith(selection);

    expect(
      address,
      '/admin/painel/objetos?tema=natureza-meio-ambiente&subtema=bacias-hidrograficas'
      '&tipo=documento&q=S%C3%A3o+Paulo',
    );
    expect(PanelSelection.fromQuery(Uri.parse(address).queryParameters), selection);
    expect(PanelAddress.objectsOf(query: '  '), '/admin/painel/objetos');
    expect(PanelAddress.objectsOf(type: ContentType.site), '/admin/painel/objetos?tipo=site');
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

  group('editor', () {
    test('novo objeto sem filtros, só com tema e com tema e subtema', () {
      expect(PanelAddress.newObject(), '/admin/painel/objetos/novo');
      expect(
        PanelAddress.newObject(theme: ThemeEnum.naturezaMeioAmbiente),
        '/admin/painel/objetos/novo?tema=natureza-meio-ambiente',
      );
      expect(
        PanelAddress.newObject(
          theme: ThemeEnum.naturezaMeioAmbiente,
          subtheme: SubthemeEnum.baciasHidrograficas,
        ),
        '/admin/painel/objetos/novo?tema=natureza-meio-ambiente&subtema=bacias-hidrograficas',
      );
    });

    test('subtema de outro tema não entra no endereço do novo', () {
      expect(
        PanelAddress.newObject(theme: ThemeEnum.culturaPolitica, subtheme: SubthemeEnum.biomas),
        '/admin/painel/objetos/novo?tema=cultura-politica',
      );
    });

    test('ida e volta do novo pelo endereço; valores desconhecidos são ignorados', () {
      final uri = Uri.parse(
        PanelAddress.newObject(theme: ThemeEnum.culturaPolitica, subtheme: SubthemeEnum.populacao),
      );
      final selection = PanelSelection.fromQuery(uri.queryParameters);
      expect(selection.theme, ThemeEnum.culturaPolitica);
      expect(selection.subtheme, SubthemeEnum.populacao);

      final unknown = PanelSelection.fromQuery({'tema': 'xyz', 'subtema': 'biomas'});
      expect(unknown.theme, isNull);
      expect(unknown.subtheme, isNull);
    });

    test('editar leva o código em minúsculas e hífen', () {
      expect(PanelAddress.editObject('NMA_BH_03'), '/admin/painel/objetos/nma-bh-03/editar');
      expect(PanelAddress.editObject('nma-bh-03'), '/admin/painel/objetos/nma-bh-03/editar');
    });
  });

  test('a memória da lista começa na lista sem filtros e guarda o último endereço', () {
    final memory = PanelListMemory();
    expect(memory.location, '/admin/painel/objetos');

    memory.remember('/admin/painel/objetos?tema=cultura-politica&q=censo');
    expect(memory.location, '/admin/painel/objetos?tema=cultura-politica&q=censo');
  });
}
