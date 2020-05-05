import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:convert/convert.dart'as convert;
import 'SelectLottoPage.dart';

// path = 'assets/res/history_1.txt'
Future<String> loadAsset(path) async {
  return await rootBundle.loadString(path);
}




class LottoStatistics{
  String domain;
  double average;
  Color color;
  LottoStatistics(this.domain, this.average, this.color);
}


class LottoStatistic extends StatefulWidget {
    @override
  LottoStatisticState createState() => new LottoStatisticState(); 
}






class LottoStatisticState extends State<LottoStatistic> {
  Future<List<charts.Series<LottoStatistics, String>>> _futureSeriesPieData() async {
    return await getStatistic(this.minStage, this.maxStage);
  }
  static const int MIN_STAGE = 1;
  static const int MAX_STAGE = 906;
  int minStage = MAX_STAGE;
  int maxStage = MAX_STAGE;
  List<double> resultlist;


  Future<List<charts.Series<LottoStatistics, String>>> getStatistic(int min, int max) async {
    print('Future start');
    sleep(Duration(seconds: 1));
    print('Future end');
    resultlist = [];
    List<dynamic> originalResults = [];
    
    int total = 0;
    for(int i = min ; i < max + 1; i++){
      
      total += 6;
      var path = 'assets/res/history_$i.txt';
      // print('search... path : ' + path);
      var data = await loadAsset(path);
      Map<String, dynamic> obj = jsonDecode(data);
      originalResults.add(obj);
    }

    var sumStatistics = List<int>.filled(46, 0);
    var keys = ['drwtNo1', 'drwtNo2', 'drwtNo3', 'drwtNo4', 'drwtNo5', 'drwtNo6'];
    for(int i = 0 ; i < originalResults.length ; i++){ // 횟수차만큼 반복
      Map<String, dynamic> obj = originalResults[i];
      obj.forEach((key, value) {
        // print('i : ' + i.toString() + 'key : ' + key.toString() + ' value : ' + value.toString());
        if(keys.contains(key)){
          sumStatistics[value] += 1;
        }
      });
      // print('succ.. sum : ' + i.toString());
    }
    int idx = 0;
    int prevNum = 0;
    int curNum = 0;
    double divaver = 0.0;
    var results = List<LottoStatistics>();
    var colors = [
      Color(0xffda9100), 
      Color(0xff4169e1), 
      Color(0xffe52b50), 
      Color(0xff254855),
      Color(0xff00ff7f)];
      
    var checks = [10, 20, 30, 40, 45];
    sumStatistics.asMap().forEach((numbers, values){
      // print('total : idx:' + numbers.toString() + 'value : '  + values.toString());
      divaver += (values.toDouble() / total) * 100;
      if(checks.contains(numbers)){
        
        divaver = double.parse(divaver.toStringAsPrecision(3));
        prevNum = curNum;
        curNum = numbers;
        results.add(
          new LottoStatistics('$prevNum번~$curNum번', divaver, colors[idx])
        );
        resultlist.add(divaver);
        // print('$prevNum번~$curNum번 aver : ' + divaver.toString());
        divaver = 0.0;
        idx += 1;
      }
    });
    print('divaver : ');
    for(int i = 0 ; i < resultlist.length; i++){
      print('divaver : ' + i.toString() + ' : ' + resultlist[i].toString());
    }
    var statistic = new List<charts.Series<LottoStatistics, String>>();
    statistic.add(
      charts.Series(
        data : results,
        domainFn: (LottoStatistics lotto, _) => lotto.domain + '\n' + lotto.average.toStringAsFixed(2) + '%',
        measureFn: (LottoStatistics lotto, _) => lotto.average,
        colorFn: (LottoStatistics lotto, _) => charts.ColorUtil.fromDartColor(lotto.color),
        id: 'Daily Task223',
        labelAccessorFn: (LottoStatistics row, _) => '${row.domain}\n${row.average}%',
      )
    );
    return statistic;
  }

  void setMinStage(int value){
    if(value <= this.maxStage)
      setState(() {
        print('setState...');
        this.minStage = value;  
      });
    else{
      //alarm ??
    }
  }
  void setMaxStage(int value){
    if(value >= this.minStage){
      setState(() {
        print('setState...');
        this.maxStage = value;        
      });

    }
    else{
      //alarm
    }
  }
  void _showDialogNumberPicker(stage, void Function(int) callback) {
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          title: new Text("회차를 선택하세요"),
          minValue: MIN_STAGE,
          maxValue: MAX_STAGE,
          initialIntegerValue: stage,
        );
      }
    ).then((int value){
      if (value != null) {
        setState(() {
          callback(value);
        });
      }
    });
  }
  void _showDialogSetAverage(String title, int idx) {
    showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.decimal(
          minValue: 1,
          maxValue: 100,
          title: new Text(title),
          initialDoubleValue: pageSelectBallsState.currentaverage[idx],
        );
      }
    ).then((onValue){
      if(onValue != null){
        setState(() {
          pageSelectBallsState.currentaverage[idx] = onValue;
        });
      }
    });
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build start');

    return Scaffold(
      appBar: AppBar(
        title: Text("역대 로또 통계"),
      ),
      body : Padding(
        padding: EdgeInsets.all(8.0),
        child : Container(
          child : Center(
            child : Column(
              children: <Widget>[
                Text('$minStage ~ $maxStage 회차 구역별 통계', style : TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                Container(
                  width: double.infinity,
                  height: 300,
                  child: FutureBuilder<List<charts.Series<LottoStatistics, String>>>(
                    future : _futureSeriesPieData(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        print('snapshot.hasData...length?' + snapshot.data.length.toString());
                        return charts.PieChart(
                          snapshot.data,
                          animate: true,
                          animationDuration: Duration(milliseconds: 500),
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
                        );
                      }
                      else {
                        return Text('snapshot.Dont.. hasData');
                      }
                    },
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
                        _showDialogNumberPicker(this.minStage, setMinStage);
                      },
                    ),
                    Text('~'),
                    RaisedButton(
                      child : Text(maxStage.toString()),
                      onPressed: () {
                        _showDialogNumberPicker(this.maxStage, setMaxStage);
                      },
                    ),
                  ],
                ),
                Expanded(
                  flex: 5,
                  child : Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Text('1. 회차별, 구간별 통계를 조회 할 수 있습니다.'),
                        SizedBox(height: 5,),
                        Text('2. 확률을 참고하여 직접 전략을 구성하세요.'),
                        SizedBox(height: 5,),
                        Text('3. 회차별 확률을 복사하여 사용 할수도 있습니다.'),
                        SizedBox(height: 5,),
                        Text('4. 아래 버튼들을 클릭해 확률을 입력해보세요'),
                      ],
                    )
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child : Column(
                          children: <Widget>[
                            Text('1번~10번'),
                            RaisedButton(
                              child: Text('${pageSelectBallsState.currentaverage[0]}'),
                              onPressed: (){
                                _showDialogSetAverage('1~10 자리수 확률을 설정하세요',0);
                                pageSelectBallsState.mytest = 10;
                              },
                            ),
                          ],
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child : Column(
                          children: <Widget>[
                            Text('11번~20번'),
                            RaisedButton(
                              child: Text('${pageSelectBallsState.currentaverage[1]}'),
                              onPressed: (){
                                _showDialogSetAverage('11~20 자리수 확률을 설정하세요',1);
                              },
                            ),
                          ],
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child : Column(
                          children: <Widget>[
                            Text('21번~30번'),
                            RaisedButton(
                              child: Text('${pageSelectBallsState.currentaverage[2]}'),
                              onPressed: (){
                                _showDialogSetAverage('21~30 자리수 확률을 설정하세요',2);
                              },
                            ),
                          ],
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child : Column(
                          children: <Widget>[
                            Text('31번~40번'),
                            RaisedButton(
                              child: Text('${pageSelectBallsState.currentaverage[3]}'),
                              onPressed: (){
                                _showDialogSetAverage('31~40 자리수 확률을 설정하세요',3);
                              },
                            ),
                          ],
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child : Column(
                          children: <Widget>[
                            Text('41번~45번'),
                            RaisedButton(
                              child: Text('${pageSelectBallsState.currentaverage[4]}'),
                              onPressed: (){
                                _showDialogSetAverage('41~45 자리수 확률을 설정하세요',4);
                              },
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex : 1,
                  child : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('통계 적용하기'),
                        onPressed: (){
                          setState(() {
                            pageSelectBallsState.currentaverage = resultlist;
                            // pageSelectBallsState.currentaverage = [22.2, 22.2, 22.2, 22.2, 11.1];
                          });
                        },
                      ),
                      SizedBox(
                        width: 20,  
                      ),
                      RaisedButton(
                        child: Text('초기설정 되돌리기'),
                        onPressed: (){
                          setState(() {
                            pageSelectBallsState.currentaverage = [22.2, 22.2, 22.2, 22.2, 11.1];                            
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          )
        ),
      ),
    );
  }
}
