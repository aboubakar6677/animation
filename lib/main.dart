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
      title: 'Flutter Animation',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const MultiAnimationScreen(),
    );
  }
}

class MultiAnimationScreen extends HookConsumerWidget {
  const MultiAnimationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainController = useAnimationController(
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    final bgController = useAnimationController(
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    final rotation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(parent: mainController, curve: Curves.easeInOut));

    final scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 50),
    ]).animate(mainController);

    Tween<double>(begin: 0.9, end: 1).animate(mainController);

    final color = ColorTween(
      begin: Colors.blueAccent,
      end: Colors.purpleAccent,
    ).animate(mainController);

    Tween<double>(begin: 8, end: 24).animate(mainController);

    final borderWidth = Tween<double>(begin: 2, end: 6).animate(mainController);

    final gradientRotation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(bgController);

    final particleOffset1 = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.2, 0.1),
    ).animate(CurvedAnimation(parent: mainController, curve: Curves.easeInOut));

    final particleOffset2 = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.15, 0.2),
    ).animate(CurvedAnimation(parent: mainController, curve: Curves.easeInOut));

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: bgController,
            builder: (context, child) {
              return Transform.rotate(
                angle: gradientRotation.value,
                child: Container(
                  // width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: SweepGradient(
                      colors: [
                        Colors.purple.withAlpha(90),
                        Colors.blue.withAlpha(80),
                        Colors.teal.withAlpha(90),
                        Colors.purple.withAlpha(90),
                      ],
                      stops: const [0.0, 0.4, 0.8, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          Positioned(
            right: 100,
            top: 100,
            child: AnimatedBuilder(
              animation: particleOffset1,
              builder: (context, child) {
                return Transform.rotate(
                  angle: gradientRotation.value,
                  child: Transform.translate(
                    offset: particleOffset1.value * 50,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(60),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            left: 100,
            bottom: 100,
            child: AnimatedBuilder(
              animation: particleOffset2,
              builder: (context, child) {
                return Transform.translate(
                  offset: particleOffset2.value * 50,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent.withAlpha(70),
                    ),
                  ),
                );
              },
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: bgController,

                  builder: (context, child) {
                    return Transform.rotate(
                      angle: gradientRotation.value,

                      child: AnimatedBuilder(
                        animation: mainController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: rotation.value,
                            child: Transform.scale(
                              scale: scale.value,
                              child: Container(
                                alignment: Alignment.center,
                                width: 200,
                                height: 200,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color.value,
                                  // borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: borderWidth.value,
                                  ),
                                ),
                                child: ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [Colors.red, Colors.white],
                                      ).createShader(bounds),
                                  child: const Text(
                                    'Abou Bakar',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                AnimatedText(),

                const SizedBox(height: 30),

                AnimatedButton(controller: mainController),
              ],
            ),
          ),
        ],
      ),
    );
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

class AnimatedButton extends HookWidget {
  final AnimationController controller;

  const AnimatedButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final buttonScale = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    final buttonColor = ColorTween(
      begin: Colors.green,
      end: Colors.amber,
    ).animate(controller);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: buttonScale.value,
          child: Material(
            borderRadius: BorderRadius.circular(30),
            elevation: 8,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(30),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      buttonColor.value!,
                      buttonColor.value!.withAlpha(140),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Text(
                  '2+ Years Experience',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
