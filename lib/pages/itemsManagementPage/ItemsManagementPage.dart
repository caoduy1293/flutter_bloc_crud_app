import 'package:flutter/material.dart';

import '../itemsListPage/ItemsListPage.dart';
import '../savedItemsListPage/SavedItemsListPage.dart';

class ItemsManagementPage extends StatelessWidget {
  static const routeName = '/';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Products'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.notifications_active),
                text: 'Active Items',
              ),
              Tab(
                icon: Icon(Icons.save),
                text: 'Saved Items',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ItemsListPage(),
            SavedItemsListPage()
          ],
        ),
      ),
    );
  }
}