import 'package:firebase_auth/firebase_auth.dart';
import 'package:ramo/models/userData.dart';
import 'package:ramo/services/authService.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ramo/services/databaseService.dart';

class HomePageStateful extends StatefulWidget {
  const HomePageStateful({
    Key key,
  }) : super(key: key);

  @override
  _HomePageStateful createState() => _HomePageStateful();
}

class _HomePageStateful extends State<HomePageStateful> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User>();
    return MultiProvider(
      providers: [
        // Provider<DatabaseService>(
        //     create: (_) =>
        //         DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)),
        StreamProvider<UserData>.value(
            value: DatabaseService(uid: firebaseuser.uid).userData)
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Name(),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(children: [
            ElevatedButton(
              onPressed: () {
                context.read<AuthService>().signOut();
              },
              child: Text("Sign Out"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<DatabaseService>().test('PAPA');
              },
              child: Text("Sign wew"),
            ),
            _widgetOptions.elementAt(_selectedIndex)
          ]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class Name extends StatelessWidget {
  const Name({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserData>();
    return userData != null
        ? Text(
            // 'Jacob',
            userData.name,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          )
        : Text(
            'Jacob',
            //userData.name,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
  }
}
