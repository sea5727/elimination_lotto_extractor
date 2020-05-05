
import 'dart:math';


void test1(double aver01to10, double aver11to20, double aver21to30, double aver31to40, double aver41to45){
  var strAver01to10 = aver01to10.toStringAsPrecision(3);
  var strAver11to20 = aver11to20.toStringAsPrecision(3);
  var strAver21to30 = aver21to30.toStringAsPrecision(3);
  var strAver31to40 = aver31to40.toStringAsPrecision(3);
  var strAver41to45 = aver41to45.toStringAsPrecision(3);

  print(strAver01to10);
  print(strAver11to20);
  print(strAver21to30);
  print(strAver31to40);
  print(strAver41to45);

  var _random = new Random();
  try{
    var temp1 = double.tryParse(strAver01to10);
    var temp2 = double.tryParse(strAver11to20);
    var temp3 = double.tryParse(strAver21to30);
    var temp4 = double.tryParse(strAver31to40);
    var temp5 = double.tryParse(strAver41to45);
    var total = temp1 + temp2 + temp3 + temp4 + temp5;
    total = total * 100;
    
    var randomvalue = _random.nextInt(total.toInt());
    if(randomvalue < temp1 * 100){
      print('randomvalue : ' + randomvalue.toString());
      print('this is 1~10.. ');
    }
    else if(randomvalue < (temp1 + temp2) * 100){
      print('randomvalue : ' + randomvalue.toString());
      print('this is 11~20.. ');      
    }
    else if(randomvalue < (temp1 + temp2 + temp3) * 100){
            print('randomvalue : ' + randomvalue.toString());
      print('this is 21~30.. ');
    }
    else if(randomvalue < (temp1 + temp2 + temp3 + temp4) * 100){
      print('randomvalue : ' + randomvalue.toString());
      print('this is 31~40.. ');
    }
    else if(randomvalue < (temp1 + temp2 + temp3 + temp4 + temp5) * 100){
      print('randomvalue : ' + randomvalue.toString());
      print('this is 41~45.. ');      
    }
    else {
      print('randomvalue : ' + randomvalue.toString());
      print('this is else');
    }

    
  }
  catch(err){
    print(err.toString());
  }
  
} 

void test2(){
  var temp = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
  var _random = new Random();
  var value = _random.nextInt(temp.length);
  print('value : '  + value.toString());
}




int getLottoNumbers(Map checkmap){
  Map checkMap = new Map.from(checkmap);
  int possibleNumbers = 0;
  
  for(var i = 1 ; i <= checkMap.length ; i++){
    if(checkMap[i] == false) // 체크가 안되어있다면 추출할수있는 번호이다.
      possibleNumbers += 1;
  }

  List<int> numbers = [];
  
  checkMap.forEach((key, value){
    // print('key : ' + key.toString() + ' value : ' + value.toString());
    if(value == false) numbers.add(key);
  });

  var _random = new Random();
  
  var max = numbers.length;
  print('max v : ' + max.toString());
  var v = _random.nextInt(max);
  print('random v : ' + v.toString());
  print('get!! : ' + numbers[v].toString());

  return numbers[v];
}


void main() {
  test1(96, 1, 1, 1, 1);
  var clickBall = new Map();
  for(int i = 31 ; i <= 40 ; i++){
    clickBall[i] = false;
  }
  
  var getNum = getLottoNumbers(clickBall);
  print('numbers get : '  + getNum.toString());

  clickBall[getNum] = true;
  var getNum2 = getLottoNumbers(clickBall);
  print('numbers get : '  + getNum2.toString());
}