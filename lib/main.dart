import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramo/pages/signinpage.dart';
import 'package:ramo/services/authService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ramo/services/databaseService.dart';
import 'package:ramo/services/routerService.dart';
import 'package:ramo/pages/homepage.dart';
import 'package:ramo/models/userData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ramo/pages/onboarding/onboarding.dart';

int onBoardScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  onBoardScreen = await _prefs.getInt('onBoardScreen');
  await _prefs.setInt('onBoardScreen', 1);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        // Provider<DatabaseService>(
        //     create: (_) =>
        //         DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges),
        // FirebaseAuth.instance.currentUser != null
        //     ? StreamProvider<UserData>.value(
        //         value:
        //             DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
        //                 .userData)
        //     : StreamProvider<UserData>.value(value: DatabaseService().userData)
      ],
      child: MaterialApp(
        onGenerateRoute: RouteGenerator.generateRoute,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //home: AuthenticationWrapper(),
        initialRoute:
            onBoardScreen == 0 || onBoardScreen == null ? 'Onboarding' : 'home',
        routes: {
          'Onboarding': (context) => Onboarding(),
          'home': (context) => AuthenticationWrapper()
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final firebaseuser = context.watch<UserData>();
    // // final userData = context.watch<UserData>();

    // if (firebaseuser != null) {
    //   print(firebaseuser.uid + " has signed in. Proceeding to home");
    //   return HomePageStateful();
    // } else {
    //   print("No user is currently logged in. Proceeding to sign in page");
    //   return SignInPage();
    // }
    return StreamBuilder(
      stream: context.watch<AuthService>().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return Center(child: CircularProgressIndicator());
        }
        final user = snapshot.data;
        if (user != null) {
          print(user.uid + " has signed in. Proceeding to home");
          return HomePageStateful();
        } else {
          print("No user is currently logged in. Proceeding to sign in page");
          return SignInPage();
        }
      },
    );
  }
}
