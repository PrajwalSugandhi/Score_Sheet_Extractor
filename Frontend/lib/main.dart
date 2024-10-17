import 'package:btp/helper/dialog.dart';
import 'package:btp/screen/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      ProviderScope(
        child: MaterialApp(
          // scaffoldMessengerKey: Messenger.scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          home: const AuthenticationScreen(),
        ),
      )
  );
}



