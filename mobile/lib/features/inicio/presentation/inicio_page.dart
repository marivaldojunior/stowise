import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/ambiente.dart';
import '../../auth/presentation/menu_usuario.dart';
import '../../auth/presentation/sessao_controller.dart';

/// Tela inicial do operador. As ações (movimentação e consulta) entram nas tarefas seguintes do plano.
class InicioPage extends ConsumerWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ambiente = ref.watch(ambienteProvider);
    final usuario = ref.watch(usuarioProvider);
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Stowise'), actions: const [MenuUsuario()]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (usuario != null) Text('Olá, ${usuario.primeiroNome}', style: tema.textTheme.headlineSmall),
          Text('O que você quer fazer?', style: tema.textTheme.titleMedium),
          const SizedBox(height: 16),
          const Card(
            child: ListTile(
              leading: Icon(Icons.swap_horiz),
              title: Text('Movimentar estoque'),
              subtitle: Text('Em breve'),
              enabled: false,
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.inventory_2_outlined),
              title: Text('Consultar saldo'),
              subtitle: Text('Em breve'),
              enabled: false,
            ),
          ),
          if (ambiente.dev) ...[
            const SizedBox(height: 24),
            Text(
              'Ambiente ${ambiente.nome} · ${ambiente.apiUrl}',
              style: tema.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
