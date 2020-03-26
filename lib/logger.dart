import 'package:fimber/fimber.dart';

void setupLogger({String level = "ALL"}) {
  Fimber.plantTree(DebugTree(useColors: true));
  const listOfLevels = ["D", "I", "W", "E"];
  int index = listOfLevels.indexOf(level);

  if (index == -1) {
    return;
  }

  int i = 0;
  while (i <= index) {
    Fimber.mute(listOfLevels[i]);
    i++;
  }
}
