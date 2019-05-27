import 'package:flutter/material.dart';

import '../../models/ItemModel.dart';
import '../itemDetailsPage/ItemDetailsPage.dart';
import '../../bloc/blocBase.dart';
import '../../bloc/globalBloc.dart';
import '../../bloc/globalBlocEvent.dart';
import '../itemCreateEditPage/ItemCreateEditPage.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item;
  ItemCard(this.item);

  Widget _buildDetailsRow(ItemModel item, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(item.name),
          SizedBox(
            width: 8.0,
          ),
//          Container(
//            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
//            decoration: BoxDecoration(
//                color: Theme.of(context).accentColor,
//                borderRadius: BorderRadius.circular(5.0)),
//            child: Text(
//              item.dateTime != null ? item.dateTime : '',
//              style: TextStyle(color: Colors.white),
//            ),
//          )
        ],
      ),
    );
  }

  // user defined function
  void _showDialog(BuildContext context, GlobalBloc bloc) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete"),
          content: new Text("Are you sure ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                bloc.eventIn.add(RemoveItemEvent(item.id));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc bloc = BlocProvider.of<GlobalBloc>(context);
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(6.0),
            child: Icon(Icons.inbox),
          ),
          _buildDetailsRow(item, context),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    ItemDetailsPage.routeName,
                    arguments: item,
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  _showDialog(context, bloc);
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    ItemCreateEditPage.routeName,
                    arguments: item,
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}