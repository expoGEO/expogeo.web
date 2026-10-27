// ignore_for_file: avoid_print, unused_local_variable

/// Arquivo auxiliar com funções de debug e validação para o script de seed.
///
/// Use este arquivo para:
/// - Validar estrutura de dados antes de fazer seed
/// - Debug de conteúdos específicos
/// - Testes de conectividade com Firestore
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/utils/environment/app_environment.dart';
import 'package:firebase_core/firebase_core.dart';

/// Valida se os dados estão estruturados corretamente antes do seed
Future<void> validateStructure() async {
  print('\n🔍 Validando estrutura de dados...\n');

  final themes = ThemeDataModel.themes;

  if (themes.isEmpty) {
    print('❌ ERRO: Nenhum tema encontrado!');
    return;
  }

  print('✅ Temas encontrados: ${themes.length}');

  int totalSubthemes = 0;
  int totalContents = 0;
  final errors = <String>[];

  for (final theme in themes) {
    if (theme.title.isEmpty) {
      errors.add('❌ Tema ${theme.type.value} não tem título');
      continue;
    }

    if (theme.subthemes.isEmpty) {
      errors.add('⚠️  Tema ${theme.type.value} não tem subtemas');
      continue;
    }

    print('\n📋 Tema: ${theme.title}');
    print('   Type: ${theme.type.value}');
    print('   Subtemas: ${theme.subthemes.length}');

    int themeContentCount = 0;

    for (final subtheme in theme.subthemes) {
      if (subtheme.title.isEmpty) {
        errors.add('❌ Subtema sem título no tema ${theme.type.value}');
        continue;
      }

      if (subtheme.contents.isEmpty) {
        errors.add('⚠️  Subtema ${subtheme.type.value} não tem conteúdos');
        continue;
      }

      print('   ├─ Subtema: ${subtheme.title}');
      print('   │  └─ Conteúdos: ${subtheme.contents.length}');

      for (final content in subtheme.contents) {
        // Validar campos obrigatórios
        if (content.id.isEmpty) {
          errors.add('❌ ContentModel sem ID');
        }

        if (content.contentInfo.title.isEmpty) {
          errors.add('❌ ContentModel ${content.id} sem título');
        }

        if (content.registrationInfo.location.isEmpty) {
          errors.add('⚠️  ContentModel ${content.id} sem URL de localização');
        }

        themeContentCount++;
        totalContents++;
      }

      totalSubthemes++;
    }

    print('   └─ Total no tema: $themeContentCount conteúdos\n');
  }

  print('\n📊 Resumo:');
  print('   ✅ Temas: ${themes.length}');
  print('   ✅ Subtemas: $totalSubthemes');
  print('   ✅ Conteúdos: $totalContents');

  if (errors.isEmpty) {
    print('\n✅ Estrutura validada com sucesso! 🎉\n');
  } else {
    print('\n⚠️  Erros e avisos encontrados:\n');
    for (final error in errors) {
      print('   $error');
    }
    print('');
  }
}

/// Testa conexão com Firestore
Future<void> testFirestoreConnection() async {
  print('\n🔌 Testando conexão com Firestore...\n');

  try {
    print('📱 Inicializando Firebase...');
    await Firebase.initializeApp(options: AppEnvironment.current.firebaseOptions);
    print('✅ Firebase inicializado\n');

    final firestore = FirebaseFirestore.instance;

    print('🧪 Escrevendo documento de teste...');
    final testRef = firestore
        .collection('_test')
        .doc('connection_test_${DateTime.now().millisecondsSinceEpoch}');

    await testRef.set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': 'Teste de conexão - pode ser deletado',
    });

    print('✅ Documento escrito com sucesso\n');

    print('🧪 Lendo documento de teste...');
    final testDoc = await testRef.get();

    if (testDoc.exists) {
      print('✅ Documento lido com sucesso\n');
      print('   Dados: ${testDoc.data()}\n');
    } else {
      print('❌ Documento não encontrado após escrita\n');
      return;
    }

    print('🧹 Limpando documento de teste...');
    await testRef.delete();
    print('✅ Documento deletado\n');

    print('✅ Conexão com Firestore OK! 🎉\n');
  } catch (e) {
    print('❌ Erro ao testar conexão: $e\n');
  }
}

/// Lista estatísticas sobre conteúdos por tipo
Future<void> listContentStatistics() async {
  print('\n📊 Estatísticas de Conteúdo...\n');

  final themes = ThemeDataModel.themes;

  final stats = <String, int>{};
  final contentTypeStats = <String, int>{};
  final formatStats = <String, int>{};

  for (final theme in themes) {
    // Contar por subtema
    for (final subtheme in theme.subthemes) {
      final key = '${theme.type.value}/${subtheme.type.value}';
      stats[key] = (stats[key] ?? 0) + subtheme.contents.length;

      // Contar por tipo de conteúdo
      for (final content in subtheme.contents) {
        final typeKey = content.originInfo.type.value;
        contentTypeStats[typeKey] = (contentTypeStats[typeKey] ?? 0) + 1;

        // Contar por formato
        final formatKey = content.originInfo.format.value;
        formatStats[formatKey] = (formatStats[formatKey] ?? 0) + 1;
      }
    }
  }

  print('📈 Conteúdos por Subtema:');
  stats.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value))
    ..forEach((entry) {
      print('   ${entry.key}: ${entry.value}');
    });

  print('\n📺 Conteúdos por Tipo:');
  contentTypeStats.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value))
    ..forEach((entry) {
      print('   ${entry.key}: ${entry.value}');
    });

  print('\n📄 Conteúdos por Formato:');
  formatStats.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value))
    ..forEach((entry) {
      print('   ${entry.key}: ${entry.value}');
    });

  final totalContents = stats.values.fold<int>(0, (total, val) => total + val);
  print('\n✅ Total de conteúdos: $totalContents\n');
}

/// Encontra conteúdos específicos por ID
Future<void> findContentById(String contentId) async {
  print('\n🔍 Procurando conteúdo: $contentId\n');

  final themes = ThemeDataModel.themes;

  for (final theme in themes) {
    for (final subtheme in theme.subthemes) {
      final found = subtheme.contents.firstWhere(
        (content) => content.id == contentId,
        orElse: () => null as dynamic,
      );

      final content = found;
      print('✅ Encontrado!\n');
      print('   ID: ${content.id}');
      print('   Tema: ${theme.title}');
      print('   Subtema: ${subtheme.title}');
      print('   Título: ${content.contentInfo.title}');
      print('   Tipo: ${content.originInfo.type.value}');
      print('   Formato: ${content.originInfo.format.value}');
      print('   URL: ${content.registrationInfo.location}');
      return;
    }
  }

  print('❌ Conteúdo não encontrado\n');
}

/// Exibe informações sobre um tema específico
Future<void> showThemeInfo(String themeId) async {
  print('\n📋 Informações do Tema: $themeId\n');

  final theme = ThemeDataModel.themes.firstWhere(
    (t) => t.type.value == themeId,
    orElse: () => null as dynamic,
  );

  final themeDyn = theme as dynamic;

  print('   Título: ${themeDyn.title}');
  print('   Type: ${themeDyn.type.value}');
  print('   Subtemas: ${themeDyn.subthemes.length}');

  int totalContents = 0;
  for (final subtheme in themeDyn.subthemes) {
    totalContents += (subtheme.contents.length as int);
  }

  print('   Total de conteúdos: $totalContents\n');

  print('   Subtemas:');
  for (final subtheme in themeDyn.subthemes) {
    print('      • ${subtheme.title} (${subtheme.contents.length} conteúdos)');
  }

  print('');
}
