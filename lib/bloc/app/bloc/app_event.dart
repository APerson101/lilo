import 'package:lilo/views/main_home/main_home.dart';

abstract class AppEvent {}

class ChangePage extends AppEvent {
  PageType newPage;
  ChangePage({
    required this.newPage,
  });
}

class DrawMenu extends AppEvent {}

class ToggleTheme extends AppEvent {}
