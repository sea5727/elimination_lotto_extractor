import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sprintf/sprintf.dart';


class TestPageResultBalls extends StatefulWidget {
  // final ForceSelection forceSelection;
  final List<List<int>> results;
  final List<Widget> resultsBalls = new List<Widget>();

  TestPageResultBalls(this.results);

  @override
  TestPageResultBallsState createState() => new TestPageResultBallsState(results, resultsBalls); 
}

class TestPageResultBallsState extends State<TestPageResultBalls> {
  List<List<int>> results;
  List<Widget> resultsBalls;
  TestPageResultBallsState(List<List<int>> results, List<Widget> resultsBalls) {
    print('constructor TestPageResultBallsState');
    print('TestPageResultBallsState.length : ' + results.length.toString());
    this.results = results;
    this.resultsBalls = resultsBalls;
  }
  
  @override
  Widget build(BuildContext context) {
    print('results.length : ' + results.length.toString());
    for(int i = 0 ; i < results.length ; i++){
      List<Widget> balls = new List<Widget>();
      for(int j = 0 ; j < this.results[i].length ; j++){
        var ballPath = sprintf('assets/images/ball_%d.jpg', [results[i][j]]);
        balls.add(
          Image.asset(ballPath)
        );
      }
      Widget widget = GridView.count(
        padding: const EdgeInsets.all(5.0),
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 20.0,
        crossAxisCount: 6,
        // physics: ScrollPhysics(), // to disable GridView's scrolling
        shrinkWrap: true,
        children: balls,
      );
      resultsBalls.add(widget);
    }
    print('total result : ' + resultsBalls.length.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("대박을 기원합니다!!!"),
      ),
      body: Center(
        child: new ListView(
          shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: resultsBalls + [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("돌아가기"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }
}