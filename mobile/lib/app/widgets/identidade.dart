import 'package:flutter/material.dart';

import '../tema.dart';

/// Logotipo: o símbolo em degradê da marca e o nome com "wise" (inteligente) na cor da IA. O nome junta "stow"
/// (armazenar) e "wise", que dividem o mesmo "w".
class MarcaStowise extends StatelessWidget {
  const MarcaStowise({this.clara = false, this.tamanho = 22, super.key});

  /// Texto branco, para fundo escuro (cabeçalho, login).
  final bool clara;
  final double tamanho;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = context.cores;
    final estilo = TextStyle(
      fontSize: tamanho,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
      color: clara ? Colors.white : tema.colorScheme.onSurface,
    );
    return Semantics(
      label: 'Stowise',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: tamanho * 1.7,
                height: tamanho * 1.7,
                decoration: BoxDecoration(
                  gradient: cores.gradienteMarca(tema.colorScheme.primary),
                  borderRadius: BorderRadius.circular(tamanho * 0.5),
                  boxShadow: cores.brilho(tema.colorScheme.primary),
                ),
                child: Icon(Icons.widgets_outlined, color: Colors.white, size: tamanho),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  width: tamanho * 0.5,
                  height: tamanho * 0.5,
                  decoration: BoxDecoration(
                    color: cores.sinal,
                    shape: BoxShape.circle,
                    border: Border.all(color: clara ? cores.tinta : tema.colorScheme.surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: tamanho * 0.5),
          Text('Sto', style: estilo),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (area) => cores.gradienteIa.createShader(area),
            child: Text('wise', style: estilo),
          ),
        ],
      ),
    );
  }
}

/// Área escura do topo: degradê da tinta com brilhos da marca e da IA.
class CabecalhoTinta extends StatelessWidget {
  const CabecalhoTinta({required this.child, this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 28), super.key});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    return Container(
      decoration: BoxDecoration(
        gradient: cores.gradienteTinta,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [BoxShadow(color: cores.sombra, blurRadius: 24, spreadRadius: -8, offset: const Offset(0, 12))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Brilho da marca no canto e da IA do outro lado, como no painel web.
          Positioned(top: -60, left: -40, child: _Brilho(cor: Theme.of(context).colorScheme.primary)),
          Positioned(bottom: -70, right: -50, child: _Brilho(cor: cores.ia, opacidade: 0.28)),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}

class _Brilho extends StatelessWidget {
  const _Brilho({required this.cor, this.opacidade = 0.45});

  final Color cor;
  final double opacidade;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            cor.withValues(alpha: opacidade),
            cor.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

/// Barra superior das telas internas: tinta em degradê com a faixa de assinatura.
class BarraStowise extends StatelessWidget implements PreferredSizeWidget {
  const BarraStowise({required this.titulo, this.acoes = const [], super.key});

  final String titulo;
  final List<Widget> acoes;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 3);

  @override
  Widget build(BuildContext context) {
    final cores = context.cores;
    return AppBar(
      title: Text(titulo),
      actions: acoes,
      flexibleSpace: DecoratedBox(decoration: BoxDecoration(gradient: cores.gradienteTinta)),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(3),
        child: Container(
          height: 3,
          decoration: BoxDecoration(gradient: cores.faixa(Theme.of(context).colorScheme.primary)),
        ),
      ),
    );
  }
}

/// Botão principal em degradê, com brilho. Continua sendo um FilledButton (acessibilidade e testes iguais).
class BotaoGradiente extends StatelessWidget {
  const BotaoGradiente({required this.onPressed, required this.child, this.gradiente, super.key});

  final VoidCallback? onPressed;
  final Widget child;

  /// Padrão: o degradê da marca.
  final Gradient? gradiente;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = context.cores;
    final ativo = onPressed != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: ativo ? (gradiente ?? cores.gradienteMarca(tema.colorScheme.primary)) : null,
        color: ativo ? null : tema.colorScheme.onSurface.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        boxShadow: ativo ? cores.brilho(tema.colorScheme.primary) : null,
      ),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        child: child,
      ),
    );
  }
}

/// Código como impresso na etiqueta da prateleira: borda âmbar à esquerda e fonte monoespaçada.
class Etiqueta extends StatelessWidget {
  const Etiqueta(this.codigo, {this.grande = false, super.key});

  final String codigo;
  final bool grande;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    // A borda com cantos arredondados precisa de uma cor só: a faixa âmbar é um filho, não um lado da borda.
    return Container(
      decoration: BoxDecoration(
        color: tema.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: tema.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: context.cores.sinal),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: grande ? 9 : 6, vertical: grande ? 4 : 2),
              child: Text(
                codigo,
                // Algarismos de largura fixa: os códigos alinham como na etiqueta impressa.
                style: TextStyle(
                  fontFeatures: const [FontFeature.tabularFigures()],
                  fontSize: grande ? 15 : 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: tema.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Código de barras decorativo (barras de larguras variadas).
class CodigoDeBarras extends StatelessWidget {
  const CodigoDeBarras({required this.cor, this.largura = 64, this.altura = 18, super.key});

  final Color cor;
  final double largura;
  final double altura;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: largura,
    height: altura,
    child: CustomPaint(painter: _BarrasPainter(cor)),
  );
}

class _BarrasPainter extends CustomPainter {
  const _BarrasPainter(this.cor);

  final Color cor;

  static const _larguras = [2.0, 1.0, 3.0, 1.0, 2.0, 1.0, 1.0, 3.0, 2.0, 1.0, 3.0, 1.0, 2.0];

  @override
  void paint(Canvas canvas, Size size) {
    final tinta = Paint()..color = cor;
    var x = 0.0;
    var indice = 0;
    while (x < size.width) {
      final largura = _larguras[indice % _larguras.length];
      canvas.drawRect(Rect.fromLTWH(x, 0, largura, size.height), tinta);
      x += largura + (indice.isEven ? 2 : 1.5);
      indice++;
    }
  }

  @override
  bool shouldRepaint(_BarrasPainter oldDelegate) => oldDelegate.cor != cor;
}
