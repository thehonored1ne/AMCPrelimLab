import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/chat/presentation/screens/chat_screen.dart';
import 'features/chat/data/models/chat_message_model.dart';
import 'features/chat/data/models/persona_model.dart';
import 'features/chat/domain/providers/chat_provider.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(PersonaAdapter());

  runApp(const ProviderScope(child: PersonaChatApp()));
}

class PersonaChatApp extends ConsumerWidget {
  const PersonaChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatStateAsync = ref.watch(chatNotifierProvider);

    return chatStateAsync.when(
      data: (data) => MaterialApp(
        title: 'PersonaChat',
        debugShowCheckedModeBanner: false,
        themeMode: data.themeMode,
        theme: AppTheme.getTheme(data.activePersona.themeColor),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: data.activePersona.themeColor,
            brightness: Brightness.dark,
          ),
        ),
        home: const ChatScreen(),
      ),
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (e, st) => MaterialApp(
        home: Scaffold(body: Center(child: Text("Error: $e"))),
      ),
    );
  }
}
