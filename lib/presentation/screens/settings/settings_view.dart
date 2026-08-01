import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/settings/settings_cubit.dart';
import '../../../logic/settings/settings_state.dart';
import '../../../utils/constants/app_strings.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        final strings = AppStrings.of(state.language);

        return Scaffold(
          appBar: AppBar(
            title: Text(strings.settingsTitle),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Mục đổi đơn vị nhiệt độ (°C / °F)
              ListTile(
                title: Text(strings.sectionTempUnit),
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
                title: Text(strings.sectionTheme),
                subtitle: Text(
                  state.themeMode == AppThemeMode.dark
                      ? strings.themeDark
                      : state.themeMode == AppThemeMode.light
                      ? strings.themeLight
                      : strings.themeSystem,
                ),
                trailing: Switch(
                  value: state.themeMode == AppThemeMode.dark,
                  onChanged: (isDark) {
                    cubit.changeThemeMode(
                      isDark ? AppThemeMode.dark : AppThemeMode.light,
                    );
                  },
                ),
              ),
              const Divider(),

              // 3. Mục đổi ngôn ngữ (Tiếng Việt / English)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  strings.sectionLanguage,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: state.language == AppLanguage.vi
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => cubit.changeLanguage(AppLanguage.vi),
                      child: Text(strings.languageVi),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: state.language == AppLanguage.en
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => cubit.changeLanguage(AppLanguage.en),
                      child: Text(strings.languageEn),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}