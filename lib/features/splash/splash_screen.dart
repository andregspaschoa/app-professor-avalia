import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Camada 2 da splash — animada (Flutter).
///
/// Camada 1 é a native splash gerada por flutter_native_splash
/// (fundo sólido #0D0D2B que aparece antes do Flutter carregar).
///
/// A transição é contínua: mesmo fundo + logo que faz fade-in + scale.
/// Ao final da animação, navega para '/login'.
///
/// TODO(nav): substituir Navigator.pushReplacementNamed por
/// context.go('/login') quando go_router for configurado na feature 1.2.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  // Cor idêntica ao flutter_native_splash para transição imperceptível.
  static const Color _splashBackground = Color(0xFF0D0D2B);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Logo aparece gradualmente (0% → 60% da animação).
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
      ),
    );

    // Leve crescimento para dar sensação de "surgindo" (0% → 80%).
    _scaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await _controller.forward();
    // Pausa breve para o usuário absorver o logo antes de navegar.
    await Future.delayed(const Duration(milliseconds: 300));
    _navigateNext();
  }

  void _navigateNext() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Força barra de status com ícones claros sobre o fundo escuro.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _splashBackground,
      ),
      child: Scaffold(
        backgroundColor: _splashBackground,
        body: Stack(
          children: [
            // Logo centralizado na tela.
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  'assets/splash/logo.png',
                  width: 240,
                  height: 240,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),

            // Indicador de carregamento no rodapé.
            Positioned(
              bottom: 56,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: child,
                  );
                },
                child: const _LoadingIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Indicador de carregamento exibido no rodapé da splash.
///
/// Separado em widget próprio para não ser reconstruído a cada
/// frame da animação (é passado como `child` do AnimatedBuilder).
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Inicializando...',
          style: TextStyle(
            color: Colors.white.withAlpha(140),
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
