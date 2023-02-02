import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/app.dart';

class ProfilDeleteView extends StatefulWidget {
  const ProfilDeleteView({Key? key}) : super(key: key);

  @override
  State<ProfilDeleteView> createState() => _ProfilDeleteViewState();
}

class _ProfilDeleteViewState extends State<ProfilDeleteView> {
  @override
  void initState() {
    checkProfileDeleteRequest();
    super.initState();
  }

  checkProfileDeleteRequest() async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('ProfileDelete', true);

    final bool? repeat = prefs.getBool('profileDelete');

    print(repeat);

    if (repeat == null || repeat == false) {
      await prefs.setBool('profileDelete', true);
    } else {
      setState(() {
        App.isDeleteRequested = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: App.isDeleteRequested
          ? Text(
              "Account Deletion in process",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )
          : Text(
              """“Sad to see you go!
Your account has been sent for deletion. We would send you a deletion confirmation via SMS soon”.""",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
    );
  }
}
