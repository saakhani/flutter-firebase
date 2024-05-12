import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_assignment/screens/create_screen.dart';
import 'package:firebase_assignment/screens/sign_in_screen.dart';
import 'package:firebase_assignment/utils/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  void signOutButton() async {
    setState(() {
      _isSigningOut = true;
    });
    await Authentication.signOut(context: context);
    setState(() {
      _isSigningOut = false;
    });
    Navigator.of(context).pushReplacement(_routeToSignInScreen());
  }

  void _onItemTapped(int index) {
    if (index == 1){
       Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CreatePage(),
        ),
      );
    }
    else if (index == 2) {
      signOutButton();
    }
  }

  String _getTime(Timestamp uploadTime) {
    print(uploadTime);
    DateTime now = DateTime.now();
    DateTime uploadedDateTime = uploadTime.toDate();

    Duration difference = now.difference(uploadedDateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ${difference.inSeconds == 1 ? 'second' : 'seconds'} ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else {
      int months = difference.inDays ~/ 30;
      return '${months} ${months == 1 ? 'month' : 'months'} ago';
    }
  }

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

  final Stream<QuerySnapshot> _resourcesStream =
      FirebaseFirestore.instance.collection('resources').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        title: Text(
          "Home",
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
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
                          TextSpan(
                              text: _user.displayName!,
                              style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                    Text(
                      "Start exploring resources",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Color.fromARGB(255, 133, 133, 133),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(46), // Set the border radius here
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Latest Uploads ⚡",
                        style: GoogleFonts.roboto(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _resourcesStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Loading");
                          }
                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                color: Color.fromARGB(238, 253, 253, 253),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              ClipOval(
                                                child: Image.network(
                                                  data['profile']!,
                                                  width: 30,
                                                ),
                                              ),
                                            
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(data['uploaderName'],
                                              style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 133, 133, 133),
                                              )),
                                              ],
                                          ),
                                          Column(
                                            children: [
                                              Text(_getTime(data['created']),
                                              style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 133, 133, 133),
                                              )),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        data['title'],
                                        style: GoogleFonts.roboto(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        data['description'],
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                              255, 133, 133, 133),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        currentIndex: 0,
        iconSize: 40,
        selectedFontSize: 18,
        unselectedFontSize: 18,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Sign Out',
          ),
        ],
        selectedItemColor: Colors.redAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
