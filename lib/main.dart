import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/main/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/change_password_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/contact/add_contact_screen.dart';
import 'screens/contact/contacts_screen.dart';
import 'screens/account/add_account_screen.dart';
import 'screens/account/account_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    runApp(MyApp(isLoggedIn: isLoggedIn ?? false));
  } catch (e) {
    print("Error during initialization: $e");
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rekeningku App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? HomeScreen(selectedIndex: 0) : LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/change-password': (context) => ChangePasswordScreen(),
        '/profile': (context) => HomeScreen(selectedIndex: 1),
        '/contacts': (context) => HomeScreen(selectedIndex: 0),
        '/add-contact': (context) => AddContactScreen(),
        '/add-account': (context) =>
            AddAccountScreen(contactId: '', contactName: ''),
        '/account-list': (context) =>
            AccountListScreen(contactId: '', contactName: ''),
      },
    );
  }
}
