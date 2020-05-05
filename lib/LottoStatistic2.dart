import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:convert/convert.dart'as convert;

import 'SelectLottoPage.dart';




class LottoStatistic extends StatefulWidget {
    @override
  LottoStatisticState createState() => new LottoStatisticState(); 
}

class LottoStatisticState extends State<LottoStatistic> {
  List<Task> pieData;
  List<charts.Series<Task, String>> _seriesPieData;
  List<charts.Series<LottoStatistics, String>> _seriesPieData2;
  List<int> sumStatistics;
  List<LottoStatistics> aver10Statistics;
  static const int MIN_STAGE = 1;
  static const int MAX_STAGE = 906;
  int minStage = 906;
  int maxStage = 906;
  Future<String> futureFile;

  List<LottoStatistics>temp2222;
  void _showDialogMinNumberPicker() {
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          title: new Text("Pick a new price"),
          minValue: MIN_STAGE,
          maxValue: MAX_STAGE,
          initialIntegerValue: minStage,
        );
      }
    ).then((int value){
      if (value != null) {
        setState(() => minStage = value);
      }
    });
  }
  void _showDialogMaxNumberPicker() {
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          title: new Text("Pick a new price"),
          minValue: MIN_STAGE,
          maxValue: MAX_STAGE,
          initialIntegerValue: maxStage,
        );
      }
    ).then((int value){
      if (value != null) {
        setState(() => maxStage = value);
      }
    });
  }
  Future<int> selectStatistic(min, max) async {
    sumStatistics = List<int>.filled(46, 0);
    aver10Statistics.clear();
    print('start selectStatistic => aver10Statistics.lengh : ${aver10Statistics.length}');
    int total = 0;
    List<dynamic> results = [];
    
    for(var i = min ; i < max + 1 ; i++){
      total += 6;
      var filePath = 'assets/res/history_$i.txt';
      var data = await rootBundle.loadString(filePath);
      Map<String, dynamic> obj = jsonDecode(data);
      results.add(obj);
      // obj.forEach((k, v) => print('Key=$k, Value=$v'));
    }
    for(int i = 0 ; i < results.length ; i++){
      Map<String, dynamic> obj = results[i];
      var keys = ['drwtNo1', 'drwtNo2', 'drwtNo3', 'drwtNo4', 'drwtNo5', 'drwtNo6'];
      obj.forEach((key, value){
        if(keys.contains(key)){
          sumStatistics[value] += 1;
        }
      });
    }
    int idx = 0;
    double divaver = 0.0;
    int prevNumber = 0;
    int curNumber = 0;

    var colors = [Color(0xff1c39bb), Color(0xffe52b50), Color(0xff00ff7f), Color(0xfffdee00), Color(0xffffae42)];
    var check = [10, 20, 30, 40, 45];
    sumStatistics.asMap().forEach((numbers, values){
      // (num / total_number) * 100
      divaver += (values.toDouble() / total) * 100;
      if(check.contains(numbers)){
        divaver = double.parse(divaver.toStringAsFixed(3));
        print('divaver : $divaver');
        prevNumber = curNumber;
        curNumber = numbers;
        aver10Statistics.add(
          new LottoStatistics('$prevNumber번~$curNumber번', divaver, colors[idx])
        );
        divaver = 0.0;
        idx += 1 ;
      }
    });
    print('end selectStatistic => aver10Statistics.lengh : ${aver10Statistics.length}');
    
    return total;
  }
  Future<List<LottoStatistics>> selectStatistic2(min, max) async {
    sumStatistics = List<int>.filled(46, 0);
    var temp = List<LottoStatistics>();
    temp.clear();
    print('start selectStatistic => aver10Statistics.lengh : ${aver10Statistics.length}');
    int total = 0;
    List<dynamic> results = [];
    
    for(var i = min ; i < max + 1 ; i++){
      total += 6;
      var filePath = 'assets/res/history_$i.txt';
      var data = await rootBundle.loadString(filePath);
      Map<String, dynamic> obj = jsonDecode(data);
      results.add(obj);
      // obj.forEach((k, v) => print('Key=$k, Value=$v'));
    }
    for(int i = 0 ; i < results.length ; i++){
      Map<String, dynamic> obj = results[i];
      var keys = ['drwtNo1', 'drwtNo2', 'drwtNo3', 'drwtNo4', 'drwtNo5', 'drwtNo6'];
      obj.forEach((key, value){
        if(keys.contains(key)){
          sumStatistics[value] += 1;
        }
      });
    }
    int idx = 0;
    double divaver = 0.0;
    int prevNumber = 0;
    int curNumber = 0;

    var colors = [Color(0xff1c39bb), Color(0xffe52b50), Color(0xff00ff7f), Color(0xfffdee00), Color(0xffffae42)];
    var check = [10, 20, 30, 40, 45];
    sumStatistics.asMap().forEach((numbers, values){
      // (num / total_number) * 100
      divaver += (values.toDouble() / total) * 100;
      if(check.contains(numbers)){
        divaver = double.parse(divaver.toStringAsFixed(3));
        print('divaver : $divaver');
        prevNumber = curNumber;
        curNumber = numbers;
        temp.add(
          new LottoStatistics('$prevNumber번~$curNumber번', divaver, colors[idx])
        );
        divaver = 0.0;
        idx += 1 ;
      }
    });
    print('end selectStatistic => aver10Statistics.lengh : ${temp.length}');
    
    return temp;
  }
  @override
  void initState() {
    super.initState();
    futureFile = loadAsset();
    _seriesPieData = List<charts.Series<Task, String>>();
    _seriesPieData2 = List<charts.Series<LottoStatistics, String>>();
    sumStatistics = List<int>();
    aver10Statistics = List<LottoStatistics>();
    selectStatistic2(minStage, maxStage)
      .then((onValue){
        print('then.. onValue : $onValue');
        var temp2 = charts.Series(
          id:'chart2',
          data : temp2222,
          colorFn: (LottoStatistics lotto, _) => charts.ColorUtil.fromDartColor(lotto.colorval),
          domainFn: (LottoStatistics lotto, _) => lotto.domain,
          measureFn: (LottoStatistics lotto, _) => lotto.average,
          labelAccessorFn: (LottoStatistics row, _) => '${row.average}',
        );
        setState(() {
          _seriesPieData2 = null;
          
        });
      });
    pieData = [
      new Task('1~10번', 35.8, Color(0xff1c39bb)),
      new Task('11~20번', 8.3, Color(0xffe52b50)),
      new Task('21~31번', 10.8, Color(0xff00ff7f)),
      new Task('31~41번', 15.6, Color(0xfffdee00)),
      new Task('41~45번', 19.2, Color(0xffffae42)),
    ];

    _seriesPieData.add(
      charts.Series(
        data:pieData,
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Daily Task',
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      )
    );
    print('aver10Statistics.Length : ${aver10Statistics.length}');
    
    // var temp2 = [
    //   new LottoStatistics('1~10번', 135.8, Color(0xff1c39bb)),
    //   new LottoStatistics('11~20번', 8.3, Color(0xffe52b50)),
    //   new LottoStatistics('21~31번', 10.8, Color(0xff00ff7f)),
    //   new LottoStatistics('31~41번', 15.6, Color(0xfffdee00)),
    //   new LottoStatistics('41~45번', 19.2, Color(0xffffae42)),
    // ];

    // print('_seriesPieData2.add.. : ${aver10Statistics.length}');

  }
  @override
  Widget build(BuildContext context) {
    print('build start??');
    return Scaffold(
      appBar: AppBar(
        title: Text("역대 로또 통계"),
      ),
      body : Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text('$minStage ~ $maxStage 회차 구역별 통계', style : TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),

                Container(
                  width: double.infinity,
                  height: 300,
                  child: charts.PieChart(
                    _seriesPieData2,
                    animate: true,
                    animationDuration: Duration(milliseconds: 800),
                    behaviors: [
                      new charts.DatumLegend
                      (
                        position: charts.BehaviorPosition.end, 
                        outsideJustification: charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxColumns: 2,
                        cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                             color : charts.MaterialPalette.blue.shadeDefault,
                             fontFamily: 'Gerogia',
                             fontSize: 11
                        ),
                      ),
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 100,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator( 
                          labelPosition: charts.ArcLabelPosition.inside
                        )
                      ]
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('회차 :'),
                    RaisedButton(
                      child: Text(minStage.toString()),
                      onPressed: () {
                        _showDialogMinNumberPicker();
                      },
                    ),
                    Text('~'),
                    RaisedButton(
                      child : Text(maxStage.toString()),
                      onPressed: () {
                        _showDialogMaxNumberPicker();
                      },
                    ),
                  ],
                ),
                RaisedButton(
                  child: Text('testPi'),
                  onPressed: (){
                    print('onPresed!!');
                    print('pieData.Length:${pieData.length}');
                    pieData[2].taskvalue += 10;
                  },

                ),
                Text('Future test'),
                // FutureBuilder<int>(
                //   future : selectStatistic(1,10),
                //   builder: (context, snapshot){
                //     if(snapshot.hasData){
                //       return Text(snapshot.data.toString());
                //     } else if(snapshot.hasError){
                //       return Text("${snapshot.error}");
                //     }
                //     return CircularProgressIndicator();
                //   }
                // )
              ],
            ),
          ),
        ),
      ),
      // body: Center(
      //   child: FutureBuilder<String>(
      //     future: futureFile,
      //     builder: (context, snapshot) {
      //       if(snapshot.hasData){
      //         return Text(snapshot.data);
      //       } else if(snapshot.hasError){
      //         return Text("${snapshot.error}");
      //       }
      //       return CircularProgressIndicator();
      //     },)
      // )
    );
  }
}

// // Asynchronous
// Future<String> createOrderMessage() async {
//   var order = await getUserOrder();
//   return 'Your order is: $order';
// }

// Future<String> getUserOrder() {
// // Imagine that this function is
// // more complex and slow.
//   return
//     Future.delayed(
//         Duration(seconds: 4), () => 'Large Latte');
// }

// // Asynchronous
// test() async {
//   print('Fetching user order...');
//   print(await createOrderMessage());
// }



class StatmentExample extends StatelessWidget {
  Widget build(BuildContext context) {
    return Text(
      (
        () {
          if(true){
            return "tis true";
          }
          else 
            return "anything but true";
          }
      )()
    );
  }
}


class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class LottoStatistics{
  String domain;
  double average;
  Color colorval;
  LottoStatistics(this.domain, this.average, this.colorval);
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/res/history_1.txt');
}




// def selectStatistic(min, max):
//     total = 0
//     for i in range(min, max + 1):
//         total += 6
//         filePath = './db/history_{}.txt'.format(i)
//         print('filePath : ', filePath)
//         data = StrReadFile(filePath)
//         obj = json.loads(data)
//         LottoLists.append(obj)
//         for key, value in obj.items():
//             # print('key : {}, value : {}'.format(key, value))
//             if key in ['drwtNo1', 'drwtNo2', 'drwtNo3', 'drwtNo4', 'drwtNo5', 'drwtNo6']:
//                 sumStatisticLists[value] += 1
//     return total



// total_number = selectStatistic(900, 906)