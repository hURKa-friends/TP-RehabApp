import 'package:flutter/material.dart';
import 'package:rehab_app/models/pose_detection/pose_detection_model.dart';
import 'package:rehab_app/services/page_management/models/base_page_model.dart';
import 'package:rehab_app/services/page_management/models/tutorial_step_model.dart';
import 'package:rehab_app/services/page_management/views/sub_menu_wrapper.dart';
import 'package:rehab_app/custom_icon.dart';
import 'package:rehab_app/views/graph_view.dart';

/// Eating rehab - Klaudia
import 'package:rehab_app/views/klaudia/data_acquisition_view.dart';

/// Pose detection - Filip
import 'package:rehab_app/views/pose_detection/pose_detection_view.dart';

/// Fine motor skills - Denis
import 'package:rehab_app/views/denis/FMS_phone_pickup_view.dart';
import 'package:rehab_app/views/denis/Beerpour_view.dart';

/// Knee rehab - Angelika
import 'package:rehab_app/views/kneeRehab_view.dart';

///
/// import your MVVM views here
///
import 'package:rehab_app/views/settings_view.dart';

class MenuViewModel extends ChangeNotifier {
  final List<BasePage> _pages = [
    ///
    /// You can add your pages here
    ///
    GraphView(icon: Icons.data_thresholding_outlined, title: "Sensor graph example"),
    /// Eating rehab
    SubMenuPageWrapper(
      icon: Icons.fastfood,
      title: "Eating rehab",
      subPages: [
        AcqView(
          icon: Icons.checklist_rtl_outlined,
          title: "Meranie aktivity",
          tutorialSteps: [
            TutorialStep(
              assetURI: 'assets/eating_rehab/eating.png',
              heading: 'Info',
              description: 'Táto aplikácia slúži na detekciu otrasov,'
                          ' nárazov a meranie aktivity počas jedenia.',
            ),
            TutorialStep(
              assetURI: 'assets/eating_rehab/secure_phone.png',
              heading: '1. Krok',
              description: 'Pripevnite si Váš smartphone na zápästie '
                          'ruky, ktorou budete jesť. ',
            ),
            TutorialStep(
              assetURI: 'assets/eating_rehab/start.png',
              heading: '2. Krok',
              description: 'Stlačte Štart a položte ruku na stôl '
                          'meranie sa spustí po 3 sekundách.',
            ),
            TutorialStep(
              assetURI: 'assets/eating_rehab/eat_spoon.png',
              heading: '3. Krok',
              description: 'Začnite jesť.',
            ),
            TutorialStep(
              assetURI: 'assets/eating_rehab/stop.png',
              heading: '4. Krok',
              description: 'Stlačte tlačidlo Stop na zastavenie merania.',
            ),
            TutorialStep(
              assetURI: 'assets/eating_rehab/ok.png',
              heading: 'Potvrdenie',
              description: 'Potvrďte porozumenie. ',
            ),
          ],
        )
      ],
    ),
    /// Pose detection
    SubMenuPageWrapper(icon: Icons.accessibility_new, title: "Detekcia pózy",
      subPages: [
        SubMenuPageWrapper(icon: Icons.menu, title: "Rehabilitácia ramena",
          subPages: [
            PoseDetectionView(icon: Icons.accessibility_new, title: "Cvik ramena - Upaženie",
              exerciseType: ExerciseType.shoulderAbductionActive,
              tutorialSteps: [
                TutorialStep(
                  assetURI: 'assets/pose_detection/shoulder_abduction_active.jpg',
                  heading: 'Upaženie',
                  description: 'Zdvihnite vystretú ruku bokom do horizontálnej polohy. Počas celého cviku sa snažte mať vystretú ruku s dlaňou smerujúcou nadol. Opakovanie sa ráta ako úspešné len s riadne vystretou rukou. Cvik vykonávajte pomaly.',
                ),
              ],
            ),
            PoseDetectionView(icon: Icons.accessibility_new, title: "Cvik ramena - Vzpaženie",
              exerciseType: ExerciseType.shoulderForwardElevationActive,
              tutorialSteps: [
                TutorialStep(
                  assetURI: 'assets/pose_detection/shoulder_forward_elevation_active.jpg',
                  heading: 'Vzpaženie',
                  description: 'Pomaly zdvíhajte vystretú ruku pred seba a následne pokračujte až smerom ku stropu, kým vaša ruka nie je rovnobežná s vaším telom..',
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    /// Fine motor skills
    BeerPourPage(icon: Icons.local_drink, title: "Beer pour",
      tutorialSteps: [
        TutorialStep(
          assetURI: 'assets/example/FMV/beer1.png',
          heading: '1. Krok',
          description: 'Pred Vami sa zobrazí pohár piva. Po zmagnutí start sa začne odpočítavanie. Po 3 sekundách začne cvičenie.',
        ),
        TutorialStep(
          assetURI: 'assets/example/FMV/beer2.png',
          heading: '2. Krok',
          description: 'Vašou úlohou je pomaly a plynulo preliať toto virtuálne pivo do reálneho pohára. Tento bod je dôležitý aby sa vedeli zaznamenať prípadné nárazy na hranu.',
        ),
        TutorialStep(
          assetURI: 'assets/example/FMV/beer3.png',
          heading: '3. Krok',
          description: 'Cvičenie môžete vykonávať ohýbaním v zápästí alebo...',
        ),
        TutorialStep(
          assetURI: 'assets/example/FMV/beer4.png',
          heading: 'Potvrdenie',
          description: '...ohýbaním v predloktí.',
        ),
      ],
    ),
    MotionDetectionView(icon: Icons.front_hand, title: "Nácvik jemnej motoriky",
      tutorialSteps: [
        TutorialStep(
          assetURI: 'assets/example/FMV/fmv1.png',
          heading: '1. Krok',
          description: 'Najprv si vyberiete aký úchyt mobilu zvolíte. Sú na výber 4.',
        ),
        TutorialStep(
          assetURI: 'assets/example/FMV/fmv2.png',
          heading: '2. Krok',
          description: 'Následne určíte ktorou rukou idete cvičenie vykonávať.',
        ),
        TutorialStep(
          assetURI: 'assets/example/FMV/fmv3.png',
          heading: '3. Krok',
          description: 'Pred vami sa zobrazí obrazovka s tlačídlom zapnúť senzory. Po jeho kliknutí sa začne časomiera 5 sekúnd na položenie mobilu do šálky obrátene.',
        ),
        TutorialStep(
            assetURI: 'assets/example/FMV/fmv4.png',
            heading: '4. Krok',
            description: 'Cvičenie sa začne v momente keď uplynie 5 sekúnd a vy sa dotknete panelu pre dotyk s obrazovkou.'
        ),
        TutorialStep(
            assetURI: 'assets/example/FMV/fmv5.png',
            heading: '5. Krok',
            description: 'Teraz presuniete zariadenie do iného hrnčeka, pomalým a plynulým pohybom a jemne položíte. Cvičenie sa skončí po uvoľnení displaya.'
        ),
      ],
    ),
    /// Knee Rehab
    KneeRehabMainView(
      icon: CustomIcons.knee_pain_icon,
      title: "Knee Rehabilitation",
      tutorialSteps: [
        TutorialStep(
            assetURI: "assets/knee_rehab/leg_extensions01.jpg",
            heading: "Step 1",
            description: "Sit upright on a chair or bench with your back straight and feet flat on the floor."),
        TutorialStep(
            assetURI: "assets/knee_rehab/leg_extensions02.jpg",
            heading: "Step 2",
            description:
                "Tighten your thigh muscles and slowly extend the selected leg upward as high as you comfortably can."),
        TutorialStep(
            assetURI: "assets/knee_rehab/leg_extensions03.jpg",
            heading: "Step 3",
            description:
                "Hold the leg fully extended and keep your thigh muscles engaged for 3 seconds. Then relax, lower your foot back to the floor, and rest for 3 seconds. Repeat this 10 times."),
        TutorialStep(
            assetURI: "assets/knee_rehab/something.png",
            heading: "Important!",
            description:
                "Avoid swinging your leg or using forceful movements. Try to lift and lower your leg in a straight line, using slow and controlled motion both ways."),
      ],
    ),
    /// Settings
    SettingsView(icon: Icons.settings, title: "Settings"),
  ];

  // Getters
  List<BasePage> get pages => _pages;
}
