import 'package:flutter/material.dart';
import 'dart:math' as math;

class SebhaScreen extends StatefulWidget {
  const SebhaScreen({super.key});

  @override
  SebhaScreenState createState() => SebhaScreenState();
}

class SebhaScreenState extends State<SebhaScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  int _clickCount = 0;
  int _roundCount = 0;
  final int _beadCount = 33;
  final double _radius = 100.0;
  double _rotation = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi / _beadCount,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onButtonClick() {
    setState(() {
      _clickCount++;
      _rotation += 2 * math.pi / _beadCount;

      if (_clickCount % _beadCount == 0) {
        _clickCount = 0; // Reset the counter
        _roundCount++;  // Increase the round count
      }

      _controller.forward(from: 0).whenComplete(() {
        _controller.reset();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sebha App'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Beads with isolated AnimatedBuilder
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: List.generate(_beadCount, (index) {
                    final double angle = (index / _beadCount) * 2 * math.pi;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationZ(_rotation + _rotationAnimation.value),
                      child: Transform.translate(
                        offset: Offset(
                          _radius * math.cos(angle),
                          _radius * math.sin(angle),
                        ),
                        child: Image.asset('assets/images/sebha.png', width: 20, height: 20),
                      ),
                    );
                  }),
                );
              },
            ),
            // Guide Image
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationZ(_rotation + _rotationAnimation.value),
              child: Image.asset('assets/images/head_sebha_logo.png', width: 30, height: 30),
            ),
            // Counter and Rounds Overlay
            Positioned(
              bottom: 120,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Counter: $_clickCount',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Rounds: $_roundCount',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            // Click Button
            Positioned(
              bottom: 20,
              child: ElevatedButton(
                onPressed: _onButtonClick,
                child: const Text('Click Me'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
