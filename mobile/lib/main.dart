import 'bootstrap.dart';
import 'core/config/ambiente.dart';

/// Padrão do `flutter run` sem -t: o ambiente de desenvolvimento.
void main() => bootstrap(Ambiente.dev());
