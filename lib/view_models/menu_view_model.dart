import 'package:flutter/material.dart';
import 'package:rehab_app/services/page_management/models/base_page_model.dart';
import 'package:rehab_app/services/page_management/models/tutorial_step_model.dart';
import 'package:rehab_app/services/page_management/views/sub_menu_wrapper.dart';
import 'package:rehab_app/views/graph_view.dart';

/// Eating rehab - Klaudia
import 'package:rehab_app/views/klaudia/data_acquisition_view.dart';

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
    SettingsView(icon: Icons.settings, title: "Settings"),
  ];

  // Getters
  List<BasePage> get pages => _pages;
}
