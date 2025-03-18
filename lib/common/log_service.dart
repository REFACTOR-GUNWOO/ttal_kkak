import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class LogService {
  Future<void> log(LogType type, String screenName, String? buttonName,
      Map<String, Object> parameters) async {
    if (kDebugMode) {
      parameters['debug'] = "true";
    }
    if (type == LogType.click_button && buttonName == null) {
      throw ArgumentError('buttonName must not be null');
    }
    // 로그를 기록하는 코드
    await FirebaseAnalytics.instance.logEvent(
      name: type.name, // ✅ 이벤트 이름
      parameters: {
        ...parameters,
        'screen_name': screenName,
        if (buttonName != null) 'button_name': buttonName
      },
    );
  }
}

enum LogType { click_button, view_screen, error }
