import 'package:flutter/material.dart';
import 'dart:convert';
import '../navigation.dart';

class BoosterPage extends StatelessWidget {
  final List<dynamic> responseBody;

  const BoosterPage({Key? key, required this.responseBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Response'),
          automaticallyImplyLeading: false,
          leading: null),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Response Data:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                responseBody.isNotEmpty
                    ? jsonEncode(responseBody)
                    : 'No data available. ${responseBody}',
                style: TextStyle(fontSize: 16),
              ),
              FloatingActionButton.extended(
                label: Text("Retour à l'Accueil"),
                icon: Icon(Icons.stars),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationBarPage(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}