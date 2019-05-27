import 'package:flutter/material.dart';

import './pages/itemsManagementPage/ItemsManagementPage.dart';
import './pages/itemDetailsPage/ItemDetailsPage.dart';
import './pages/itemCreateEditPage/ItemCreateEditPage.dart';
import './models/ItemModel.dart';
import './bloc/blocBase.dart';
import './bloc/globalBloc.dart';

void main() {
  runApp(BlocWrappedMyApp());
}

class BlocWrappedMyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GlobalBloc>(
      bloc: GlobalBloc(),
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Getme',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (BuildContext context) => ItemsManagementPage(),
      },
      onGenerateRoute: (settings) {
        // If you push the PassArguments route
        if (settings.name == ItemDetailsPage.routeName) {
          // Cast the arguments to the correct type: ScreenArguments.
          final ItemModel args = settings.arguments;

          // Then, extract the required data from the arguments and
          // pass the data to the correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return ItemDetailsPage(args);
            },
          );
        }
        if (settings.name == ItemCreateEditPage.routeName) {
          // Cast the arguments to the correct type: ScreenArguments.
          final ItemModel args = settings.arguments;

          // Then, extract the required data from the arguments and
          // pass the data to the correct screen.
          return MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) {
              return ItemCreateEditPage(args);
            },
          );
        }
      }
    );
  }
}
