import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Preferências do aparelho que não são segredo (ex.: o armazém escolhido). Segredos vão no Cofre.
abstract interface class Preferencias {
  Future<String?> ler(String chave);
  Future<void> gravar(String chave, String valor);
}

class PreferenciasDoAparelho implements Preferencias {
  final _armazenamento = SharedPreferencesAsync();

  @override
  Future<String?> ler(String chave) => _armazenamento.getString(chave);

  @override
  Future<void> gravar(String chave, String valor) => _armazenamento.setString(chave, valor);
}

final preferenciasProvider = Provider<Preferencias>((ref) => PreferenciasDoAparelho());

const _chaveDispositivo = 'stowise.dispositivo_id';

/// Id desta instalação do app, enviado em cada movimentação (dispositivoId) para a auditoria saber de onde veio.
final dispositivoIdProvider = FutureProvider<String>((ref) async {
  final preferencias = ref.watch(preferenciasProvider);
  final atual = await preferencias.ler(_chaveDispositivo);
  if (atual != null) {
    return atual;
  }

  final novo = const Uuid().v7();
  await preferencias.gravar(_chaveDispositivo, novo);
  return novo;
});
