import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green,brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home:  EnhancementPage(),
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

  void simulateEnhancement() {
    final result = EnhancementSimulator.simulateSingleEnhancement(playerName, currentLevel);
    setState(() {
      currentLevel = result['currentLevel'];
      logs.insert(0, {
        'log': result['log'],
        'success': result['log'].contains('成功'),
      });
    });
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
        title: Text('Enhancement Simulator'),
      ),
      body: Padding(
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
                  child: Text('强化等级 $value', style: TextStyle(color: getLevelColor(value))),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                simulateEnhancement();
              },
              child: Text('开始强化'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: logs.map((log) {
                    return Text(
                      log['log'],
                      style: TextStyle(color: log['success'] ? Colors.green : Colors.red),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
