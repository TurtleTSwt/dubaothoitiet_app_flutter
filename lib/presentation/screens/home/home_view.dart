import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/injection/service_locator.dart';
import '../../../logic/weather/weather_cubit.dart';
import '../../../logic/weather/weather_state.dart';
import '../../../logic/settings/settings_cubit.dart';
import '../../../logic/settings/settings_state.dart';
import '../../../utils/helpers/weather_icon_mapper.dart';
import '../../../utils/helpers/temp_convert.dart';
import '../../../utils/constants/app_strings.dart';
import '../search/search_view.dart';
import '../settings/settings_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WeatherCubit>(),
      child: const _HomeContent(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  Future<void> _openSearch(BuildContext context) async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchView()),
    );

    if (selectedLocation != null && context.mounted) {
      context.read<WeatherCubit>().fetchWeather(selectedLocation);
    }
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem app đang ở chế độ Sáng hay Tối để đổi màu nền tổng thể
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F6FA);

    // Lắng nghe settings hiện tại (đơn vị nhiệt độ + ngôn ngữ) từ SettingsCubit
    // (SettingsCubit đã được provide ở tầng app.dart, chỉ cần watch lại ở đây)
    final settingsState = context.watch<SettingsCubit>().state;
    final tempUnit = settingsState.tempUnit;
    final strings = AppStrings.of(settingsState.language);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          strings.homeTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          // Nút lưu/bỏ lưu thành phố đang xem — chỉ hiện khi đã có dữ liệu weather
          BlocBuilder<WeatherCubit, WeatherState>(
            buildWhen: (previous, current) => current is WeatherLoaded,
            builder: (context, weatherState) {
              if (weatherState is! WeatherLoaded) return const SizedBox.shrink();

              final location = weatherState.weather.location;
              final settingsCubit = context.watch<SettingsCubit>();
              final isSaved = settingsCubit.isCitySaved(location);

              return IconButton(
                icon: Icon(isSaved ? Icons.star : Icons.star_border),
                color: isSaved ? Colors.amber : null,
                onPressed: () => settingsCubit.toggleSavedCity(location),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _openSearch(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherInitial) {
            return _buildEmptyState(context, strings);
          }

          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WeatherError) {
            return _buildErrorState(context, state.message, strings);
          }

          if (state is WeatherLoaded) {
            final weather = state.weather;

            // Responsive LayoutBuilder: < 800px dùng Mobile, >= 800px dùng Web
            return LayoutBuilder(
              builder: (context, constraints) {
                final isWeb = constraints.maxWidth >= 800;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: isWeb
                          ? _buildWebLayout(context, weather, isDarkMode, tempUnit, strings)
                          : _buildMobileLayout(context, weather, isDarkMode, tempUnit, strings),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ==================== BỐ CỤC MOBILE (1 CỘT DỌC) ====================
  Widget _buildMobileLayout(BuildContext context, dynamic weather, bool isDarkMode,
      TempUnit tempUnit, AppStrings strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCurrentWeatherCard(context, weather, isDarkMode, tempUnit, strings),
        const SizedBox(height: 20),
        _buildHourlySection(context, weather, isDarkMode, tempUnit, strings),
        const SizedBox(height: 20),
        _buildDailySection(context, weather, isDarkMode, tempUnit, strings),
        const SizedBox(height: 24),
      ],
    );
  }

  // ==================== BỐ CỤC WEB / DESKTOP (2 CỘT) ====================
  Widget _buildWebLayout(BuildContext context, dynamic weather, bool isDarkMode,
      TempUnit tempUnit, AppStrings strings) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cột trái: Thời tiết hiện tại
        Expanded(
          flex: 5,
          child: _buildCurrentWeatherCard(context, weather, isDarkMode, tempUnit, strings),
        ),
        const SizedBox(width: 24),
        // Cột phải: Dự báo giờ + Dự báo 7 ngày
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHourlySection(context, weather, isDarkMode, tempUnit, strings),
              const SizedBox(height: 20),
              _buildDailySection(context, weather, isDarkMode, tempUnit, strings),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== THẺ THỜI TIẾT HIỆN TẠI ====================
  Widget _buildCurrentWeatherCard(BuildContext context, dynamic weather, bool isDarkMode,
      TempUnit tempUnit, AppStrings strings) {
    final current = weather.current;
    final cardBg = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          // Tên thành phố + Icon location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.redAccent, size: 22),
              const SizedBox(width: 8),
              Text(
                weather.location.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Icon thời tiết chính
          Text(
            WeatherIconMapper.getIconEmoji(current.weatherCode),
            style: const TextStyle(fontSize: 72),
          ),
          const SizedBox(height: 12),

          // Nhiệt độ lớn — dùng TempConverter để hiện đúng °C hoặc °F
          Text(
            TempConverter.format(current.temp, tempUnit),
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w200,
              color: textColor,
            ),
          ),

          // Mô tả thời tiết
          Text(
            WeatherIconMapper.getDescription(current.weatherCode),
            style: TextStyle(
              fontSize: 18,
              color: subTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: isDarkMode ? Colors.white12 : Colors.black12),
          const SizedBox(height: 16),

          // feelsLike - humidity - windSpeed
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat(
                strings.feelsLike,
                TempConverter.format(current.feelsLike ?? current.temp, tempUnit),
                textColor,
                subTextColor,
              ),
              _buildMiniStat(
                strings.humidity,
                '${current.humidity}%',
                textColor,
                subTextColor,
              ),
              _buildMiniStat(
                strings.wind,
                '${current.windSpeed} m/s',
                textColor,
                subTextColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color textColor, Color labelColor) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: labelColor, fontSize: 13)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: textColor),
        ),
      ],
    );
  }

  // ==================== DỰ BÁO 24 GIỜ (CÓ SCROLLBAR NGANG) ====================
  Widget _buildHourlySection(BuildContext context, dynamic weather, bool isDarkMode,
      TempUnit tempUnit, AppStrings strings) {
    final List hourlyList = weather.hourly ?? [];
    final cardBg = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    final itemBg = isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03);

    String formatHour(dynamic rawTime) {
      if (rawTime == null) return "00:00";
      final str = rawTime.toString();
      if (str.length >= 16) {
        return str.substring(11, 16);
      }
      return str;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.hourlyTitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 125,
            child: hourlyList.isEmpty
                ? Center(
              child: Text(
                strings.noHourlyData,
                style: const TextStyle(color: Colors.grey),
              ),
            )
                : Builder(
              builder: (context) {
                final scrollController = ScrollController();

                return Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  radius: const Radius.circular(8),
                  thickness: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ListView.separated(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: hourlyList.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final item = hourlyList[index];
                        return Container(
                          width: 75,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 4,
                          ),
                          decoration: BoxDecoration(
                            color: itemBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                formatHour(item.time),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subTextColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                WeatherIconMapper.getIconEmoji(item.weatherCode),
                                style: const TextStyle(fontSize: 24),
                              ),
                              Text(
                                TempConverter.format(item.temp, tempUnit),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==================== DỰ BÁO 7 NGÀY (LIST DỌC) ====================
  Widget _buildDailySection(BuildContext context, dynamic weather, bool isDarkMode,
      TempUnit tempUnit, AppStrings strings) {
    final List dailyList = weather.daily ?? [];
    final cardBg = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    final dividerColor = isDarkMode ? Colors.white12 : Colors.black12;

    String formatDate(dynamic rawDate, int index) {
      if (rawDate == null) return "Ngày ${index + 1}";
      final str = rawDate.toString();
      if (str.length >= 10) {
        return str.substring(0, 10);
      }
      return str;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.dailyTitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          dailyList.isEmpty
              ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                strings.noDailyData,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          )
              : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dailyList.length,
            separatorBuilder: (_, __) => Divider(color: dividerColor, height: 24),
            itemBuilder: (context, index) {
              final item = dailyList[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      formatDate(item.date, index),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      WeatherIconMapper.getIconEmoji(item.weatherCode),
                      style: const TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${TempConverter.format(item.tempMax, tempUnit)} / ${TempConverter.format(item.tempMin, tempUnit)}',
                      style: TextStyle(
                        fontSize: 15,
                        color: subTextColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ==================== EMPTY & ERROR STATES ====================
  Widget _buildEmptyState(BuildContext context, AppStrings strings) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_queue, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            strings.emptyStateTitle,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _openSearch(context),
            icon: const Icon(Icons.search),
            label: Text(strings.searchCityButton),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, AppStrings strings) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              '${strings.errorPrefix}$message',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.redAccent, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _openSearch(context),
              child: Text(strings.retryButton),
            ),
          ],
        ),
      ),
    );
  }
}