import 'dart:math';

void main() {
  final name = 'icon 罗纳尔多'; // 用户输入的姓名
  var currentLevel = 7; // 初始强化等级

  // while (currentLevel < 10) {
  //   final result = simulator.simulateSingleEnhancement(name, currentLevel);
  //   currentLevel = result['currentLevel'];
  //   final log = result['log'];
  //   print(log);
  // }
  final result = EnhancementSimulator.simulateSingleEnhancement(name, currentLevel);
  currentLevel = result['currentLevel'];
  final log = result['log'];
  print(log);
 // print('$name 的强化已完成，最终等级为 $currentLevel');
}

class EnhancementSimulator {
  static final List<double> probabilities = [
    1.0, // 1->2的概率是100%
    0.81, // 2->3的概率是81%
    0.64, // 3->4的概率是64%
    0.50, // 4->5的概率是50%
    0.26, // 5->6的概率是26%
    0.15, // 6->7的概率是15%
    0.07, // 7->8的概率是7%
    0.04, // 8->9的概率是4%
    0.02, // 9->10的概率是2%
  ];

  static Map<String, dynamic> simulateSingleEnhancement(
      String playerName, int currentLevel) {
    final enhancementLog = StringBuffer();

    final random = Random().nextDouble(); // 生成一个0到1之间的随机数
    final successProbability = probabilities[currentLevel - 1];

    if (random < successProbability) {
      currentLevel++;
      enhancementLog.write('$playerName 强化成功，当前等级 $currentLevel');
    } else {
      // 强化失败
      final downLevel = max(1, Random().nextInt(currentLevel)); // 降级不低于等级1
      currentLevel = downLevel;
      enhancementLog.write('$playerName 强化失败，降级至等级 $currentLevel');
    }
    enhancementLog.writeln();

    return {'currentLevel': currentLevel, 'log': enhancementLog.toString()};
  }
}
