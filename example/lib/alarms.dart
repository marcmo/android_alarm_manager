import 'dart:isolate';
import 'dart:ui';
import 'package:android_alarm_manager/android_alarm_manager.dart';

final int periodicAlarmID = 0;
final int oneShotAlarmID = 1;
int _alarmExpiredCount = 0;
const String kAlarmManagerExamplePortName = 'simple_alarm_manager_example_port';

void printLocalMessage(String msg) {
  print("[${DateTime.now()}](${Isolate.current.hashCode}) $msg");
}

void increaseAlarmCount() {
  _alarmExpiredCount++;
  final SendPort mainSendPort =
      IsolateNameServer.lookupPortByName(kAlarmManagerExamplePortName);
  mainSendPort?.send(_alarmExpiredCount);
}

void periodicCallback() {
  increaseAlarmCount();
  printLocalMessage("$_alarmExpiredCount. periodic Alarm!!!");
}

void oneShotCallback() {
  increaseAlarmCount();
  printLocalMessage("oneShot Alarm!!!");
  triggerOneShotAlarm();
}

Future<void> stopAlarms() async {
  print('stop all alarms');
  await AndroidAlarmManager.cancel(periodicAlarmID);
  await AndroidAlarmManager.cancel(oneShotAlarmID);
}

Future<void> triggerOneShotAlarm() async {
  await AndroidAlarmManager.oneShot(
      const Duration(minutes: 15), oneShotAlarmID, oneShotCallback,
      wakeup: true, exact: true);
}

Future<void> startAlarms() async {
  print('startAlarms');
  triggerOneShotAlarm();
}
