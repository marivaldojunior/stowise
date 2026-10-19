import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/armazenamento/preferencias.dart';
import '../data/estoque_repository.dart';
import '../domain/estoque.dart';

const _chaveArmazem = 'stowise.armazem_id';

class ArmazensDisponiveis {
  const ArmazensDisponiveis({required this.lista, required this.atual});

  final List<Armazem> lista;

  /// Armazém de trabalho: o último escolhido neste aparelho, ou o único que existe.
  final Armazem? atual;
}

/// O código do endereço só é único dentro do armazém: o operador trabalha num armazém, lembrado no aparelho.
class ArmazemController extends AsyncNotifier<ArmazensDisponiveis> {
  @override
  Future<ArmazensDisponiveis> build() async {
    final lista = await ref.watch(estoqueRepositoryProvider).listarArmazens();
    final guardado = await ref.watch(preferenciasProvider).ler(_chaveArmazem);
    final atual = lista.where((a) => a.id == guardado).firstOrNull ?? (lista.length == 1 ? lista.single : null);
    return ArmazensDisponiveis(lista: lista, atual: atual);
  }

  Future<void> escolher(Armazem armazem) async {
    await ref.read(preferenciasProvider).gravar(_chaveArmazem, armazem.id);
    final lista = state.value?.lista ?? [armazem];
    state = AsyncData(ArmazensDisponiveis(lista: lista, atual: armazem));
  }
}

final armazemProvider = AsyncNotifierProvider<ArmazemController, ArmazensDisponiveis>(ArmazemController.new);

/// Seletor do armazém de trabalho (aparece quando há mais de um).
class SeletorArmazem extends ConsumerWidget {
  const SeletorArmazem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final armazens = ref.watch(armazemProvider);
    return switch (armazens) {
      AsyncData(:final value) when value.lista.isEmpty => const ListTile(
        leading: Icon(Icons.warehouse_outlined),
        title: Text('Nenhum armazém cadastrado'),
      ),
      AsyncData(:final value) => DropdownButtonFormField<String>(
        initialValue: value.atual?.id,
        decoration: const InputDecoration(labelText: 'Armazém', prefixIcon: Icon(Icons.warehouse_outlined)),
        items: [
          for (final armazem in value.lista)
            DropdownMenuItem(value: armazem.id, child: Text('${armazem.codigo} · ${armazem.nome}')),
        ],
        onChanged: (id) => ref.read(armazemProvider.notifier).escolher(value.lista.firstWhere((a) => a.id == id)),
      ),
      AsyncError(:final error) => ListTile(
        leading: const Icon(Icons.error_outline),
        title: Text('$error'),
        trailing: TextButton(onPressed: () => ref.invalidate(armazemProvider), child: const Text('Tentar de novo')),
      ),
      _ => const LinearProgressIndicator(),
    };
  }
}
