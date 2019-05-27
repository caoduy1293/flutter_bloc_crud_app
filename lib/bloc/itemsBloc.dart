import 'dart:async';

import './blocBase.dart';
import './itemsBlocEvent.dart';
import '../models/ItemModel.dart';

class ItemsBloc implements BlocBase {
  List<ItemModel> _items = [];
  //
  // Stream to handle the list of items
  //
  StreamController<ItemsState> _itemsController = StreamController<ItemsState>();
  StreamSink<ItemsState> get _itemsIn => _itemsController.sink;
  Stream<ItemsState> get itemsStateOut => _itemsController.stream;

  //
  // Stream to handle the action on the counter
  //
  StreamController<ItemsEvent> _eventController = StreamController<ItemsEvent>();
  StreamSink<ItemsEvent> get eventIn => _eventController.sink;

  //
  // Constructor
  //
  ItemsBloc(){
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ItemsEvent event){
    if (event is AddItemEvent)
      _items.add(event.item);
      _itemsIn.add(ItemsState._itemsData(List.from(_items)));

  }

  @override
  void dispose() {
    _itemsController.close();
    _eventController.close();
  }
}

class ItemsState {
  ItemsState();
  factory ItemsState._itemsData(List<ItemModel> items) = ItemsDataState;
  factory ItemsState._itemsLoading() = ItemsLoadingState;
}

class ItemsInitState extends ItemsState {}

class ItemsLoadingState extends ItemsState {}

class ItemsDataState extends ItemsState {
  ItemsDataState(this.items);
  final List<ItemModel> items;
}