import 'package:firebase_assignment/screens/sign_in_screen.dart';
import 'package:firebase_assignment/utils/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _user;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        title: Text("Home", style: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 20
                    ),
                    color: Color.fromARGB(255, 240, 240, 240),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.roboto(
                              fontSize: 30,
                              color: Color.fromARGB(255, 133, 133, 133),
                              fontWeight: FontWeight.w800,
                            ),
                            children: <TextSpan>[
                              const TextSpan(text: 'Hey '),
                              TextSpan(text: _user.displayName!, style: TextStyle(color: Color.fromARGB(255, 255, 203, 120))),
                            ],
                          ),
                        ),
                        Text("Start exploring resources", style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Color.fromARGB(255, 133, 133, 133),
                          fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            decoration: const InputDecoration(
                            labelText: 'Search',
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                )
              ],
            ),
            _user.photoURL != null
                ? ClipOval(
                    child: Material(
                      child: Image.network(
                        _user.photoURL!,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  )
                : ClipOval(
                    child: Material(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.person,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 16.0),
            Text(
              'Hello',
              style: TextStyle(
                fontSize: 26,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              _user.displayName!,
              style: TextStyle(
                fontSize: 26,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '( ${_user.email!} )',
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'You are now signed in using your Google account. To sign out of your account click the "Sign Out" button below.',
              style: TextStyle(fontSize: 14, letterSpacing: 0.2),
            ),
            SizedBox(height: 16.0),
            _isSigningOut
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.redAccent,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await Authentication.signOut(context: context);
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.of(context)
                          .pushReplacement(_routeToSignInScreen());
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
