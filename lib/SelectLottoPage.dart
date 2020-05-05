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


int select10sect(List<double> avers){

  var _random = new Random();
  try{
    var temp1 = avers[0];
    var temp2 = avers[1];
    var temp3 = avers[2];
    var temp4 = avers[3];
    var temp5 = avers[4];
    // var temp1 = double.tryParse(strAver01to10);
    // var temp2 = double.tryParse(strAver11to20);
    // var temp3 = double.tryParse(strAver21to30);
    // var temp4 = double.tryParse(strAver31to40);
    // var temp5 = double.tryParse(strAver41to45);
    var total = temp1 + temp2 + temp3 + temp4 + temp5;
    total = total * 100;
    
    var randomvalue = _random.nextInt(total.toInt());
    if(randomvalue < temp1 * 100){
      print('randomvalue : ' + randomvalue.toString());
      print('this is 1~10.. ');
      return 0;
    }
    else if(randomvalue < (temp1 + temp2) * 100){
      print('randomvalue : ' + randomvalue.toString());
      print('this is 11~20.. ');      
      return 1;
    }
    else if(randomvalue < (temp1 + temp2 + temp3) * 100){
      print('randomvalue : ' + randomvalue.toString());
      print('this is 21~30.. ');
      return 2;
    }
    else if(randomvalue < (temp1 + temp2 + temp3 + temp4) * 100){
      print('randomvalue : ' + randomvalue.toString());
      print('this is 31~40.. ');
      return 3;
    }
    else if(randomvalue < (temp1 + temp2 + temp3 + temp4 + temp5) * 100){
      print('randomvalue : ' + randomvalue.toString());
      print('this is 41~45.. ');      
      return 4;
    }
    else {
      print('randomvalue : ' + randomvalue.toString());
      print('this is else');
      return -1;
    }    
  }
  catch(err){
    print(err.toString());
    return null;
  }
  
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
  List<double> currentaverage;
  int mytest;
  String prevCount;
  BoxFit fit = BoxFit.fill;
  var clickBall = new Map();
  
  PageSelectBallsState(){
    mytest = 1;
    currentaverage = [22.2, 22.2, 22.2, 22.2, 11.1];
    print('current aver : ');
    for(int i = 0 ; i < currentaverage.length ; i++){
      print(currentaverage[i]);
    }
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
          title: new Text('설명서'),
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
  int getLotto1Number(int min, int max, Map checkMap){
    List<int> balls = [];
    for(var i = min ; i <= max ; i++){
      if(checkMap[i] == false){
        balls.add(i);
      }
    }
    if(balls.length == 0) return -1;
    var idx = _random.nextInt(balls.length);
    return balls[idx];
  }
  List<int> getLottoNumbers(Map checkmap){
    try{
      List<int> resultList = <int>[];
      List<int> resultListNew = <int>[];
      Map checkMap = new Map.from(checkmap);
      int possibleNumbers = 0;
      for(var i = 1 ; i <= 45 ; i++){
        if(checkMap[i] == false) // 체크가 안되어있다면 추출할수있는 번호이다.
          possibleNumbers += 1;
      }
      print('possibleNumbers = ' + possibleNumbers.toString());
      if(possibleNumbers < 6) {
        throw '번호 개수가 6보다 작습니다.';
      }



      bool condition = true;
      int ncount = 0;
      int nTotalCount = 0;
      while(condition){
        if(ncount >= 6) break;
        if(nTotalCount >= 100) throw '확률이 비정상적입니다.';
        nTotalCount += 1;
        var result = select10sect(this.currentaverage);
        print('select10sect result : ' + result.toString());
        switch(result){
          case 0:
            var v = getLotto1Number(1, 10, checkMap);
            if(v < 0) continue;
            checkMap[v] = true;
            resultListNew.add(v);
            ncount += 1;
            break;
          case 1:
            var v = getLotto1Number(11, 20, checkMap);
            if(v < 0) continue;
            checkMap[v] = true;
            resultListNew.add(v);
            ncount += 1;
            break;
          case 2:
            var v = getLotto1Number(21, 30, checkMap);
            if(v < 0) continue;
            checkMap[v] = true;
            resultListNew.add(v);
            ncount += 1;
            break;
          case 3:
            var v = getLotto1Number(31, 40, checkMap);
            if(v < 0) continue;
            checkMap[v] = true;
            resultListNew.add(v);
            ncount += 1;
            break;
          case 4:
            var v = getLotto1Number(41, 45, checkMap);
            if(v < 0) continue;
            checkMap[v] = true;
            resultListNew.add(v);
            ncount += 1;
            break;
          default : break;
        }
      }      

      print('new Result : ');
      for(int i = 0 ; i < resultListNew.length ; i++){
        print(resultListNew[i]);
      }
      return resultListNew;

      // int min = 1;
      // int max = 46;
      // int count = 0;
      // int value = 0;
      // bool isContinue = true;
      
      // while(isContinue){
      //   // print('start getLottoNumbers..\n');
      //   value = next(min, max);
      //   if(checkMap[value] == true)
      //     continue;
      //   // print('value : ' + value.toString() + ' \n');
      //   checkMap[value] = true;
      //   resultList.add(value);
      //   count += 1;
      //   if(count >= 6)
      //     isContinue = false; 
      // }
      
      return resultList;
    }
    catch(err){
      print('err : ' + err.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text('오류'),
            content: new Text(err.toString()),
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
      return null;
    }

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
          child: Image.asset(ballPath),
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
            ListTile(
              title: Text('통계 조회'),
              onTap: () {
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LottoStatistic()),
                );
              },
            ),
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
                  child: Text('추첨'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex : 1,
                child : SizedBox(width: 1,),
              ),
              Expanded(
                flex : 2,
                child : Column(
                  children: <Widget>[
                    Text('현재 확률 : '),
                    Text('1~10 : ${currentaverage[0]}%'),
                    Text('11~20 : ${currentaverage[1]}%'),
                    Text('21~30 : ${currentaverage[2]}%'),
                    Text('31~40 : ${currentaverage[3]}%'),
                    Text('41~45 : ${currentaverage[4]}%'),
                  ],
                ),
              ),
              Expanded(
                flex : 1,
                child : RaisedButton(
                  child: Text('통계수정'),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LottoStatistic()),
                    );
                  },
                ),
              ),

            ],
          ),

        ],
      )
    );
  }
}


