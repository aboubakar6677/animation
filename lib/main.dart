import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Professional Portfolio',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F5FF),
          secondary: Color(0xFF6A11CB),
          surface: Color(0xFF1E1E2E),
        ),
        textTheme: const TextTheme(
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: TextStyle(fontSize: 20, color: Color(0xFFA5A5BA)),
        ),
      ),
      home: const ProfessionalPortfolioScreen(),
    );
  }
}

class ProfessionalPortfolioScreen extends HookConsumerWidget {
  const ProfessionalPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Main animation controller
    final mainController = useAnimationController(
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    final bgController = useAnimationController(
      duration: const Duration(seconds: 3),
    )..repeat();

    final textController = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );

    useEffect(() {
      textController.forward();
      return null;
    }, []);

    final cardRotation = Tween<double>(begin: -0.02, end: 0.02).animate(
      CurvedAnimation(parent: mainController, curve: Curves.easeInOutSine),
    );

    final cardScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.98, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.98), weight: 50),
    ]).animate(mainController);

    final cardGradient = ColorTween(
      begin: theme.colorScheme.secondary,
      end: theme.colorScheme.primary,
    ).animate(mainController);

    final borderWidth = Tween<double>(begin: 1, end: 3).animate(mainController);

    
    final bgGradientRotation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(parent: bgController, curve: Curves.linear));

    final textSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: textController, curve: Curves.easeOutCubic),
    );

    final textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Animated background gradient
          AnimatedBuilder(
            animation: bgController,
            builder: (context, child) {
              return Transform.rotate(
                angle: bgGradientRotation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.5,
                      colors: [
                        theme.colorScheme.primary.withAlpha(40),
                        theme.colorScheme.secondary.withAlpha(50),
                        Colors.transparent,
                      ],
                      stops: const [0.1, 0.5, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          ..._buildFloatingElements(size, mainController),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: mainController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: cardRotation.value,
                      child: Transform.scale(
                        scale: cardScale.value,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                cardGradient.value!,
                                cardGradient.value!.withAlpha(140),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.white.withAlpha(150),
                              width: borderWidth.value,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: cardGradient.value!.withAlpha(70),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.white, Color(0xFFA5A5BA)],
                              ).createShader(bounds),
                              child: const Text(
                                'AB',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                AnimatedBuilder(
                  animation: textController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, textSlide.value),
                      child: Opacity(
                        opacity: textFade.value,
                        child: Text(
                          'Abou Bakar',
                          style: theme.textTheme.displayMedium?.copyWith(
                            shadows: [
                              Shadow(
                                color: theme.colorScheme.primary.withAlpha(70),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // AnimatedBuilder(
                //   animation: textController,
                //   builder: (context, child) {
                //     return Transform.translate(
                //       offset: Offset(0, textSlide.value),
                //       child: Opacity(
                //         opacity: textFade.value * 0.9,
                //         child: Text(
                //           'Senior Flutter Developer',
                //           style: theme.textTheme.titleLarge?.copyWith(
                //             color: const Color(0xFFA5A5BA),
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // ),
                AnimatedText(),
                const SizedBox(height: 40),

                _buildAnimatedStats(mainController, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStats(AnimationController controller, ThemeData theme) {
    final statScale = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    final statColor = ColorTween(
      begin: theme.colorScheme.primary,
      end: theme.colorScheme.secondary,
    ).animate(controller);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Transform.scale(
              scale: statScale.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: statColor.value?.withAlpha(50),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statColor.value!.withAlpha(100),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '2+',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: statColor.value,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Years Exp',
                      style: TextStyle(fontSize: 14, color: Color(0xFFA5A5BA)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 20),
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Transform.scale(
              scale: statScale.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: statColor.value?.withAlpha(50),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statColor.value!.withAlpha(100),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '20+',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: statColor.value,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Projects',
                      style: TextStyle(fontSize: 14, color: Color(0xFFA5A5BA)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildFloatingElements(
    Size size,
    AnimationController controller,
  ) {
    final particle1 =
        Tween<Offset>(
          begin: const Offset(-0.2, -0.1),
          end: const Offset(0.2, 0.1),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.5, curve: Curves.easeInOutSine),
          ),
        );

    final particle2 =
        Tween<Offset>(
          begin: const Offset(0.1, -0.2),
          end: const Offset(-0.1, 0.2),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.3, 0.8, curve: Curves.easeInOutSine),
          ),
        );

    return [
      Positioned(
        right: size.width * 0.15,
        top: size.height * 0.25,
        child: AnimatedBuilder(
          animation: particle1,
          builder: (context, child) {
            return Transform.translate(
              offset: particle1.value * 80,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [const Color(0xFF6A11CB), Colors.transparent],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      Positioned(
        left: size.width * 0.2,
        bottom: size.height * 0.3,
        child: AnimatedBuilder(
          animation: particle2,
          builder: (context, child) {
            return Transform.translate(
              offset: particle2.value * 100,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00F5FF).withAlpha(140),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      // Small decorative dots
      Positioned(
        right: size.width * 0.3,
        top: size.height * 0.4,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withAlpha(50),
          ),
        ),
      ),
      Positioned(
        left: size.width * 0.35,
        bottom: size.height * 0.35,
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withAlpha(50),
          ),
        ),
      ),
    ];
  }
}

class AnimatedText extends HookWidget {
  const AnimatedText({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    final translateY = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    final opacity = Tween<double>(begin: 0.7, end: 1).animate(controller);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, translateY.value),
          child: Opacity(
            opacity: opacity.value,
            child: const Text(
              'Flutter Developer',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 10, color: Colors.purpleAccent)],
              ),
            ),
          ),
        );
      },
    );
  }
}
