import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── Helpers de transição ──────────────────────────────────────────────────────

/// Fade suave — splash, login, home.
Page<void> fadePage(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      name: state.name,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, anim, secondaryAnim, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        child: child,
      ),
    );

/// Slide da direita para a esquerda — wizard steps, scanner.
Page<void> slideRightPage(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      name: state.name,
      child: child,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, anim, secondaryAnim, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)).animate(anim),
        child: child,
      ),
    );

/// Slide de baixo para cima — telas de detalhe/modal.
Page<void> slideBottomPage(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      name: state.name,
      child: child,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, anim, secondaryAnim, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)).animate(anim),
        child: child,
      ),
    );
