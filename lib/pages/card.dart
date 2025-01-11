import 'package:flutter/material.dart';

class CardDetailPage extends StatelessWidget {
  final dynamic card;

  CardDetailPage({required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  card[6], // Card image
                  width: 300, // Enlarge image
                  height: 450, // Enlarge image
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name: ${card[1]}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Type: ${card[2]}'),
            SizedBox(height: 10),
            Text('Description: ${card[7]}'), // Example of additional data
            // Add more data here if needed
          ],
        ),
      ),
    );
  }
}