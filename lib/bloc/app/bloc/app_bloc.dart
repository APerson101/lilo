import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lilo/repositories/user_repo.dart';
import 'package:lilo/views/main_home/main_home.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

import 'app.dart';

enum ThemeType {
  dark,
  light,
}

class AppBloc extends Bloc<AppEvent, AppState> {
  UserRepository user;
  PageType pg = PageType.dashboard;
  AppBloc(this.user) : super(AppState(currentPage: PageType.dashboard));

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is ChangePage && event.newPage != state.currentPage) {
      // print(event.newPage);
      state.currentPage = event.newPage;
      pg = event.newPage;
      // print(pg);
      yield AppState(currentPage: pg);
    }
    if (event is ToggleTheme) {
      print('old theme: ${state.currentTheme}');
      state.currentTheme = (state.currentTheme == ThemeType.dark)
          ? ThemeType.light
          : ThemeType.dark;
      print('new theme: ${state.currentTheme}');
    }
  }
}
