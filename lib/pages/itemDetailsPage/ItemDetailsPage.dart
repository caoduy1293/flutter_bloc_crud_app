import 'package:flutter/material.dart';

import '../../widgets/ui_elements/title_default.dart';
import '../../models/ItemModel.dart';
import '../../bloc/blocBase.dart';
import '../../bloc/globalBloc.dart';
import '../itemCreateEditPage/ItemCreateEditPage.dart';
import '../../utils.dart';
import '../../constants.dart';

class ItemDetailsPage extends StatefulWidget {
  static const routeName = '/item-details';
  final ItemModel item;
  ItemDetailsPage(this.item);

  @override
  State<StatefulWidget> createState() {
    return _ItemDetailsPageState();
  }
}

class _ItemDetailsPageState extends State<ItemDetailsPage> with AutomaticKeepAliveClientMixin<ItemDetailsPage>{
  @override
  bool get wantKeepAlive => true;

  List<Widget> _buildListStuffs(List<StuffModel> stuffs) {
    List<Widget> stuffsWidget = [];
    for(int i = 0; i< stuffs.length; i++) {
      int indexOfType = AppUtils.findItemIndexInListById(AppConstants.types, int.parse(stuffs[i].type));
      Widget stuffWidget = Row(
        children: <Widget>[
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Text(
                      (i + 1).toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          stuffs[i].name,
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          AppConstants.types[indexOfType].title,
                          style: TextStyle(color: Colors.grey,),
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
          Text(stuffs[i].quantity.toString())
        ],
      );
      stuffsWidget.add(stuffWidget);
      stuffsWidget.add(SizedBox(height: 10.0,));
    }
    return stuffsWidget.length > 0 ? stuffsWidget : Text('No stuffs');
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc bloc = BlocProvider.of<GlobalBloc>(context);
    super.build(context);

    return StreamBuilder<List<ItemModel>>(
        stream: bloc.dataStreamOut,
        initialData: bloc.items,
        builder: (BuildContext context, AsyncSnapshot<List<ItemModel>> snapshot){
          int itemIndex = AppUtils.findItemIndexInListById(snapshot.data, widget.item.id);
          return Scaffold(
              appBar: AppBar(
                  title: Text(snapshot.data[itemIndex].name),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Edit'),
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            ItemCreateEditPage.routeName,
                            arguments: snapshot.data[itemIndex],
                          );
                        }
                    )
                  ]
              ),
              body: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10.0),
                      child: TitleDefault(snapshot.data[itemIndex].name),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        snapshot.data[itemIndex].description,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: _buildListStuffs(snapshot.data[itemIndex].stuffs)
                      ),
                    ),
                  ],
                ),
              )
          );
        }
    );
  }
}