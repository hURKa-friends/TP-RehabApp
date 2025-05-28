import 'package:flutter/material.dart';
import 'package:rehab_app/zuzka/view_models_rehab/rehab_exercise_view.dart';

class RehabMenuView extends StatelessWidget {
  const RehabMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rehabilitačné Cvičenia")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Stávanie zo stoličky"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RehabExerciseView(
                    title: "Stávanie zo stoličky",
                    exerciseType: "chair",
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Stávanie z postele"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RehabExerciseView(
                    title: "Stávanie z postele",
                    exerciseType: "bed",
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Viazanie šnúrok"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RehabExerciseView(
                    title: "Viazanie šnúrok",
                    exerciseType: "shoelaces",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
