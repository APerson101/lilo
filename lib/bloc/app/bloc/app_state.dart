import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lilo/bloc/app/bloc/app.dart';
import 'package:lilo/views/main_home/main_home.dart';

class AppState extends Equatable {
  PageType currentPage;
  AppState({
    required this.currentPage,
  });
  bool sideDrawerState = false;

  ThemeType currentTheme = ThemeType.light;

  @override
  List<Object?> get props => [currentPage, currentTheme];
}
