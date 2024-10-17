import 'dart:ui';
import 'package:btp/screen/admin.dart';
import 'package:btp/screen/common_details_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.auth}) : super(key: key);
  final FirebaseAuth auth;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> _photoUrlFuture;
  bool isAdmin = false;

  void checkIfAdmin() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      IdTokenResult idTokenResult = await user.getIdTokenResult(true);
      if (idTokenResult.claims != null &&
          idTokenResult.claims!['admin'] == true) {
        isAdmin = true;
        // print("True hone tha $isAdmin");
        setState(() {
          isAdmin = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfAdmin();
    _photoUrlFuture = _getUserPhotoUrl();
  }

  @override
  Widget build(BuildContext context) {
    // print(isAdmin);
    return FutureBuilder<String?>(
      future: _photoUrlFuture,
      builder: (context, snapshot) {
        Widget leadingWidget;
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          leadingWidget = CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data!),
          );
        } else {
          leadingWidget = Image.asset(
            'assets/images/avatar.png',
            color: null, // No color change to the existing avatar icon
          ); // Placeholder widget
        }

        return Container(
          child: Scaffold(
            // backgroundColor: Color(0xff131621),
            // Set the desired background color
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // elevation: 2,
              shadowColor: Colors.black12,
              backgroundColor: const Color(0xff091254),
              leadingWidth: 40,
              // leading: Container(), // Remove the existing leading
              actions: [
                // SizedBox(width: 10), // Add some spacing
                leadingWidget, // Display the user's profile photo
                const SizedBox(width: 10), // Add some spacing
              ],
            ),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              // color: Colors.blue,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.black, Color.fromARGB(255, 0, 20, 153)],
                  radius: 1.5,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Center(
                        child: _buildCard(
                            context: context,
                            path: 'assets/images/excel.jpg',
                            cardData: 'Create New Excel Sheet',
                            Page: DetailsPage())),
                    const SizedBox(
                      height: 30,
                    ),
                    if (isAdmin)
                      Center(
                          child: _buildCard(
                              context: context,
                              path: 'assets/images/adminlogo.png',
                              cardData: 'Access Admin Controls',
                              Page: Admin())),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(
      {required BuildContext context,
      required String path,
      required String cardData,
      required var Page}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Page),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height *
            0.25, // Height set to 25% of screen height
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ), // Applying blur effect
            child: Container(
              decoration: BoxDecoration(
                color:
                    Colors.grey.withOpacity(0.3), // Greyish tint with opacity
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    path,
                    // fit: BoxFit.cover, // Ensure the image covers the container
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        cardData,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _getUserPhotoUrl() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.photoURL;
    }
    return null;
  }
}
