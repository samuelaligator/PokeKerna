import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../requests.dart';
import '../cache.dart';
import 'card.dart';

class CollectionPage extends StatefulWidget {
  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  int? _number;

  @override
  void initState() {
    super.initState();
    _fetchNumber();
  }

  Future<List<dynamic>> getAllCards(context) async {
    try {
      final response = await fetchWithHeaders("https://code.pokekerna.xyz/v1/selfcards");
      return response;
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.orange[300],
        ),
      );
      throw Exception("Da error");
    }
  }

  Future<void> _fetchNumber() async {
    try {
      final response =
      await fetchWithHeaders("https://code.pokekerna.xyz/v1/allcards");
      setState(() {
        _number = response[0];
      });
    } catch (e) {
      throw Exception("Error fetching cards");
    }
    throw Exception("Da super error");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FutureBuilder<List<dynamic>>(
        future: getAllCards(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cards found'));
          } else {
            // Extract image URLs and card details
            final List<dynamic> cards = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '🃏 Toute mes cartes', // Title text
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.725,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      final imageUrl = card["image_link"];
                      final numberOfCards = card["num"];

                      return GestureDetector(
                        onTap: () {
                          // Navigate to the card detail page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CardDetailPage(card: card),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  cacheManager: CustomCacheManager.instance,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.contain, // Adjust fit as required
                                ),
                              ),
                            ),
                            if (numberOfCards > 1)
                              Positioned(
                                bottom: 8.0,
                                right: 8.0,
                                child: Container(
                                  padding: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    numberOfCards.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Center(
                   child:
                      Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Flex(
                        direction: Axis.horizontal, // Can also be Axis.vertical
                        mainAxisSize: MainAxisSize.min, // Prevents taking all space
                        children: [
                          Icon(Icons.stars_rounded),
                          Text(
                          '${cards.length}/${_number}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                        ],
                      ),

                    )
                ),
                SizedBox(height: 8,)
              ],
            );
          }
        },
      ),
    );
  }
}
