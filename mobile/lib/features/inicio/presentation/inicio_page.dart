import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/rotas.dart';
import '../../../app/tema.dart';
import '../../../app/widgets/identidade.dart';
import '../../../core/config/ambiente.dart';
import '../../auth/presentation/menu_usuario.dart';
import '../../auth/presentation/sessao_controller.dart';

/// Tela inicial do operador: movimentar estoque e consultar saldo.
class InicioPage extends ConsumerWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ambiente = ref.watch(ambienteProvider);
    final usuario = ref.watch(usuarioProvider);
    final tema = Theme.of(context);
    final cores = context.cores;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          CabecalhoTinta(
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [MarcaStowise(clara: true, tamanho: 20), Spacer(), MenuUsuario()]),
                  const SizedBox(height: 28),
                  if (usuario != null)
                    Text(
                      'Olá, ${usuario.primeiroNome}',
                      style: tema.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'O que você quer fazer?',
                    style: tema.textTheme.titleMedium?.copyWith(color: Colors.white.withValues(alpha: 0.75)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(
              children: [
                _Acao(
                  icone: Icons.swap_horiz_rounded,
                  titulo: 'Movimentar estoque',
                  subtitulo: 'Entrada, saída e transferência',
                  gradiente: cores.gradienteMarca(tema.colorScheme.primary),
                  brilho: tema.colorScheme.primary,
                  onTap: () => context.push(Rotas.movimentar),
                ),
                const SizedBox(height: 14),
                _Acao(
                  icone: Icons.inventory_2_outlined,
                  titulo: 'Consultar saldo',
                  subtitulo: 'Por produto ou por endereço',
                  gradiente: cores.gradienteSinal,
                  brilho: cores.sinal,
                  onTap: () => context.push(Rotas.saldo),
                ),
                if (ambiente.dev) ...[
                  const SizedBox(height: 28),
                  Text(
                    'Ambiente ${ambiente.nome} · ${ambiente.apiUrl}',
                    style: tema.textTheme.bodySmall?.copyWith(color: tema.colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Ação principal: cartão elevado com o ícone num bloco em degradê e brilho da sua cor.
class _Acao extends StatelessWidget {
  const _Acao({
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.gradiente,
    required this.brilho,
    required this.onTap,
  });

  final IconData icone;
  final String titulo;
  final String subtitulo;
  final Gradient gradiente;
  final Color brilho;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = context.cores;
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), boxShadow: cores.sombraCartao),
      child: Material(
        color: tema.cardTheme.color,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              // Faixa da cor da ação à esquerda, como a borda de uma etiqueta.
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(width: 5, decoration: BoxDecoration(gradient: gradiente)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 14, 18),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: gradiente,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: cores.brilho(brilho),
                      ),
                      child: Icon(icone, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(titulo, style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(
                            subtitulo,
                            style: tema.textTheme.bodyMedium?.copyWith(color: tema.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: tema.colorScheme.onSurfaceVariant),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
