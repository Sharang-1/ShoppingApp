import 'package:flutter/material.dart';

import '../../controllers/appointments_controller.dart';
import '../shared/app_colors.dart';

class AppointmentBookedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppointmentsController.appointmentBooked();
    return Scaffold(
      backgroundColor: backgroundWhiteCreamColor,
      body: Center(
        child: Container(
          child: FittedBox(
            child: Image.asset("assets/images/loading.gif", height: 900),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
