import 'package:flutter/material.dart';
import 'package:rehab_app/services/page_management/models/base_page_model.dart';
import 'package:rehab_app/services/page_management/models/tutorial_step_model.dart';
import 'package:rehab_app/services/page_management/views/sub_menu_wrapper.dart';
import 'package:rehab_app/views/example_view.dart';
import 'package:rehab_app/views/graph_view.dart';
import 'package:rehab_app/views/FMS_phone_pickup_view.dart';

///
/// import your MVVM views here
///
import 'package:rehab_app/views/settings_view.dart';

import '../views/Beerpour_view.dart';

class MenuViewModel extends ChangeNotifier {
  final List<BasePage> _pages = [

    ///
    /// You can add your pages here
    ///
    GraphView(icon: Icons.data_thresholding_outlined, title: "Sensor graph example"),
    SubMenuPageWrapper(icon: Icons.account_tree_outlined, title: "Submenu example",
      subPages: [
        SubMenuPageWrapper(icon: Icons.menu, title: "SubSubmenu example",
          subPages: [
            ExampleView(icon: Icons.extension_outlined, title: "Example 1"),
            ExampleView(icon: Icons.looks_two_outlined, title: "Example 2"),
            ExampleView(icon: Icons.looks_3_outlined, title: "Example 3"),
            ExampleView(icon: Icons.looks_4_outlined, title: "Example 4"),
            ExampleView(icon: Icons.looks_5_outlined, title: "Example 5"),
            ExampleView(icon: Icons.looks_6_outlined, title: "Example 6"),
            ExampleView(icon: Icons.seven_k_outlined, title: "Example 7"),
            ExampleView(icon: Icons.eight_k_outlined, title: "Example 8"),
            ExampleView(icon: Icons.nine_k_outlined, title: "Example 9"),
          ],
        ),
        ExampleView(icon: Icons.looks_one_outlined, title: "Example 1"),
        ExampleView(icon: Icons.looks_two_outlined, title: "Example 2"),
        ExampleView(icon: Icons.looks_3_outlined, title: "Example 3"),
      ],
    ),
    ExampleView(icon: Icons.checklist_rtl_outlined, title: "Tutorial Wrapper example",
      tutorialSteps: [
        TutorialStep(
          assetURI: 'assets/example/000_exercise.gif',
          heading: '1. Krok',
          description: 'Tu je veľmi trefný a krátky popis toho čo chcete od používateľa, aby robil. '
                       'Ak by bol text dlhší než určitý rozsah, automaticky sa stane "scrollovateľným" '
                       'tak aby bol čitateľný a nevyšiel preč z obrazovky, ani neovplyvnil umiestnenie '
                       'ostatných UI prvkov.',
        ),
        TutorialStep(
          assetURI: 'assets/example/001_exercise.gif',
          heading: '2. Krok',
          description: 'Medzi krokmi tutoriálu sa dá voľne navigovať dopredu, dozadu.',
        ),
        TutorialStep(
          assetURI: 'assets/example/FEI_logo.gif',
          heading: '3. Krok',
          description: 'Zobraziť sa dá čokoľvek (.gif, .jpg, .png) a aj v lepšej kvalite.',
        ),
        TutorialStep(
          assetURI: 'assets/example/002_exercise.gif',
          heading: 'Potvrdenie',
          description: 'Posledný krok obsahuje tlačidlo potvrdenia, ktorým sa ukončí tutoriál a '
                       'zobrazí sa pôvodne otvorená stránka.',
        ),
      ],
    ),
    SettingsView(icon: Icons.settings, title: "Settings"),
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
  ];

  // Getters
  List<BasePage> get pages => _pages;
}