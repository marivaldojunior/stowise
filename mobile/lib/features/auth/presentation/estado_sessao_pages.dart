import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/erros.dart';
import 'sessao_controller.dart';

/// Abertura do app, enquanto a sessão guardada é retomada.
class CarregandoPage extends StatelessWidget {
  const CarregandoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(semanticsLabel: 'Verificando a sessão')),
    );
  }
}

/// Há sessão guardada, mas a API não respondeu: tentar de novo ou entrar com outra conta.
class SemConexaoPage extends ConsumerWidget {
  const SemConexaoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tema = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.cloud_off_outlined, size: 48, color: tema.colorScheme.onSurfaceVariant),
              const SizedBox(height: 16),
              Text('Sem conexão', style: tema.textTheme.headlineSmall, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text(mensagemSemConexao, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => ref.read(sessaoProvider.notifier).tentarDeNovo(),
                child: const Text('Tentar de novo'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.read(sessaoProvider.notifier).sair(),
                child: const Text('Entrar com outra conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
