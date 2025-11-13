import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import providers
import 'providers/chat_provider.dart';
import 'providers/transaction_provider.dart';

// Import screens
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        home: const DashboardScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}