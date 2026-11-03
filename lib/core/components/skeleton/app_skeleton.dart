import 'package:expogeo/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppSkeleton extends StatefulWidget {
  const AppSkeleton({super.key, this.width, this.height, this.radius});

  final double? width;
  final double? height;

  /// Sem valor, usa o raio pequeno do tema.
  final double? radius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppTheme.dimensions.components.skeletonShimmer,
  );
  late final CurvedAnimation _progress = CurvedAnimation(parent: _controller, curve: Curves.ease);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final animate = !MediaQuery.disableAnimationsOf(context);

    return ExcludeSemantics(
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius ?? AppTheme.dimensions.radii.r8),
          child: CustomPaint(
            painter: animate
                ? _ShimmerPainter(
                    progress: _progress,
                    base: colors.skeletonBase,
                    highlight: colors.skeletonHighlight,
                  )
                : null,
            child: Container(
              width: widget.width,
              height: widget.height,
              color: animate ? null : colors.skeletonBase,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  _ShimmerPainter({required this.progress, required this.base, required this.highlight})
    : super(repaint: progress);

  final Animation<double> progress;
  final Color base;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      colors: [base, highlight, base],
      stops: const [0.25, 0.37, 0.63],
      transform: _SlidingGradient(progress.value),
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(_ShimmerPainter oldDelegate) =>
      oldDelegate.base != base || oldDelegate.highlight != highlight;
}

// O degradê tem quatro vezes a largura do bloco e desliza até encostar nele, então a faixa clara
// cruza o bloco uma vez por ciclo e as pontas ficam na cor base.
class _SlidingGradient extends GradientTransform {
  const _SlidingGradient(this.progress);

  final double progress;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final offset = -3 * bounds.width * (1 - progress);
    return Matrix4.translationValues(bounds.left + offset, 0, 0)
      ..multiply(Matrix4.diagonal3Values(4, 1, 1))
      ..multiply(Matrix4.translationValues(-bounds.left, 0, 0));
  }
}
