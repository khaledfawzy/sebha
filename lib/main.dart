import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;


// Entry point of the app
void main() {
  runApp(const SebhaApp());
}

// Main app widget with routing
class SebhaApp extends StatelessWidget {
  const SebhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'شاشة التسبيحات'
      ,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/sebha': (context) => const SebhaScreen(),
      },
    );
  }
}

// Splash screen widget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToSebhaScreen();
  }

  // Navigate to SebhaScreen after a delay
  Future<void> _navigateToSebhaScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacementNamed('/sebha');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/splash@3x.png'), // Update with your splash image
      ),
    );
  }
}

// Main screen widget
class SebhaScreen extends StatefulWidget {
  const SebhaScreen({super.key});

  @override
  SebhaScreenState createState() => SebhaScreenState();
}

class SebhaScreenState extends State<SebhaScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  int _clickCount = 0;
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
// Increase the round count
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
        // Center the title in the AppBar
        title: const Center(
          child: Text('تسبيحات'),
        ),
        elevation: 0, // Optional: Removes shadow below the AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
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
              ],
            ),
            const SizedBox(height: 150),
            const Text(
              'عدد التسبيحات',
              style: TextStyle(
                fontFamily: 'arabicfonts', // Use the custom font family
                fontSize: 24,
                 fontWeight: FontWeight.w600,
              ),
            ),
            Text(' $_clickCount',
            style:Theme.of(context).textTheme.headlineMedium,),

           /*  Text(
              'Rounds: $_roundCount',
              style: Theme.of(context).textTheme.headlineSmall,
            ), */
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onButtonClick,
              child: const Text('سبحان الله',
              style:TextStyle(fontFamily: 'arabicfonts',
              fontWeight: FontWeight.w600,)),
            ),
          ],
        ),
      ),
    );
  }
}
