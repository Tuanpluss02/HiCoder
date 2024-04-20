import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hicoder/utils/constants.dart';
import 'package:hicoder/utils/providers.dart';
import 'package:hicoder/view_models/theme/theme_view_model.dart';
import 'package:provider/provider.dart';

import 'auth/login/login.dart';
import 'screens/mainscreen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(
  //     LifecycleEventHandler(
  //       detachedCallBack: () => UserService().setUserStatus(false),
  //       resumeCallBack: () => UserService().setUserStatus(true),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, Widget? child) {
          return MaterialApp(
            title: Constants.appName,
            debugShowCheckedModeBanner: false,
            theme: themeData(
              notifier.dark ? Constants.darkTheme : Constants.lightTheme,
            ),
            // home: const MoreInfo(),
            home: FutureBuilder(
              future: AuthService().isLoggedIn(),
              builder: ((BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return const TabScreen();
                  } else {
                    return const Login();
                  }
                } else {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }),
            ),
          );
        },
      ),
    );
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(
        theme.textTheme,
      ),
    );
  }
}
