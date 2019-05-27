import 'dart:async';
import 'package:flutter/material.dart';

import '../../models/ItemModel.dart';
import '../../bloc/blocBase.dart';
import '../../bloc/globalBloc.dart';
import '../../bloc/globalBlocEvent.dart';
import '../../widgets/emptyList.dart';
import './StuffForm.dart';

class ItemCreateEditPage extends StatefulWidget {
  static const routeName = '/item-form';
  final ItemModel item;
  ItemCreateEditPage(this.item);

  @override
  State<StatefulWidget> createState() {
    return _ItemCreateEditPageState();
  }
}

class _ItemFormData {
  String name;
  DateTime dateTime;
  String description;
  _ItemFormData();
}

class _ItemCreateEditPageState extends State<ItemCreateEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<StuffForm> stuffsForm = [];
  _ItemFormData _formData = _ItemFormData();
  DateTime _selectedDate;

  FocusNode _nameFocusNode;
  FocusNode _descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    if(widget.item != null && widget.item.stuffs != null && widget.item.stuffs.length > 0) {
      List<StuffForm> stuffsFormTemporary = [];
      widget.item.stuffs.forEach((stuff) => {
          stuffsFormTemporary.add(StuffForm(key: GlobalKey(), stuff: stuff, onDelete: () => onDelete(stuff),))
      });
      setState(() {
        stuffsForm = stuffsFormTemporary;
        _formData.name = widget.item.name;
        _formData.dateTime = widget.item.dateTime;
        _formData.description = widget.item.description;
      });
    }
    _nameFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
  }

  ///on form stuff deleted
  void onDelete(StuffModel _stuff) {
    setState(() {
      var find = stuffsForm.firstWhere(
            (it) => it.stuff == _stuff,
        orElse: () => null,
      );
      if (find != null) stuffsForm.removeAt(stuffsForm.indexOf(find));
    });
  }

  ///on add stuff form
  void onAddForm() {
    setState(() {
      var _stuff = StuffModel(name: '', quantity: 0);
      stuffsForm.add(StuffForm(
        key: GlobalKey(),
        stuff: _stuff,
        onDelete: () => onDelete(_stuff),
      ));
    });
  }

  Widget _buildListStuffsForm(ItemModel item) {
    return stuffsForm.length <= 0
        ? EmptyState(title: 'No Stuffs', message: 'Add more stuffs',)
        : Column(
      children: stuffsForm,
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate){
      _formData.dateTime = picked;
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void onSave(GlobalBloc bloc, AsyncSnapshot<List<ItemModel>> snapshot) {
    bool allValidStuffs = true;
    List<StuffModel> stuffs = [];
    if (stuffsForm.length > 0) {
      stuffsForm.forEach((form) => allValidStuffs = allValidStuffs && form.isValid());
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if(allValidStuffs) {
        stuffs = stuffsForm.map((it) => it.stuff).toList();
      }
      if(widget.item != null)
        bloc.eventIn.add(EditItemEvent(ItemModel(id: widget.item.id, name: _formData.name, description: _formData.description, stuffs: stuffs)));
      else
        bloc.eventIn.add(AddGlobalEvent(
            ItemModel(id: snapshot.data.length + 1, name: _formData.name, description: _formData.description, stuffs: stuffs)
        ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc bloc = BlocProvider.of<GlobalBloc>(context);

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return Scaffold(
      appBar: AppBar(
          title: Text('Scheduler Form'),
          actions: <Widget>[
            Container(
              child: StreamBuilder<List<ItemModel>>(
                  stream: bloc.dataStreamOut,
                  initialData: bloc.items,
                  builder: (BuildContext context, AsyncSnapshot<List<ItemModel>> snapshot){
                    return FlatButton(
                        child: Text('Save'),
                        textColor: Colors.white,
                        onPressed: () {
                          onSave(bloc, snapshot);
                        }
                    );
                  }
              ),
            )
          ]
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
              children: <Widget>[
                TextFormField(
                  focusNode: _nameFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    icon: Icon(Icons.title),
                    isDense: true,
                  ),
                  initialValue: widget.item == null ? '' : widget.item.name,
                  validator: (String value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Title is required and should be 5+ characters long.';
                    }
                  },
                  onSaved: (input) => _formData.name = input,
                ),
                TextFormField(
                  focusNode: _descriptionFocusNode,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    icon: Icon(Icons.description),
                    isDense: true,
                  ),
                  initialValue: widget.item == null ? '' : widget.item.description,
                  validator: (String value) {
                    // if (value.trim().length <= 0) {
                    if (value.isEmpty || value.length < 10) {
                      return 'Description is required and should be 10+ characters long.';
                    }
                  },
                  onSaved: (String value) {
                    _formData.description = value;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.timer),
                      SizedBox(
                        width: 10.0,
                      ),
                      RaisedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('Select date'),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text( _selectedDate != null ? _selectedDate.toString() : '')
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        /*1*/
                        child: Text('Stuffs',style: TextStyle(color: Colors.white),),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: onAddForm,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                _buildListStuffsForm(widget.item)
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();

    super.dispose();
  }
}