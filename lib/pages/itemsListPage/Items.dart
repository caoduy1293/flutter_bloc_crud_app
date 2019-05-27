import 'package:flutter/material.dart';

import '../../models/ItemModel.dart';
import './ItemCard.dart';
import '../../widgets/emptyList.dart';

class Items extends StatelessWidget {
  final List<ItemModel> items;
  Items(this.items);

  Widget _buildItemList(List<ItemModel> items) {
    Widget itemCards;
    if (items != null && items.length > 0) {
      itemCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ItemCard(items[index]),
        itemCount: items.length,
      );
    } else {
      itemCards = EmptyState(message: 'Add new scheduler', title: 'No Scheduler',);
    }
    return itemCards;
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemList(this.items);
  }
}