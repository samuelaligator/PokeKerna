import 'package:flutter/material.dart';
import 'package:pokekerna/navigation.dart';
import '../requests.dart'; // Importing fetchWithHeaders function

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _numberController1 = TextEditingController();
  final _numberController2 = TextEditingController();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _numberController1.dispose();
    _numberController2.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _handleForm1Submit() async {
    if (_formKey1.currentState!.validate()) {
      String url = 'https://code.pokekerna.xyz/admin/verify?user_id=${_numberController1.text}';
      try {
        Map<String, dynamic> response = await fetchWithHeaders(url);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response[0]} - Utilisateur ${response[1]} validé')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _handleForm2Submit() async {
    if (_formKey2.currentState!.validate()) {
      String url =
          'https://code.pokekerna.xyz/admin/code?card_id=${_numberController2.text}&code=${_textController.text}';
      try {
        Map<String, dynamic> response = await fetchWithHeaders(url);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response[0]}, Code ${response[2]} - Carte ${response[1]}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin God Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded),
                SizedBox(width: 4),
                Text('Valider un utilisateur', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
              ],
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _numberController1,
                          decoration: const InputDecoration(
                            labelText: 'ID Utilisateur',
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius. circular(16.0))),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Merci d'entrer un identifiant !";
                            }
                            if (int.tryParse(value) == null) {
                              return "C'est pas un chiffre ça.";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton.extended(
                        onPressed: _handleForm1Submit,
                        label: const Text('Envoyer'),
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_rounded),
                SizedBox(width: 4),
                Text('Créer un code', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
              ],
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'Code',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius. circular(16.0))),

                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "T'as oublier le code chef";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _numberController2,
                          decoration: const InputDecoration(
                            labelText: 'ID Carte',
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius. circular(16.0))),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "T'as aussi oublié la carte";
                            }
                            if (int.tryParse(value) == null) {
                              return 'ID invalide';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton.extended(
                        onPressed: _handleForm2Submit,
                        label: const Text('Envoyer'),
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //const SizedBox(height: 32),
            //FloatingActionButton.extended(
            //  onPressed: () => Navigator.push(
            //    context,
            //    MaterialPageRoute(
            //      builder: (context) => NavigationBarPage(),
            //    ),
            //  ),
            //  label: const Text("Retour à l'accueil"),
            //  icon: const Icon(Icons.home),
            //  backgroundColor: Colors.amber[200],
            //),
          ],
        ),
      ),
    );
  }
}