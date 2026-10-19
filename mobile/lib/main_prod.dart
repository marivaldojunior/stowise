import 'bootstrap.dart';
import 'core/config/ambiente.dart';

/// flutter build apk --flavor prod -t lib/main_prod.dart --dart-define=STOWISE_API_URL=https://...
void main() => bootstrap(Ambiente.prod());
