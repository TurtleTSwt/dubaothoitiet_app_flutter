 // import enum TempUnit của Dev A (bạn gõ TempUnit để IDE tự import nhé)

import '../../logic/settings/settings_state.dart';

class TempConverter {
  /// Chuyển đổi nhiệt độ từ Celsius gốc sang đơn vị user đang chọn
  static double convert(double celsius, TempUnit unit) {
    if (unit == TempUnit.fahrenheit) {
      return (celsius * 9 / 5) + 32;
    }
    return celsius;
  }

  /// Trả về chuỗi đẹp để hiển thị lên UI (VD: "28°C" hoặc "82°F")
  static String format(double celsius, TempUnit unit) {
    final value = convert(celsius, unit).round();
    final symbol = unit == TempUnit.celsius ? '°C' : '°F';
    return '$value$symbol';
  }
}