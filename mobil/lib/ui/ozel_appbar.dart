import 'package:flutter/material.dart';

class OzelAppBar extends StatelessWidget implements PreferredSizeWidget {

  final bool geriGelsinMi;

  @override
  final Size preferredSize; // default is 56.0

  OzelAppBar({this.geriGelsinMi, Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0),
      leading: geriGelsinMi == true
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              })
          : null,
      title: CircleAvatar(
        backgroundColor: Color(0),
        child: Image.asset('assets/images/Logo.png'),
      ),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      /* actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                if ((await GoogleSignIn().isSignedIn())) {
                  await GoogleSignIn().signOut();
                  await GoogleSignIn().disconnect();
                }
                await FirebaseAuth.instance.signOut();
              },
            ),
          ], */
    );
  }
}
