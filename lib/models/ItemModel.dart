import 'package:flutter/material.dart';

import './BaseModel.dart';
import '../constants.dart';

class ItemModel extends BaseModel {
  int id;
  final String name;
  final DateTime dateTime;
  final String description;
  final List<StuffModel> stuffs;
  ItemModel({
        @required this.id,
        @required this.name,
        this.dateTime,
        this.description,
        this.stuffs,
      });
}

class StuffModel {
  String name;
  String type = AppConstants.types[0].id.toString();
  int quantity;
  String description;
  StuffModel({
    @required this.name,
    @required this.quantity,
    this.type,
    this.description,
  }){
    if(this.type == null) {
      this.type = AppConstants.types[0].id.toString();
    }
  }
}