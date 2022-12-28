// import 'package:flutter/material.dart';
// import 'package:scoped_model/scoped_model.dart';

// import 'package:edexpro/exams/ui/default_panning.dart';

// class SampleList {
//   SampleList(this.title, this.description, this.image,
//       [this.subItemList, this.status]);
//   final String title;
//   final String description;
//   final String image;
//   final List<List<SubItemList>> subItemList;
//   final String status;
// }

// class SubItemList {
//   SubItemList(this.category, this.title, this.description, this.image,
//       [this.previewWidget, this.codeViewerLink, this.status]);
//   final String category;
//   final String title;
//   final String description;
//   final String image;
//   final String codeViewerLink;
//   final Widget previewWidget;
//   final String status;
// }

// class SampleListModel extends Model {
//   SampleListModel() {
//     controlList = <SampleList>[];
//     searchControlListItems = <SampleList>[];
//     sampleList = <SubItemList>[];
//     searchSampleListItems = <SubItemList>[];
//     userInteractionSubItemList = <List<SubItemList>>[];
//     // User Interactions Types
//     zoomingPanningSubItemList = <SubItemList>[];

//     // Interaction Types
    
//     zoomingPanningSubItemList.add(SubItemList(
//       'Zooming and Panning',
//       'Pinch zooming',
//       'Pinch zooming and panning is enabled in this sample. Pinch the chart to zoom it and swipe the zoomed chart to pan it.',
//       'images/circular.png',
//       getDefaultPanningChart(isTileView),
//     ));

//     userInteractionSubItemList.add(zoomingPanningSubItemList);

//     controlList.add(SampleList(
//         'User Interactions',
//         'Real-time demos of the interactive features in chart',
//         'images/user_interaction.png',
//         userInteractionSubItemList,
//         'Updated'));

//     // For search results

//     searchControlListItems.addAll(controlList);
//     for (int index = 0; index < controlList.length; index++) {
//       for (int categoryIndex = 0;
//           categoryIndex < controlList[index].subItemList.length;
//           categoryIndex++) {
//         for (int sampleIndex = 0;
//             sampleIndex < controlList[index].subItemList[categoryIndex].length;
//             sampleIndex++) {
//           searchSampleListItems
//               .add(controlList[index].subItemList[categoryIndex][sampleIndex]);
//         }
//       }
//     }
//   }

//   bool isTargetMobile;
//   List<SampleList> controlList;
//   List<SampleList> searchControlListItems; // To handle search
//   List<SubItemList> sampleList;
//   List<SubItemList> searchSampleListItems; // To handle search

//   int selectedIndex = 0;
//   Color backgroundColor = const Color.fromRGBO(0, 116, 228, 1);
//   Color slidingPanelColor = const Color.fromRGBO(250, 250, 250, 1);
//   Color paletteColor;
//   ThemeData themeData = ThemeData.light();
//   Color searchBoxColor = Colors.white;
//   Color listIconColor = const Color.fromRGBO(0, 116, 228, 1);
//   Color listDescriptionTextColor = Colors.grey;
//   Color textColor = const Color.fromRGBO(51, 51, 51, 1);
//   String codeViewerIcon = 'images/code.png';
//   String informationIcon = 'images/info.png';
//   Brightness theme = Brightness.light;
//   Color drawerTextIconColor = Colors.black;
//   Color drawerIconColor = Colors.black;
//   Color drawerBackgroundColor = Colors.white;
//   Color bottomSheetBackgroundColor = Colors.white;
//   final bool isTileView = true;
//   Color cardThemeColor = Colors.white;

//   // Cartesian Types
//   List<List<SubItemList>> userInteractionSubItemList;

//   // User Interactions Types
//   List<SubItemList> zoomingPanningSubItemList;

//   void changeTheme(ThemeData _themeData) {
//     themeData = _themeData;
//     switch (_themeData.brightness) {
//       case Brightness.light:
//         {
//           drawerTextIconColor = Colors.black;
//           drawerIconColor = Colors.black;
//           slidingPanelColor = Colors.white;
//           drawerIconColor = Colors.black;
//           drawerBackgroundColor = Colors.white;
//           bottomSheetBackgroundColor = Colors.white;
//           backgroundColor =
//               paletteColor ?? const Color.fromRGBO(0, 116, 228, 1);
//           listIconColor = paletteColor ?? const Color.fromRGBO(0, 116, 228, 1);
//           searchBoxColor = Colors.white;
//           listDescriptionTextColor = Colors.grey;
//           textColor = const Color.fromRGBO(51, 51, 51, 1);
//           theme = Brightness.light;
//           cardThemeColor = Colors.white;
//           break;
//         }
//       case Brightness.dark:
//         {
//           drawerTextIconColor = Colors.white;
//           drawerIconColor = Colors.white;
//           slidingPanelColor = const Color.fromRGBO(32, 33, 37, 1);
//           drawerBackgroundColor = Colors.black;
//           bottomSheetBackgroundColor = const Color.fromRGBO(34, 39, 51, 1);
//           backgroundColor =
//               paletteColor ?? const Color.fromRGBO(0, 116, 228, 1);
//           listIconColor = paletteColor ?? Colors.white;
//           searchBoxColor = Colors.white;
//           listDescriptionTextColor = const Color.fromRGBO(242, 242, 242, 1);
//           textColor = const Color.fromRGBO(242, 242, 242, 1);
//           theme = Brightness.dark;
//           // cardThemeColor = Colors.black.withOpacity(0.7);
//           cardThemeColor = const Color.fromRGBO(23, 27, 36, 1);
//           break;
//         }
//       default:
//         {
//           drawerTextIconColor = Colors.white;
//           drawerBackgroundColor = Colors.white;
//           bottomSheetBackgroundColor = Colors.white;
//           drawerIconColor = Colors.white;
//           slidingPanelColor = Colors.white;
//           backgroundColor = const Color.fromRGBO(0, 116, 228, 1);
//           searchBoxColor = Colors.white;
//           listIconColor = const Color.fromRGBO(0, 116, 228, 1);
//           listDescriptionTextColor = Colors.white;
//           textColor = const Color.fromRGBO(51, 51, 51, 1);
//           theme = Brightness.light;
//           cardThemeColor = Colors.white;
//           break;
//         }
//     }
//   }
// }
