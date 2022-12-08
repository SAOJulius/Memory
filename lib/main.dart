import 'package:Memory/utils/game_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'icons.dart';

import 'components/info_card.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _cities = ["Easy", "Medium", "Hard"];

  late List<DropdownMenuItem<String>> _dropDownMenuItems;
  late String _currentCity;

  @override
  void initState() {
    final box = GetStorage();
    int index = 0;
    if (box.read("mode") == "Easy") {
      index = 0;
    } else if (box.read("mode") == "Medium") {
      index = 1;
    } else if (box.read("mode") == "Hard") {
      index = 2;
    }
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCity = _dropDownMenuItems[index].value!;

    super.initState();
    _game.initGame();
    _game.cards_list.shuffle();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String city in _cities) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  //setting text style
  TextStyle whiteText = TextStyle(color: Colors.white);
  bool hideTest = false;
  Game _game = Game();

  //game stats
  int tries = 0;
  int score = 0;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE55870),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Memory Game",
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                info_card("Tries", "$tries"),
                info_card("Score", "$score"),
              ],
            ),
            SizedBox(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                    itemCount: _game.gameImg!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    padding: EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          print(_game.matchCheck);
                          setState(() {
                            //incrementing the clicks
                            tries++;

                            _game.gameImg![index] = _game.cards_list[index];
                            _game.matchCheck
                                .add({index: _game.cards_list[index]});
                            print(_game.matchCheck.first);
                          });
                          if (_game.matchCheck.length == 2) {
                            if (_game.matchCheck[0].values.first ==
                                _game.matchCheck[1].values.first) {
                              print("true");
                              //incrementing the score
                              score += 100;
                              _game.matchCheck.clear();
                            } else {
                              print("false");

                              Future.delayed(Duration(milliseconds: 500), () {
                                print(_game.gameColors);
                                setState(() {
                                  _game.gameImg![_game.matchCheck[0].keys
                                      .first] = _game.hiddenCardpath;
                                  _game.gameImg![_game.matchCheck[1].keys
                                      .first] = _game.hiddenCardpath;
                                  _game.matchCheck.clear();
                                });
                              });
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFB46A),
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: AssetImage(_game.gameImg![index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    })),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    //radius: 30,
                    backgroundColor: Colors.lightBlue,
                    child: IconButton(
                      icon: const Icon(Icons.refresh),
                      color: Colors.white,
                      tooltip: 'Start new Game',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      },
                    ),
                  ),
                  Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        //side: BorderSide(width: 1.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      ),
                      color: Colors.lightBlue,
                    ),
                    //color: Colors.lightBlue,
                    child: DropdownButton(
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      dropdownColor: Colors.lightBlue,
                      iconEnabledColor: Colors.white,
                      value: _currentCity,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void changedDropDownItem(selectedCity) {
    setState(() {
      final box = GetStorage();
      _currentCity = selectedCity;
      if (_currentCity == "Easy") {
        box.write('mode', "Easy");
      } else if (_currentCity == "Medium") {
        box.write('mode', "Medium");
      } else if (_currentCity == "Hard") {
        box.write('mode', "Hard");
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }
}
