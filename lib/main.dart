// lib/main.dart

import 'package:flutter/material.dart';

import 'app.dart';
import 'core/injection/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const WeatherApp());
}