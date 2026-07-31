import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/settings/settings_cubit.dart';
import '../../../logic/settings/settings_state.dart';

class SettingsView extends StatelessWidget {
  // Đã sửa lại constructor chuẩn, không còn "required Center body"
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Mục đổi đơn vị nhiệt độ (°C / °F)
              ListTile(
                title: const Text('Đơn vị nhiệt độ'),
                subtitle: Text(
                  state.tempUnit == TempUnit.celsius ? 'Celsius (°C)' : 'Fahrenheit (°F)',
                ),
                trailing: Switch(
                  value: state.tempUnit == TempUnit.fahrenheit,
                  onChanged: (isFahrenheit) {
                    cubit.changeTempUnit(
                      isFahrenheit ? TempUnit.fahrenheit : TempUnit.celsius,
                    );
                  },
                ),
              ),
              const Divider(),

              // 2. Mục đổi giao diện (Sáng / Tối)
              ListTile(
                title: const Text('Giao diện tối (Dark Mode)'),
                subtitle: const Text('Bật để đổi sang giao diện màu tối'),
                trailing: Switch(
                  value: state.themeMode == AppThemeMode.dark,
                  onChanged: (isDark) {
                    cubit.changeThemeMode(
                      isDark ? AppThemeMode.dark : AppThemeMode.light,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}