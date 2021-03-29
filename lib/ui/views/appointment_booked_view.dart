import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../../viewmodels/appointments_view_model.dart';
import '../shared/app_colors.dart';
import '../widgets/circular_progress_indicator.dart';

class AppointmentBookedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AppointmentsViewModel>.withConsumer(
      viewModel: AppointmentsViewModel(),
      onModelReady: (model) => model.appointmentBooked(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        body: Center(child: CircularProgressIndicatorWidget()),
      ),
    );
  }
}
