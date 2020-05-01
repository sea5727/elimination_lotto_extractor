import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'ResultLottoPage.dart';
import 'LottoStatistic.dart';
import 'File.dart';

final _random = new Random();
int next(int min, int max) => min + _random.nextInt(max - min);

List<int> getLottoNumbers(Map checkmap){
  Map checkMap = new Map.from(checkmap);
  int possibleNumbers = 0;
  for(var i = 1 ; i <= 45 ; i++){
    if(checkMap[i] == false) // 체크가 안되어있다면 추출할수있는 번호이다.
      possibleNumbers += 1;
  }
  print('possibleNumbers = ' + possibleNumbers.toString());
  if(possibleNumbers < 6) return <int>[];
  int min = 1;
  int max = 46;
  int count = 0;
  int value = 0;
  bool isContinue = true;
  List<int> resultList = <int>[];
  while(isContinue){
    print('start getLottoNumbers..\n');
    value = next(min, max);
    if(checkMap[value] == true)
      continue;
    print('value : ' + value.toString() + ' \n');
    checkMap[value] = true;
    resultList.add(value);
    count += 1;
    if(count >= 6)
      isContinue = false; 
  }
  
  return resultList;
}



PageSelectBallsState pageSelectBallsState;

class PageSelectBalls extends StatefulWidget{
  @override
  PageSelectBallsState createState() {
    pageSelectBallsState = PageSelectBallsState();
    return pageSelectBallsState;
  }
}

class PageSelectBallsState extends State<PageSelectBalls> {
  var myController = TextEditingController();
  String prevCount;
  BoxFit fit = BoxFit.fill;
  var clickBall = new Map();
  
  PageSelectBallsState(){
    myController.text = '5';
    prevCount = myController.text;
    for(var i = 1 ; i <= 45 ; i++){
      clickBall[i] = false;
      // print(i.toString() + ' value : ' + clickBall[i].toString());
    }
  }
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }



  _printLatestValue() {
    print('_printLatestValue!!!!!!!!!');
    print("Second text field: ${myController.text}");
    try{
      if(int.parse(myController.text) > 10){
        myController.text = '10';
      }
      else 
        prevCount = myController.text;
    }
    catch(err){
    }

  }

  @override
  void initState() {
    super.initState();
    myController.addListener(_printLatestValue);
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("설명서"),
          content: new Text("추첨에서 제외할 번호를 선택하세요. 그 후 추첨버튼을 눌러주세요."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var list = new List<Widget>();
    for(var i = 1 ; i <= 45 ; i++){
      var ballPath = '';
      // print('build => clickBall[' + i.toString() + '] : ' + clickBall[i].toString());
      if(clickBall[i] == false)
        ballPath = sprintf('assets/images/ball_%d.jpg', [i]);
      else 
        ballPath = 'assets/images/ball_false.jpg';

      list.add(
        GestureDetector(
          child: Image.asset( ballPath),
          onTapDown : (TapDownDetails details) { print('onTapDown..' + ballPath);},
          onTapUp : (TapUpDetails details) { print('onTapUp..' + ballPath);},
          onTap: () { 
              setState(() { 
                clickBall[i] = !clickBall[i];
                print(list[i].toString());
              });
            },
          ),

      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('제거할 번호를 선택 후 추첨하세요'),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('소거법 로또 추첨기입니다. 기능 추가 예정입니다. 감사합니다.'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('앱 설명서'),
              onTap: () {
                _showDialog();
                // Navigator.pop(context);
              },
            ),
            // ListTile(
            //   title: Text('통계 조회'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => LottoStatistic()),
            //     );
            //   },
            // ),
          ],
        ),
      ),
      body : ListView(
        children: <Widget>[
          GridView.count(
            padding: const EdgeInsets.all(5.0),
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 40.0,
            crossAxisCount: 5,
            // physics: ScrollPhysics(), // to disable GridView's scrolling
            shrinkWrap: true,
            children: list,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('갯수'),
                Container(
                  width: 50,
                  child: TextFormField(
                    controller: myController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                  
                ),
                RaisedButton(
                  child: Text("추첨"),
                  onPressed: () {
                    try{
                      print('onPressed!! randomCount : ' + myController.text);
                      int _num = int.parse(myController.text);
                      List<List<int>> results = new List<List<int>>();
                      for(int i = 0 ; i < _num ; i++){
                        List<int> result = getLottoNumbers(this.clickBall);
                        print('===============================\n');
                        for(var i = 0 ; i < result.length ; i++)
                          print('lotto : ' + result[i].toString() + '\n');
                        print('===============================\n');

                        results.add(result);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TestPageResultBalls(results)),
                      );
                    }
                    catch(err){

                    }
                  },
                ),
              ],
            ),
          ),
          
        ],
      )
    );
  }
}


