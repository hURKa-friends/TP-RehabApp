import 'package:flutter/material.dart';
import 'package:rehab_app/services/page_management/models/base_page_model.dart';
import 'package:rehab_app/services/page_management/models/tutorial_step_model.dart';
import 'package:rehab_app/services/page_management/views/sub_menu_wrapper.dart';
import 'package:rehab_app/views/exercise_feedback_view.dart.';
import 'package:rehab_app/views/graph_view.dart';
import 'package:rehab_app/views/settings_view.dart';
import 'package:rehab_app/rehabilitacia/view_models_rehab/rehab_exercise_view.dart';
import 'dart:async';
import 'package:rehab_app/util/countdown_dialog.dart';

import 'package:rehab_app/rehabilitacia/services/exercise_logic_service.dart.';


///
/// import your MVVM views here
///
import 'package:rehab_app/views/settings_view.dart';

class MenuViewModel extends ChangeNotifier {
  // Private Fields & Parameters
  final List<BasePage> _pages = [
    ///
    /// You can add your pages here
    ///
    GraphView(icon: Icons.data_thresholding_outlined, title: "Sensor graph example"),
    SubMenuPageWrapper(icon: Icons.account_tree_outlined, title: "Submenu example",
      subPages: [
        SubMenuPageWrapper(icon: Icons.menu, title: "SubSubmenu example",
          subPages: [
            ExerciseFeedbackView(icon: Icons.extension_outlined, title: "Example 1"),
            ExerciseFeedbackView(icon: Icons.looks_two_outlined, title: "Example 2"),
            ExerciseFeedbackView(icon: Icons.looks_3_outlined, title: "Example 3"),
            ExerciseFeedbackView(icon: Icons.looks_4_outlined, title: "Example 4"),
            ExerciseFeedbackView(icon: Icons.looks_5_outlined, title: "Example 5"),
            ExerciseFeedbackView(icon: Icons.looks_6_outlined, title: "Example 6"),
            ExerciseFeedbackView(icon: Icons.seven_k_outlined, title: "Example 7"),
            ExerciseFeedbackView(icon: Icons.eight_k_outlined, title: "Example 8"),
            ExerciseFeedbackView(icon: Icons.nine_k_outlined, title: "Example 9"),
          ],
        ),
        ExerciseFeedbackView(icon: Icons.looks_one_outlined, title: "Example 1"),
        ExerciseFeedbackView(icon: Icons.looks_two_outlined, title: "Example 2"),
        ExerciseFeedbackView(icon: Icons.looks_3_outlined, title: "Example 3"),
      ],
    ),
    

    SubMenuPageWrapper(
        icon: 	Icons.fitness_center, // alebo Icons.fitness_center
        title: "Rehabilitation Exercise Tutorial",
        subPages: [
          ExerciseFeedbackView(icon: Icons.checklist_rtl_outlined, title: "Tutorial Wrapper example",
      tutorialSteps: [
        TutorialStep(
          assetURI: 'assets/example/000_exercise.gif',
          heading: '1. Step',
          description: 'Tu je veľmi trefný a krátky popis toho čo chcete od používateľa, aby robil.',
        ),
        TutorialStep(
          assetURI: 'assets/example/001_exercise.gif',
          heading: '2. Step',
          description: 'Medzi krokmi tutoriálu sa dá voľne navigovať dopredu, dozadu.',
        ),
        TutorialStep(
          assetURI: 'assets/example/FEI_logo.gif',
          heading: '3. Step',
          description: 'Zobraziť sa dá čokoľvek (.gif, .jpg, .png) a aj v lepšej kvalite.',
        ),
        TutorialStep(
          assetURI: 'assets/example/002_exercise.gif',
          heading: 'Potvrdenie',
          description: 'Posledný krok obsahuje tlačidlo potvrdenia, ktorým sa ukončí tutoriál a zobrazí sa pôvodne otvorená stránka.',
        ),
      ],
    ),

          ///////////////////////////////////////

          ////Moja cast aplikacie//////////////

          //  Tutoriál – Stávanie zo stoličky
          ExerciseFeedbackView(
            icon: Icons.chair_alt_outlined,
            title: "Getting up from a chair",
            tutorialSteps: [
              TutorialStep(
                assetURI: 'assets/example/char1.png',
                heading: '1. Step – Sit down',
                description: 'Sit on a chair with your hands on your thighs.',
              ),
              TutorialStep(
                assetURI: 'assets/example/char2.png',
                heading: '2. Step – Get ready',
                description: 'Lean forward slightly and prepare to stand.',
              ),
              TutorialStep(
                assetURI: 'assets/example/char3.png',
                heading: '3. Step – Stand up',
                description: 'Stand up slowly without using your hands.',
              ),
              TutorialStep(
                assetURI: 'assets/example/save.png',
                heading: 'Save the workout!',
                description: 'After exercising, the system will start recording movement data.',
                hasConfirmButton: true,
                onConfirm: (context) async {
                  int localCountdown = 5;

                  // Countdown pred spustením cvičenia
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          Timer.periodic(const Duration(seconds: 1), (timer) {
                            if (localCountdown <= 1) {
                              timer.cancel();
                              Navigator.of(context).pop();
                            } else {
                              setState(() {
                                localCountdown--;
                              });
                            }
                          });

                          return AlertDialog(
                            title: const Text('Priprav sa na cvičenie'),
                            content: Text('Začína sa za \$countdown sekúnd...'),
                          );
                        },
                      );
                    },
                  );

                  // Po countdown spusti cvičenie
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RehabExerciseView(
                        title: "Getting up from a chair",
                        exerciseType: "chair",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),





          //  Tutoriál – Vstávanie z postele
          ExerciseFeedbackView(
      icon: Icons.bed_outlined,
      title: "Getting out of bed",
      tutorialSteps: [
        TutorialStep(
          assetURI: 'assets/example/bed1.jpg',
          heading: '1.Step - Lie down.',
          description: 'Lie down and bend your knees.',
        ),
        TutorialStep(
          assetURI: 'assets/example/bed2.jpg',
          heading: '2.Step - Turn around',
          description: 'Turn onto your side and prepare to stand up.',
        ),
        TutorialStep(
          assetURI: 'assets/example/bed3.jpg',
          heading: '3.Step - Lower your legs',
          description: 'Put your feet up off the bed and lean back.',
        ),
        TutorialStep(
          assetURI: 'assets/example/bed4.jpg',
          heading: '4.Step - Sit down ',
          description: 'Sit down on the bed.',
        ),
        TutorialStep(
          assetURI: 'assets/example/save.png',
          heading: 'Save the workout!',
          description: 'After exercising, you save your exercise data',
        ),
      ],
    ),

    //  Tutoriál – Vykonavanie drepu
          ExerciseFeedbackView(
      icon: Icons.accessibility_new,
      title: "Performing a squat",
      tutorialSteps: [
        TutorialStep(
          assetURI: 'assets/example/drep1.png',
          heading: '1.Step - Stand up',
          description: 'Stand straight, with your hands in front of you.',
        ),
        TutorialStep(
          assetURI: 'assets/example/drep2.png',
          heading: '2.Step - Perform a squat',
          description: 'Perform a squat with your hands in front of your body and hold the position for 5 seconds',
        ),
        TutorialStep(
          assetURI: 'assets/example/drep1.png',
          heading: '3.Step - Stand up',
          description: 'Return to the starting position.',
        ),
        TutorialStep(
          assetURI: 'assets/example/save.png',
          heading: 'Save the workout!',
          description: 'After exercising, you save your exercise data',
        ),
      ],
    ),
        ],
    ),

    SettingsView(icon: Icons.settings, title: "Settings"),
  ];

  // Getters
  List<BasePage> get pages => _pages;
}