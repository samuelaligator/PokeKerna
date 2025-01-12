import 'package:flutter/material.dart';
import 'package:pokekerna/navigation.dart';
import 'package:pokekerna/pages/home.dart';

class BoosterPage extends StatefulWidget {
  final List<dynamic> responseBody;

  const BoosterPage({Key? key, required this.responseBody}) : super(key: key);

  @override
  State<BoosterPage> createState() => _BoosterPageState();
}

class _BoosterPageState extends State<BoosterPage> with TickerProviderStateMixin {
  late AnimationController _boosterController;
  late AnimationController _cardController;
  late Animation<double> _boosterScaleAnimation;
  late Animation<double> _cardScaleAnimation;
  bool _isOpened = false;

  @override
  void initState() {
    super.initState();

    // Booster image animation controller
    _boosterController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _boosterScaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _boosterController, curve: Curves.easeInOut),
    );

    // Card image animation controller
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _cardScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _boosterController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (!_isOpened) {
      setState(() {
        _isOpened = true;
      });
      // Start the booster image animation
      _boosterController.forward().whenComplete(() {
        // Once the booster image animation completes, start the card image animation
        _cardController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booster Opening'),
        automaticallyImplyLeading: false,
        leading: null,
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _boosterController,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Booster image animation (scale down)
                if (_boosterScaleAnimation.value > 0)
                  GestureDetector(
                    onTap: _startAnimation,
                    child: Transform.scale(
                      scale: _boosterScaleAnimation.value,
                      child: Image.asset(
                        'assets/images/booster.png', // Local pouch image
                        width: 500,
                        height: 600,
                      ),
                    ),
                  ),
                // Card image animation (scale from 0 to normal size)
                if (_boosterScaleAnimation.value == 0)
                  AnimatedBuilder(
                    animation: _cardController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardScaleAnimation.value, // Scale up animation for card image
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              widget.responseBody[0][6], // Card image URL
                              width: 300,
                              height: 420,
                              fit: BoxFit.cover,
                            ),
                            // Add button when the card image is fully visible
                            if (_cardScaleAnimation.value == 1)
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: FloatingActionButton.extended(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NavigationBarPage(),
                                      )),
                                  label: Text("Retour à l'accueil"),
                                  icon: Icon(Icons.home),
                                  backgroundColor: Colors.amber[200],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
