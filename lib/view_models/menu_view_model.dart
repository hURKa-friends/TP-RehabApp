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
    SubMenuPageWrapper(icon: Icons.account_tree_outlined, title: "FMS",
      subPages: [
        SubMenuPageWrapper(icon: Icons.pan_tool, title: "Left hand",
          subPages: [
            MotionDetectionView(icon: Icons.touch_app, title: "FMS",
              tutorialSteps: [
                TutorialStep(
                  assetURI: 'assets/example/000_exercise.gif',
                  heading: '1. Krok',
                  description: '',
                ),
                TutorialStep(
                  assetURI: 'assets/example/001_exercise.gif',
                  heading: '2. Krok',
                  description: '.',
                ),
                TutorialStep(
                  assetURI: 'assets/example/FEI_logo.gif',
                  heading: '3. Krok',
                  description: '',
                ),
                TutorialStep(
                    assetURI: 'assets/example/002_exercise.gif',
                    heading: 'Potvrdenie',
                    description: ''
                ),
              ],
            ),
            MotionDetectionView(icon: Icons.touch_app, title: "FMS",
              tutorialSteps: [
                TutorialStep(
                  assetURI: 'assets/example/000_exercise.gif',
                  heading: '1. Krok',
                  description: '',
                ),
                TutorialStep(
                  assetURI: 'assets/example/001_exercise.gif',
                  heading: '2. Krok',
                  description: '.',
                ),
                TutorialStep(
                  assetURI: 'assets/example/FEI_logo.gif',
                  heading: '3. Krok',
                  description: '',
                ),
                TutorialStep(
                    assetURI: 'assets/example/002_exercise.gif',
                    heading: 'Potvrdenie',
                    description: ''
                ),
              ],
            ),
            MotionDetectionView(icon: Icons.touch_app, title: "FMS",
              tutorialSteps: [
                TutorialStep(
                  assetURI: 'assets/example/000_exercise.gif',
                  heading: '1. Krok',
                  description: '',
                ),
                TutorialStep(
                  assetURI: 'assets/example/001_exercise.gif',
                  heading: '2. Krok',
                  description: '.',
                ),
                TutorialStep(
                  assetURI: 'assets/example/FEI_logo.gif',
                  heading: '3. Krok',
                  description: '',
                ),
                TutorialStep(
                    assetURI: 'assets/example/002_exercise.gif',
                    heading: 'Potvrdenie',
                    description: ''
                ),
              ],
            ),
            MotionDetectionView(icon: Icons.touch_app, title: "FMS",
              tutorialSteps: [
                TutorialStep(
                  assetURI: 'assets/example/000_exercise.gif',
                  heading: '1. Krok',
                  description: '',
                ),
                TutorialStep(
                  assetURI: 'assets/example/001_exercise.gif',
                  heading: '2. Krok',
                  description: '.',
                ),
                TutorialStep(
                  assetURI: 'assets/example/FEI_logo.gif',
                  heading: '3. Krok',
                  description: '',
                ),
                TutorialStep(
                    assetURI: 'assets/example/002_exercise.gif',
                    heading: 'Potvrdenie',
                    description: ''
                ),
              ],
            ),
          ],
        ),
        SubMenuPageWrapper(icon: Icons.pan_tool_outlined, title: "Right Hand",
          subPages: [
            MotionDetectionView(icon: Icons.touch_app, title: "FMS",
              tutorialSteps: [
                TutorialStep(
                  assetURI: 'assets/example/000_exercise.gif',
                  heading: '1. Krok',
                  description: '',
                ),
                TutorialStep(
                  assetURI: 'assets/example/001_exercise.gif',
                  heading: '2. Krok',
                  description: '.',
                ),
                TutorialStep(
                  assetURI: 'assets/example/FEI_logo.gif',
                  heading: '3. Krok',
                  description: '',
                ),
                TutorialStep(
                    assetURI: 'assets/example/002_exercise.gif',
                    heading: 'Potvrdenie',
                    description: ''
                ),
              ],
            ),
            MotionDetectionView(icon: Icons.touch_app, title: "FMS",
              tutorialSteps: [
                TutorialStep(
                  assetURI: 'assets/example/000_exercise.gif',
                  heading: '1. Krok',
                  description: '',
                ),
                TutorialStep(
                  assetURI: 'assets/example/001_exercise.gif',
                  heading: '2. Krok',
                  description: '.',
                ),
                TutorialStep(
                  assetURI: 'assets/example/FEI_logo.gif',
                  heading: '3. Krok',
                  description: '',
                ),
                TutorialStep(
                    assetURI: 'assets/example/002_exercise.gif',
                    heading: 'Potvrdenie',
                    description: ''
                ),
              ],
            ),
            MotionDetectionView(icon: Icons.touch_app, title: "FMS",
              tutorialSteps: [
                TutorialStep(
                  assetURI: 'assets/example/000_exercise.gif',
                  heading: '1. Krok',
                  description: '',
                ),
                TutorialStep(
                  assetURI: 'assets/example/001_exercise.gif',
                  heading: '2. Krok',
                  description: '.',
                ),
                TutorialStep(
                  assetURI: 'assets/example/FEI_logo.gif',
                  heading: '3. Krok',
                  description: '',
                ),
                TutorialStep(
                    assetURI: 'assets/example/002_exercise.gif',
                    heading: 'Potvrdenie',
                    description: ''
                ),
              ],
            ),
            MotionDetectionView(icon: Icons.touch_app, title: "FMS",
              tutorialSteps: [
                TutorialStep(
                  assetURI: 'assets/example/000_exercise.gif',
                  heading: '1. Krok',
                  description: '',
                ),
                TutorialStep(
                  assetURI: 'assets/example/001_exercise.gif',
                  heading: '2. Krok',
                  description: '.',
                ),
                TutorialStep(
                  assetURI: 'assets/example/FEI_logo.gif',
                  heading: '3. Krok',
                  description: '',
                ),
                TutorialStep(
                    assetURI: 'assets/example/002_exercise.gif',
                    heading: 'Potvrdenie',
                    description: ''
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];

  // Getters
  List<BasePage> get pages => _pages;
}