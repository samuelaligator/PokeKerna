import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../cache.dart';

class CardDetailPage extends StatelessWidget {
  final dynamic card;

  CardDetailPage({required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🃏 Carte ${card["name"]}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: card["image_link"],
                  cacheManager: CustomCacheManager.instance,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.contain,
                  width: 300,
                  height: 450,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Image.asset(
                  'assets/icones/${card["energy"]}.png',
                  height: 38,
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Card title
                      Text(
                        card["name"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),

                      // Card alt (if available)
                      if (card["alt"] != null)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 6.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            card["alt"],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                        ),

                      // Card number (if greater than 1)
                      if (card["num"] > 1)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade200,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            "×" + card["num"].toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // Rarity text
                    Text(
                      (() {
                        switch (card["rarity"]) {
                          case 0:
                            return "Commun";
                          case 1:
                            return "Rare";
                          case 2:
                            return "Epic";
                          case 3:
                            return "Légendaire";
                          case 4:
                            return "Mythique";
                          case 5:
                            return "Secret";
                          default:
                            return "Unknown";
                        }
                      })(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    // Right section: Card rarity icon
                    Image.asset(
                      'assets/images/${card["rarity"]}.png', // Replace with your icon URL
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            RichText(
              textHeightBehavior: TextHeightBehavior(
                applyHeightToFirstAscent:
                    false, // Prevent extra spacing on the first line
              ),
              text: TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.format_quote_rounded, size: 24),
                    ),
                  ),
                  TextSpan(
                    text: card["lore"],
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Outfit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
