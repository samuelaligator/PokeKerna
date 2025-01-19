import 'package:flutter/material.dart';
import '../navigation.dart';
import '../cache.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BoosterPage extends StatefulWidget {
  final Map<String, dynamic> responseBody;

  const BoosterPage({Key? key, required this.responseBody}) : super(key: key);

  @override
  State<BoosterPage> createState() => _BoosterPageState();
}

class _BoosterPageState extends State<BoosterPage> with TickerProviderStateMixin {
  late AnimationController _boosterController;
  late AnimationController _cardController;
  late Animation<double> _boosterScaleAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  bool _isOpened = false;

  Color getBackgroundColor(int rarity) {
    switch (rarity) {
      case 0:
        return Colors.grey.shade400;  // Common
      case 1:
        return Colors.lightBlue.shade200;  // Rare
      case 2:
        return Colors.red.shade200;  // Epic
      case 3:
        return Colors.yellow.shade200;  // Legendary
      case 4:
        return Colors.green.shade200;  // Mythic
      case 5:
        return Colors.purple.shade200;  // Secret
      default:
        return Colors.white;  // Default for unknown rarity
    }
  }

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

    // Background color animation controller, now tied to the card animation
    _backgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: getBackgroundColor(widget.responseBody["rarity"]),
    ).animate(
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
      body: AnimatedBuilder(
        animation: _backgroundColorAnimation,
        builder: (context, child) {
          return Container(
            color: _backgroundColorAnimation.value,  // Dynamically update background color
            child: Center(
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
                                  CachedNetworkImage(
                                    cacheManager: CustomCacheManager.instance,
                                    imageUrl: widget.responseBody["image_link"],
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    width: 300,
                                    height: 420,
                                    fit: BoxFit.cover,
                                  ),
                                  // Add button when the card image is fully visible
                                  if (_cardScaleAnimation.value == 1)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(widget.responseBody["name"], style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                                              if (widget.responseBody["alt"] != "")
                                                Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 6.0),
                                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.indigo,
                                                    borderRadius: BorderRadius.circular(4.0),
                                                  ),
                                                  child: Text(
                                                    widget.responseBody["alt"],
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12.0),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/${widget.responseBody["rarity"]}.png', // Replace with your icon URL
                                                width: 24,
                                                height: 24,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                (() {
                                                  switch (widget.responseBody["rarity"]) {
                                                    case 0: return "Commun";
                                                    case 1: return "Rare";
                                                    case 2: return "Epic";
                                                    case 3: return "Légendaire";
                                                    case 4: return "Mythique";
                                                    case 5: return "Secret";
                                                    default: return "Unknown";
                                                  }
                                                })(),
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          FloatingActionButton.extended(
                                            onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => NavigationBarPage(),
                                              ),
                                            ),
                                            label: Text("Retour à l'accueil"),
                                            icon: Icon(Icons.home),
                                            backgroundColor: Colors.amber[200],
                                          ),
                                        ],
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
        },
      ),
    );
  }
}
