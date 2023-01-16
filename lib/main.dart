import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(primaryColor: Colors.pinkAccent) ,home: demo(),);
  }
}

class demo extends StatefulWidget {
  @override
  demoState createState() => demoState();
}

class demoState extends State<demo> {

  TextEditingController heightController=TextEditingController();
  TextEditingController weightController=TextEditingController();
  double result1=0.0;
  double  h=0,w=0;
  String? bmi_status;
  bool validateh=false, validatew=false;
  DateTime selectedDateTime = DateTime.now();

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(appBar: AppBar(title: Text("BMI計算機"),
      centerTitle: true,
      backgroundColor: Colors.greenAccent,),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //輸入身高
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '請輸入身高',
                hintText: 'cm',
                errorText: validateh? "不得為空":null,
                icon: Icon(Icons.trending_up),
              ),
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 20),
            //輸入體重
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '請輸入體重',
                hintText: 'Kg',
                errorText: validatew? "不得為空":null,
                icon: Icon(Icons.trending_down),
              ),
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //時間選擇
              ElevatedButton(
                onPressed: () async {
                  var result_d = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000, 01),
                    lastDate: DateTime(2023, 12),
                  );
                  if (result_d != null) {
                    setState(() {
                      selectedDateTime = result_d;
                    });
                  }
                },
                child: const Text('日期選擇器', style: TextStyle(color: Colors.white),),
              ),
              SizedBox(width: 15),
              //計算按鈕
              ElevatedButton(
                child: Text("計算", style: TextStyle(color: Colors.white),),
                onPressed: () {
                  setState(() {
                    heightController.text.isEmpty? validateh=true:validateh=false;
                    weightController.text.isEmpty? validatew=true:validatew=false;
                  });
                  calculateBMI();
                },
                style: ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20)),
              ),
            ],
          ),
            SizedBox(height: 15),
            //表格
            Table(
              border: TableBorder.all(),
              columnWidths: <int, FixedColumnWidth>{
                0: FixedColumnWidth(100),
                1: FixedColumnWidth(50),
                2: FixedColumnWidth(50),
                3: FixedColumnWidth(50),
                4: FixedColumnWidth(50)
              },
              textDirection: TextDirection.rtl,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(children: <Widget>[
                  Text("日期"),
                  Text("狀態"),
                  Text("BMI值"),
                  Text("體重"),
                  Text("身高"),
                ]),
                TableRow(children: <Widget>[
                  Text(selectedDateTime.toString().substring(0,11)),
                  Text("$bmi_status"),
                  Text("${result1?.toStringAsFixed(2)}"),
                  Text(weightController.text),
                  Text(heightController.text),
                ]),
              ],
            ),
            //折線圖
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 10),
                child: LineChart(
                  LineChartData(
                    minX: 1,
                    minY: 10,
                    maxX: 5,
                    maxY: 35,
                    lineBarsData: [
                      LineChartBarData(
                        color: Colors.green,
                        isCurved: false,
                        //以下為設定FlSpot(x座標,y座標)之數值
                        spots: [
                          //FlSpot(3, result1.toDouble()),
                          FlSpot(1, 18.5),
                          FlSpot(5, 18.5),
                          FlSpot(5, 24),
                          FlSpot(1, 24),
                        ],
                      ),
                      LineChartBarData(
                        color: Colors.yellow,
                        isCurved: false,
                        //以下為設定FlSpot(x座標,y座標)之數值
                        spots: [
                          FlSpot(3, result1.toDouble()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calculateBMI() {
    double h=double.parse(heightController.text)/100;
    double w=double.parse(weightController.text);
    double result=w/(h*h);
    result1=result;
    if (result1<18.5) {
      bmi_status="過輕...";
    }
    else if (result1>24) {
      bmi_status="過重!";
    }
    else { bmi_status="正常~"; }
    setState(() {});
  }

}
