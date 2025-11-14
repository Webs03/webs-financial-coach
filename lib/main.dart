import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import providers - UPDATE THIS IMPORT
import 'providers/auth_service.dart'; // Changed from auth_provider.dart
import 'providers/chat_provider.dart';
import 'providers/transaction_provider.dart';

// Import screens
import 'screens/dashboard_screen.dart';
import 'screens/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDH2CT0TFM5txYwLhJ5A2FsFMFKZR5FAYE",
      authDomain: "webs-financial-coach-ffd36.firebaseapp.com",
      projectId: "webs-financial-coach-ffd36",
      storageBucket: "webs-financial-coach-ffd36.firebasestorage.app",
      messagingSenderId: "608691305074",
      appId: "1:608691305074:web:8244a30ed6d6efd99de0eb",
    ),
  );

  try {
    final auth = FirebaseAuth.instance;
    print('🔥 Firebase Auth initialized: ${auth.app.name}');
  } catch (e) {
    print('❌ Firebase Auth initialization failed: $e');
  }

  try {
    await dotenv.load(fileName: ".env");
    print('✅ Environment loaded successfully');
  } catch (e) {
    print('❌ Error loading environment: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // UPDATE THIS PROVIDER
        ChangeNotifierProvider<AuthService>( // Changed from AuthProvider
          create: (context) => AuthService(), // Changed from AuthProvider
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider<TransactionProvider>(
          create: (context) => TransactionProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Webs Financial Coach',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    // UPDATE THIS REFERENCE
    final authService = Provider.of<AuthService>(context); // Changed from AuthProvider

    print('🔄 AuthWrapper - User: ${authService.user?.email}, Loading: ${authService.isLoading}');

    if (authService.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Setting up your account...'),
            ],
          ),
        ),
      );
    }

    if (authService.user != null) {
      print('✅ Navigating to Dashboard for user: ${authService.user!.email}');
      return const DashboardScreen();
    } else {
      print('❌ No user, showing SignInScreen');
      return const SignInScreen();
    }
  }
}