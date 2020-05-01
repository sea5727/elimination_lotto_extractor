import 'package:flutter/material.dart';
import 'File.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/res/history_1.txt');
}

class LottoStatistic extends StatefulWidget {
    @override
  LottoStatisticState createState() => new LottoStatisticState(); 
}

class LottoStatisticState extends State<LottoStatistic> {
  Future<String> futureFile;
  @override
  void initState() {
    super.initState();
    futureFile = loadAsset();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("역대 로또 통계"),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: futureFile,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Text(snapshot.data);
            } else if(snapshot.hasError){
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },)
      )
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

