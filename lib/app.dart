import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection/service_locator.dart';
import 'logic/settings/settings_cubit.dart';
import 'logic/settings/settings_state.dart';
import 'presentation/screens/home/home_view.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Cung cấp SettingsCubit ở tầng cao nhất của App
    return BlocProvider(
      create: (_) => sl<SettingsCubit>(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Dự báo thời tiết',
            debugShowCheckedModeBanner: false,

            // --- THÊM 2 DÒNG NÀY ĐỂ FLUTTER BIẾT MÀU SÁNG/TỐI ---
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            // ---------------------------------------------------

            // 2. Lắng nghe themeMode từ state để đổi giao diện Light/Dark
            themeMode: switch (state.themeMode) {
              AppThemeMode.light => ThemeMode.light,
              AppThemeMode.dark => ThemeMode.dark,
              _ => ThemeMode.system,
            },

            // Đưa HomeView làm trang chủ chuẩn của app
            home: const HomeView(),
          );
        },
      ),
    );
  }
}