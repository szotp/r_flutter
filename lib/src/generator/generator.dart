import 'package:dart_style/dart_style.dart';
import 'package:r_flutter/src/arguments.dart';
import 'package:r_flutter/src/generator/assets_generator.dart';
import 'package:r_flutter/src/generator/fonts_generator.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/resources.dart';
import 'package:recase/recase.dart';

import 'i18n/generator.dart';

final _formatter = DartFormatter();

String generateFile(Resources res, Config arguments) {
  var classes = <DartClass>[];
  if (res.i18n != null) {
    classes.addAll(generateI18nClasses(res.i18n));
  }
  classes.add(generateFontClass(res.fonts));
  classes.addAll(generateAssetsClass(res.assets.assets));

  classes = classes.where((item) => item != null).toList();

  final fullCode = StringBuffer("");
  fullCode.writeln(
      '//ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names, camel_case_types, unnecessary_string_escapes');
  final imports = classes.expand((it) => it.imports).toSet().toList();
  imports.sort();
  for (final import in imports) {
    fullCode.writeln("import '$import';");
  }

  if (fullCode.isNotEmpty) {
    fullCode.write("\n");
  }

  for (final dartClass in classes) {
    fullCode.writeln(dartClass.code);
  }

  return _formatter.format(fullCode.toString());
}

String createVariableName(String name) {
  return ReCase(name)
      .camelCase
      .replaceAll(r"ä", "ae")
      .replaceAll(r"ö", "oe")
      .replaceAll(r"ü", "ue")
      .replaceAll(r"Ä", "Ae")
      .replaceAll(r"Ö", "Oe")
      .replaceAll(r"Ü", "Üe")
      .replaceAll(r"ß", "ss")
      .replaceAll(RegExp(r"[^a-zA-Z0-9]"), "");
}
