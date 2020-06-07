import 'package:first/app/home/home_page.dart';
import 'package:first/app/sign_in/sign_in_page.dart';
import 'package:first/services/auth.dart';
import 'package:first/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBase = Provider.of<AuthBase>(context, listen: false);
     return StreamBuilder<User>(
      stream: authBase.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User _user = snapshot.data;
          if (_user == null)
            return SignInPage.create(context);
          return Provider<User>.value(
            value: _user,
            child: Provider<Database>(
                create: (_) => FirestoreDatabase(uid: _user.uid),
                child: HomePage()),
          );
        }else
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(backgroundColor: Colors.transparent,),
            ),
          );
      },
    );
  }
}
