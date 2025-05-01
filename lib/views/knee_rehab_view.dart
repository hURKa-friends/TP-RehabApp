import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';
import 'package:rehab_app/views/accl_view.dart';
import 'package:rehab_app/views/gyro_view.dart';
import '../view_models/accl_viewmodel.dart';
import '../view_models/gyro_viewmodel.dart';
import '../view_models/knee_rehab_view_model.dart';

class KneeRehabView extends StatefulPage {
  const KneeRehabView({
    super.key,
    required super.icon,
    required super.title,
    super.tutorialSteps // Optional
  });

  @override
  void initPage(BuildContext context) {
    // Here you can call page initialization code or reference ViewModel initialization like this:
    var kneeRehabViewModel = Provider.of<KneeRehabViewModel>(context, listen: false); /// IMPORTANT listen must be false
    kneeRehabViewModel.onInit();
  }

  @override
  void closePage(BuildContext context) {
    // Here you can call page closing code or reference ViewModel disposal like this:
    var kneeRehabViewModel = Provider.of<KneeRehabViewModel>(context, listen: false); /// IMPORTANT listen must be false
    kneeRehabViewModel.onClose();
  }

  @override
  KneeRehabViewState createState() => KneeRehabViewState();
}

class KneeRehabViewState extends StatefulPageState {

  @override
  Widget buildPage(BuildContext context) {
    var viewModel = context.watch<KneeRehabViewModel>();

    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            child: Column(
                children: [
                    Padding(padding: const EdgeInsets.symmetric(vertical: 8),
                        child: DropdownButton<String>(
                            value: viewModel.name,
                            hint: const Text("Vyber nohu"),
                            isExpanded: true,
                            items: const [
                                DropdownMenuItem(value: "Pravá noha", child: Text("Pravá noha")),
                                DropdownMenuItem(value: "Ľavá noha", child: Text("Ľavá noha"))
                            ],
                            onChanged: (value) {setState(() {viewModel.name = value!;});}),
                    ),
                    Column(
                        children: [
                            Text("X-Axis (${viewModel.acclData.isNotEmpty ? viewModel.acclData.last.x.toStringAsFixed(2) : '0'})"),
                            Text("Y-Axis (${viewModel.acclData.isNotEmpty ? viewModel.acclData.last.y.toStringAsFixed(2) : '0'})"),
                            Text("Z-Axis (${viewModel.acclData.isNotEmpty ? viewModel.acclData.last.z.toStringAsFixed(2) : '0'})"),
                        ],
                    ),
                    Column(
                        children: [
                            Text("X-Axis (${viewModel.gyroData.isNotEmpty ? viewModel.gyroData.last.x.toStringAsFixed(2) : '0'})"),
                            Text("Y-Axis (${viewModel.gyroData.isNotEmpty ? viewModel.gyroData.last.y.toStringAsFixed(2) : '0'})"),
                            Text("Z-Axis (${viewModel.gyroData.isNotEmpty ? viewModel.gyroData.last.z.toStringAsFixed(2) : '0'})"),
                        ],
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Column(
                        children: [
                          if (viewModel.name != null)
                            Text("blabla")
                        ],
                      ),
                    )
                ],
            ),
        ),
    );
    }
}