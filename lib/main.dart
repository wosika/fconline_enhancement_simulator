import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:lottie/lottie.dart';

import 'enhancement_simulator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //去除debug显示
      debugShowCheckedModeBanner: false,
      title: 'FC Online 强化模拟系统',
      theme: ThemeData(
        //黑夜模式

        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: EnhancementPage(),
    );
  }
}

class EnhancementPage extends StatefulWidget {
  @override
  _EnhancementPageState createState() => _EnhancementPageState();
}

class _EnhancementPageState extends State<EnhancementPage> {
  String playerName = '';
  int currentLevel = 1;
  List<Map<String, dynamic>> logs = [];
  bool animating = false;
  bool isSuccess = false;
  AnimationController? controller;
  String buttonText = '开始强化'; // 添加按钮文本
  // ConfettiController? _controllerBottomCenter;
  // ConfettiController? _controllerTopCenter;

  @override
  void initState() {
    super.initState();
    // _controllerBottomCenter =
    //     ConfettiController(duration: const Duration(seconds: 3));
    // _controllerTopCenter =
    //     ConfettiController(duration: const Duration(days: 1));
  }

  @override
  void dispose() {
    // _controllerBottomCenter?.dispose();
    // _controllerTopCenter?.dispose();
    super.dispose();
  }

  Color getLevelColor(int level) {
    if (level == 1) {
      return Color(0xFF616161);
    } else if (level >= 2 && level <= 4) {
      return Color(0xFFB28675);
    } else if (level >= 5 && level <= 7) {
      return Color(0xFFC5C8C9);
    } else {
      return Colors.yellow[700]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FC Online 强化模拟系统'),
      ),
      body: Stack(
        children: [
          if(isSuccess)
            _buildSuccessAnim(),
          _buildBody(),
          /*   _buildSuccessAnim(),
          _buildSuccessTopAnim(),*/
        ],
      ),



    );
  }

  _buildBody() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: '请输入姓名'),
            onChanged: (value) {
              playerName = value;
            },
          ),
          SizedBox(height: 20),
          DropdownButton<int>(
            value: currentLevel,
            onChanged: (int? newValue) {
              setState(() {
                currentLevel = newValue!;
              });
            },
            items: List.generate(9, (index) => index + 1)
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('强化等级 $value',
                    style: TextStyle(color: getLevelColor(value))),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          ShakeWidget(
            duration: Duration(seconds: 3),
            shakeConstant: ShakeDefaultConstant2(),
            autoPlay: false,
            enableWebMouseHover: false,
            onController: (controller) {
              this.controller = controller;
            },
            child: ElevatedButton(
              onPressed: () async {
                if (!animating) {
                  controller?.repeat();
                  setState(() {
                    animating = true;
                    this.isSuccess = false;
                    buttonText = '正在强化'; // 修改按钮文本为“正在强化”
                  });
                  await Future.delayed(Duration(seconds: 3));
                  final result = EnhancementSimulator.simulateSingleEnhancement(
                      playerName, currentLevel);
                  setState(() {
                    currentLevel = result['currentLevel'];
                    var isSuccess = result['log'].contains('成功');
                    logs.insert(0, {
                      'log': result['log'],
                      'success': isSuccess,
                    });

                    if (isSuccess) {
                      this.isSuccess = true;
                      // _controllerBottomCenter?.play();
                      // _controllerTopCenter?.play();
                    }

                    animating = false;
                    controller?.reset();
                    buttonText = '开始强化'; // 恢复按钮文本为原始值
                  });
                }
              },
              child: Text(buttonText), // 使用 buttonText 作为按钮文本
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: logs.map((log) {
                  return Text(
                    log['log'],
                    style: TextStyle(
                        color: log['success'] ? Colors.green : Colors.red),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildSuccessAnim() {
    return Stack(
      children: [
        Align(alignment: Alignment.topLeft,child: Lottie.asset('assets/loop.json',fit: BoxFit.cover)),
        Align(alignment: Alignment.topRight,child: Lottie.asset('assets/loop.json',fit: BoxFit.cover)),
        Align(alignment: Alignment.topLeft,child: Lottie.asset('assets/shot.json',fit: BoxFit.cover,repeat: false)),
        Align(alignment: Alignment.topRight,child: Lottie.asset('assets/shot.json',fit: BoxFit.cover,repeat: false)),


      ],
    );
  }

// _buildSuccessAnim() {
//   return Align(
//     alignment: Alignment.bottomCenter,
//     child: ConfettiWidget(
//       confettiController: _controllerBottomCenter!,
//       blastDirection: -pi / 2,
//       emissionFrequency: 0.0001,
//       numberOfParticles: 500,
//       maxBlastForce: 1000,
//       minBlastForce: 200,
//       gravity: 0.1,
//       minimumSize: Size(10, 10),
//       maximumSize: Size(15, 15),
//       blastDirectionality: BlastDirectionality.explosive,
//     ),
//   );
// }

// _buildSuccessTopAnim() {
//   return Align(
//     alignment: Alignment.topCenter,
//     child: ConfettiWidget(
//       confettiController: _controllerTopCenter!,
//       blastDirection: -pi / 2,
//       emissionFrequency: 0.001,
//       numberOfParticles: 100,
//       maxBlastForce: 2,
//       minBlastForce: 1,
//       shouldLoop: true,
//       gravity: 0.1,
//       minimumSize: Size(100, 100),
//       maximumSize: Size(100, 100),
//       blastDirectionality: BlastDirectionality.explosive,
//     ),
//   );
// }
}
