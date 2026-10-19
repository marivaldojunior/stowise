import 'package:flutter/material.dart';

import '../tema.dart';

enum TomAviso { sucesso, aviso, erro }

/// Mensagem em destaque, com o mesmo sentido de cor do painel. O leitor de tela anuncia quando ela aparece.
class Aviso extends StatelessWidget {
  const Aviso({required this.texto, required this.tom, super.key});

  final String texto;
  final TomAviso tom;

  @override
  Widget build(BuildContext context) {
    final (cor, icone) = switch (tom) {
      TomAviso.sucesso => (context.cores.sucesso, Icons.check_circle_outline),
      TomAviso.aviso => (context.cores.aviso, Icons.info_outline),
      TomAviso.erro => (Theme.of(context).colorScheme.error, Icons.error_outline),
    };
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cor.withValues(alpha: 0.08),
          border: Border.all(color: cor.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, color: cor, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(texto)),
          ],
        ),
      ),
    );
  }
}
