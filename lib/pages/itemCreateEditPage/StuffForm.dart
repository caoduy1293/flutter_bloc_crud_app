import 'package:flutter/material.dart';

import '../../models/ItemModel.dart';
import '../../models/TypeOfStuffModel.dart';
import '../../constants.dart';

typedef OnDelete();

class StuffForm extends StatefulWidget {
  final StuffModel stuff;
  final state = _StuffFormState();
  final OnDelete onDelete;

  StuffForm({Key key, this.stuff, this.onDelete}) : super(key: key);
  @override
  _StuffFormState createState() => state;

  bool isValid() => state.validate();
}

class _StuffFormState extends State<StuffForm> {
  final formKey = GlobalKey<FormState>();
  FocusNode _nameFocusNode;
  FocusNode _quantityFocusNode;
  FocusNode _typeFocusNode;

  @override
  void initState() {
    super.initState();

    _nameFocusNode = FocusNode();
    _quantityFocusNode = FocusNode();
    _typeFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Text('Stuff details',),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ),
            TextFormField(
              focusNode: _nameFocusNode,
              decoration: InputDecoration(labelText: 'Name'),
              initialValue: widget.stuff.name,
              validator: (String value) {
                if (value.isEmpty || value.length < 5) {
                  return 'Title is required and should be 5+ characters long.';
                }
              },
              onSaved: (input) => widget.stuff.name = input,
            ),
            TextFormField(
              focusNode: _quantityFocusNode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Quantity'),
              initialValue: widget.stuff.quantity.toString(),
              onSaved: (input) => widget.stuff.quantity = int.parse(input),
            ),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    errorText: state.hasError ? state.errorText : null,
                  ),
                  isEmpty: widget.stuff.type == '',
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      value: widget.stuff.type,
                      isDense: true,
                      elevation: AppConstants.types.length,
                      onChanged: (String newValue) {
                        setState(() {
                          widget.stuff.type = newValue;
                        });
                      },
                      items: AppConstants.types.map((TypeOfStuffModel value) {
                        return new DropdownMenuItem<String>(
                          value: value.id.toString(),
                          child: new Text(value.title),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              validator: (val) {
                return val != '' ? null : 'Please select a type';
              },
            )
          ],
        ),
      )
    );
  }

  ///form validator
  bool validate() {
    var valid = formKey.currentState.validate();
    if (valid) formKey.currentState.save();
    return valid;
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _quantityFocusNode.dispose();
    _typeFocusNode.dispose();

    super.dispose();
  }
}