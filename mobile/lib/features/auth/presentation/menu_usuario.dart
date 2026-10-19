import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sessao_controller.dart';

/// Avatar com as iniciais; o menu mostra nome, e-mail e perfis e tem o "Sair".
class MenuUsuario extends ConsumerWidget {
  const MenuUsuario({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioProvider);
    if (usuario == null) {
      return const SizedBox.shrink();
    }

    final tema = Theme.of(context);
    final partes = usuario.nome.trim().split(RegExp(r'\s+'));
    final iniciais = (partes.first[0] + (partes.length > 1 ? partes.last[0] : '')).toUpperCase();

    return PopupMenuButton<void>(
      tooltip: 'Menu do usuário',
      position: PopupMenuPosition.under,
      icon: CircleAvatar(
        radius: 16,
        backgroundColor: tema.colorScheme.primaryContainer,
        child: Text(iniciais, style: TextStyle(fontSize: 12, color: tema.colorScheme.onPrimaryContainer)),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<void>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(usuario.nome, style: tema.textTheme.titleSmall),
              Text(usuario.email, style: tema.textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(usuario.perfis.join(' · '), style: tema.textTheme.labelSmall),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          onTap: () => ref.read(sessaoProvider.notifier).sair(),
          child: const ListTile(leading: Icon(Icons.logout), title: Text('Sair'), contentPadding: EdgeInsets.zero),
        ),
      ],
    );
  }
}
