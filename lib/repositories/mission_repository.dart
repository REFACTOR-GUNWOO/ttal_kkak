import 'package:shared_preferences/shared_preferences.dart';

class MissionRepository {
  static final MissionRepository _instance = MissionRepository._internal();

  // 미션 버전 관리 (미션 조건이 변경될 때마다 버전 업)
  static const int _version = 4;

  // SharedPreferences 키 값들
  String get _completedKey => 'completed_v$_version';
  String get _regTsKey => 'reg_ts_v$_version';

  factory MissionRepository() {
    return _instance;
  }

  MissionRepository._internal();

  /// 미션 완료 상태와 완료 시간을 저장
  Future<void> updateMissionStatus(bool isCompleted) async {
    final prefs = await SharedPreferences.getInstance();

    // 미션 완료 상태 저장
    await prefs.setBool(_completedKey, isCompleted);

    // 완료 시간 저장 (완료된 경우에만)
    if (isCompleted) {
      await prefs.setString(_regTsKey, DateTime.now().toIso8601String());
    } else {
      // 미션이 미완료 상태로 변경되면 완료 시간도 삭제
      await prefs.remove(_regTsKey);
    }
  }

  /// 미션 완료 상태 조회
  Future<bool> isMissionCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_completedKey) ?? false;
  }

  /// 미션 완료 시간 조회
  Future<DateTime?> getCompletedDateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final regTs = prefs.getString(_regTsKey);

    if (regTs == null) return null;

    try {
      return DateTime.parse(regTs);
    } catch (e) {
      return null;
    }
  }

  /// 모든 미션 데이터 초기화
  Future<void> clearMissionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedKey);
    await prefs.remove(_regTsKey);
  }
}
