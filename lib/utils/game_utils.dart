import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Game {
  final Color hiddenCard = Colors.red;
  List<Color>? gameColors;
  List<String>? gameImg;
  List<Color> cards = [
    Colors.green,
    Colors.yellow,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.blue
  ];
  final String hiddenCardpath = "assets/images/hidden.png";
  final box = GetStorage();
  
  
  List<String> list = [
    "assets/easy/1.png",
    "assets/easy/1.png",
    "assets/easy/2.png",
    "assets/easy/2.png",
    "assets/easy/3.png",
    "assets/easy/3.png",
    "assets/easy/4.png",
    "assets/easy/4.png",
    "assets/easy/5.png",
    "assets/easy/5.png",
    "assets/easy/6.png",
    "assets/easy/6.png",
    "assets/easy/7.png",
    "assets/easy/7.png",
    "assets/easy/8.png",
    "assets/easy/8.png",
  ];

  List<String> list1 = [
    "assets/medium/1.png",
    "assets/medium/1.png",
    "assets/medium/2.png",
    "assets/medium/2.png",
    "assets/medium/3.png",
    "assets/medium/3.png",
    "assets/medium/4.png",
    "assets/medium/4.png",
    "assets/medium/5.png",
    "assets/medium/5.png",
    "assets/medium/6.png",
    "assets/medium/6.png",
    "assets/medium/7.png",
    "assets/medium/7.png",
    "assets/medium/8.png",
    "assets/medium/8.png",
  ];
  List<String> list2 = [
    "assets/hard/1.png",
    "assets/hard/1.png",
    "assets/hard/2.png",
    "assets/hard/2.png",
    "assets/hard/3.png",
    "assets/hard/3.png",
    "assets/hard/4.png",
    "assets/hard/4.png",
    "assets/hard/5.png",
    "assets/hard/5.png",
    "assets/hard/6.png",
    "assets/hard/6.png",
    "assets/hard/7.png",
    "assets/hard/7.png",
    "assets/hard/8.png",
    "assets/hard/8.png",
  ];

  List<String> cards_list = [];


  final int cardCount = 16;
  List<Map<int, String>> matchCheck = [];

  //methods
  void initGame() {
    if(box.read("mode") == "Easy"){
      cards_list = list;
    }else if(box.read("mode") == "Medium"){
      cards_list = list1;
    }else if(box.read("mode") == "Hard"){
      cards_list = list2;
    }else{
      cards_list = list;
    }
    
    gameColors = List.generate(cardCount, (index) => hiddenCard);
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}
