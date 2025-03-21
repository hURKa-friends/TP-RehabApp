import 'package:flutter/material.dart';
import 'gyro_view.dart';
import 'accl_view.dart';
import 'lux_view.dart';
import 'mag_view.dart';

enum Graphs { gyro, accl, mag, lux }

class GraphView extends StatefulWidget {
  //const GraphView({super.key});
  final Graphs graphs = Graphs.gyro;

  const GraphView({super.key});


  @override
  State<StatefulWidget> createState() => _GraphViewState();
}


class _GraphViewState extends State<GraphView> {
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
  Widget build(BuildContext context) {
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
