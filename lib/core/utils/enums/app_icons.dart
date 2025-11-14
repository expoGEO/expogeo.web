import "package:expogeo/core/utils/string/string_utils.dart";

enum AppIcons {
  x;

  String get path => "assets/icons/${convertToSnakeCase(name)}.svg";
}
