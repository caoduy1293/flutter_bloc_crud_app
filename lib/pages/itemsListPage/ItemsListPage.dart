import 'package:flutter/material.dart';

import './Items.dart';
import '../../models/ItemModel.dart';
import '../../bloc/blocBase.dart';
import '../../bloc/globalBloc.dart';
import '../itemCreateEditPage/ItemCreateEditPage.dart';

class ItemsListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final GlobalBloc bloc = BlocProvider.of<GlobalBloc>(context);
    return Scaffold(
      body: Center(
        child: StreamBuilder<List<ItemModel>>(
            stream: bloc.dataStreamOut,
            initialData: bloc.items,
            builder: (BuildContext context, AsyncSnapshot<List<ItemModel>> snapshot){
              return Center(child: Items(snapshot.data),);
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            ItemCreateEditPage.routeName,
            arguments: null,
          );
        },
        tooltip: 'Add new item',
        child: Icon(Icons.add),
      ),
    );
  }

}