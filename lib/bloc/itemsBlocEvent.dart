import '../models/ItemModel.dart';
abstract class ItemsEvent {}

class AddItemEvent extends ItemsEvent {
  AddItemEvent(this.item);
  final ItemModel item;
}