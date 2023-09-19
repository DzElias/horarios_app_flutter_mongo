import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppMaterialLocalization extends DefaultMaterialLocalizations {

  const AppMaterialLocalization();

  @override
  String get invalidTimeLabel => 'Hora incorrecta';

  @override
  String get timePickerDialHelpText => 'Seleccionar Hora';

  @override
  String get timePickerHourLabel => 'Hora';

  @override
  String get timePickerInputHelpText => 'Introduzca la hora';

  @override
  String get timePickerMinuteLabel => 'Minuto';


  static Future<MaterialLocalizations> load(Locale locale) {
    return SynchronousFuture<MaterialLocalizations>(const AppMaterialLocalization());
  }

  static const LocalizationsDelegate<MaterialLocalizations> delegate = _AppMaterialLocalizationsDelegate();
}

class _AppMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _AppMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return const AppMaterialLocalization();
  }

  @override
  bool shouldReload(LocalizationsDelegate<MaterialLocalizations> old) =>
      false;
}