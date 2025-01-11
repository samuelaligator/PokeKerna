import 'package:flutter/material.dart';
import 'dart:async';
import '../requests.dart';
import 'card.dart';

class CollectionPage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                      childAspectRatio: 0.735,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      final imageUrl = card[6];

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
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.contain, // Adjust fit as required
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}