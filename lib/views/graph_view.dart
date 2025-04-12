import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehab_app/services/page_management/models/stateful_page_model.dart';
import 'package:rehab_app/views/gyro_view.dart';
import 'package:rehab_app/views/accl_view.dart';
import 'package:rehab_app/views/lux_view.dart';
import 'package:rehab_app/views/mag_view.dart';
import 'package:rehab_app/view_models/gyro_viewmodel.dart';
import 'package:rehab_app/view_models/accl_viewmodel.dart';
import 'package:rehab_app/view_models/lux_viewmodel.dart';
import 'package:rehab_app/view_models/mag_viewmodel.dart';

enum Graphs { gyro, accl, mag, lux }

class GraphView extends StatefulPage {
  final Graphs graphs = Graphs.gyro;

  const GraphView({
    super.key,
    required super.icon,
    required super.title
  });

  @override
  void initPage(BuildContext context) {
    var gyroViewModel = Provider.of<GyroViewModel>(context, listen: false);
    var acclViewModel = Provider.of<AcclViewModel>(context, listen: false);
    var magViewModel = Provider.of<MagViewModel>(context, listen: false);
    var luxViewModel = Provider.of<LuxViewModel>(context, listen: false);
    gyroViewModel.registerSensorService();
    acclViewModel.registerSensorService();
    magViewModel.registerSensorService();
    luxViewModel.registerSensorService();
  }

  @override
  void closePage(BuildContext context) {
    var gyroViewModel = Provider.of<GyroViewModel>(context, listen: false);
    var acclViewModel = Provider.of<AcclViewModel>(context, listen: false);
    var magViewModel = Provider.of<MagViewModel>(context, listen: false);
    var luxViewModel = Provider.of<LuxViewModel>(context, listen: false);
    gyroViewModel.onClose();
    acclViewModel.onClose();
    magViewModel.onClose();
    luxViewModel.onClose();
  }

  @override
  GraphViewState createState() => GraphViewState();
}

class GraphViewState extends StatefulPageState {
  Set<Graphs> _selected = {Graphs.gyro};
  Widget _body = GyroView();

  void updateSelected(Set<Graphs> newSelection) {
    setState(() {
      _selected = newSelection;
      if (_selected.first == Graphs.gyro) {

        _body = GyroView();
      } else if (_selected.first == Graphs.accl) {
        _body = AcclView();
      } else if (_selected.first == Graphs.mag) {
        _body = MagView();
      } else if (_selected.first == Graphs.lux) {
        _body = LuxView();
      }
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SegmentedButton(
              segments: const <ButtonSegment<Graphs>>[
                ButtonSegment<Graphs>(
                  value: Graphs.gyro,
                  label: Text('Gyro'),
                ),
                ButtonSegment<Graphs>(
                  value: Graphs.accl,
                  label: Text('Accl'),
                ),
                ButtonSegment<Graphs>(
                  value: Graphs.mag,
                  label: Text('Mag'),
                ),
                ButtonSegment<Graphs>(
                  value: Graphs.lux,
                  label: Text('Lux'),
                ),
              ],
              selected: _selected,
              onSelectionChanged: updateSelected,
            ),
            _body,
          ],
        ),
      ),
    );
  }
}
