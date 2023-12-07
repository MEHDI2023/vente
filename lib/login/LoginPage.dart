import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vente/lendingPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isError = false;
  bool _isLoading = false; // Indicateur de chargement
  final _formKey = GlobalKey<FormState>(); // Clé du formulaire

  Future<void> _showCreateAccountDialog() async {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Clé du formulaire

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Créer un compte'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey, // Utilisation de la clé du formulaire
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un e-mail';
                      }
                      if (!value.contains('@')) {
                        return 'Veuillez entrer un e-mail valide';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un mot de passe';
                      }
                      if (value.length < 6) {
                        return 'Veuillez entrer un mot de passe de 6 caractères minimum';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String email = emailController.text;
                        String password = passwordController.text;

                        try {
                          // Affichage de l'indicateur de chargement
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Création du compte en cours...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          UserCredential userCredential =
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          print('Utilisateur créé : ${userCredential.user!.uid}');
                          Navigator.of(context).pop(); // Fermer la boîte de dialogue
                        } catch (e) {
                          // Gestion des erreurs lors de la création du compte
                          print('Erreur de création de compte : $e');
                          String errorMessage =
                              'Erreur de création de compte. Veuillez réessayer.';
                          if (e is FirebaseAuthException) {
                            // Personnalisation des messages d'erreur FirebaseAuth
                            switch (e.code) {
                              case 'weak-password':
                                errorMessage =
                                'Le mot de passe est trop faible. Essayez avec un mot de passe plus fort.';
                                break;
                              case 'email-already-in-use':
                                errorMessage =
                                'Cet e-mail est déjà utilisé par un autre compte.';
                                break;
                            // Ajoutez d'autres cas selon les erreurs FirebaseAuth
                              default:
                                errorMessage =
                                'Erreur de création de compte. Veuillez réessayer.';
                                break;
                            }
                          }
                          // Affichage du message d'erreur à l'utilisateur
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              duration: Duration(seconds: 4),
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Créer'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Future<void> _resetPassword() async {
    String email = _emailController.text;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Un e-mail de réinitialisation a été envoyé à $email'),
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      print('Erreur de réinitialisation du mot de passe : $e');
      String errorMessage = 'Erreur de réinitialisation du mot de passe. Veuillez réessayer.';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Adresse e-mail invalide.';
            break;
          case 'user-not-found':
            errorMessage = 'Aucun utilisateur trouvé avec cette adresse e-mail.';
            break;
          default:
            errorMessage = 'Erreur de réinitialisation du mot de passe. Veuillez réessayer.';
            break;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _createAccount() async {
    // Méthode pour créer un compte
    await _showCreateAccountDialog(); // Affiche la boîte de dialogue de création de compte
    // Attend que l'utilisateur valide ou annule la création de compte
  }

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LendingPage()),
      );
    } catch (e) {
      print('Erreur de connexion : $e');
      setState(() {
        _isError = true;
      });
      String errorMessage = 'Une erreur s\'est produite. Veuillez réessayer.';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Adresse e-mail invalide.';
            break;
          case 'user-disabled':
            errorMessage = 'Ce compte utilisateur a été désactivé.';
            break;
          case 'user-not-found':
            errorMessage = 'Utilisateur non trouvé. Veuillez vous inscrire.';
            break;
          case 'wrong-password':
            errorMessage = 'Mot de passe incorrect.';
            break;
          default:
            errorMessage = 'Erreur de connexion. Veuillez réessayer.';
            break;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(
                          "https://th.bing.com/th/id/OIG.THf0Pz_odTCG4H2IUgf0?pid=ImgGn "),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Connectez-vous',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _login,
                      child:
                          _isLoading
                              ? CircularProgressIndicator()
                              : Text('Se connecter'),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _resetPassword,
                      child: Text('Mot de passe oublié'),
                    ),

                    SizedBox(height: 10.0),
                    if (_isError)
                      Text(
                        'E-mail ou mot de passe incorrect',
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 10.0),
                    // Bouton pour créer un compte
                    TextButton(
                      onPressed: () {
                        _createAccount(); // Appelle la méthode pour créer un compte
                      },
                      child: const Text('Créer un compte'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
