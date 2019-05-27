import '../models/ItemModel.dart';
abstract class GlobalEvent {}

class AddGlobalEvent extends GlobalEvent {
  AddGlobalEvent(this.item);
  final ItemModel item;
}
class RemoveItemEvent extends GlobalEvent {
  RemoveItemEvent(this.itemId);
  final int itemId;
}

class EditItemEvent extends GlobalEvent {
  EditItemEvent(this.item);
  final ItemModel item;
}