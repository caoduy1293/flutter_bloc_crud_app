import 'dart:async';

import './blocBase.dart';
import './globalBlocEvent.dart';
import '../models/ItemModel.dart';

class GlobalBloc implements BlocBase {
  List<ItemModel> _items = [];

  List<ItemModel> get items {
    return List.from(_items);
  }

  // Stream to handle the list of items
  StreamController<List<ItemModel>> _dataController = StreamController<List<ItemModel>>.broadcast();
  StreamSink<List<ItemModel>> get _dataSinkIn => _dataController.sink;
  Stream<List<ItemModel>> get dataStreamOut => _dataController.stream;

  // Stream to handle the action on the counter
  StreamController<GlobalEvent> _eventController = StreamController<GlobalEvent>();
  StreamSink<GlobalEvent> get eventIn => _eventController.sink;

  GlobalBloc(){
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(GlobalEvent event){
    if (event is AddGlobalEvent)
      _items.add(event.item);
    if(event is RemoveItemEvent) {
      var find = _items.firstWhere(
            (it) => it.id == event.itemId,
        orElse: () => null,
      );
      if (find != null) _items.removeAt(_items.indexOf(find));
    }
    if(event is EditItemEvent) {
      var find = _items.firstWhere(
            (it) => it.id == event.item.id,
        orElse: () => null,
      );
      if (find != null) _items[_items.indexOf(find)] = event.item;
    }
    _dataSinkIn.add(List.from(_items));
  }

  @override
  void dispose() {
    _dataController.close();
    _eventController.close();
  }
}
