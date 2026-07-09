import 'package:package_info_plus/package_info_plus.dart';

/// Reads app version from the installed package.
class AppVersionService {
  AppVersionService._();

  static String version = '1.0.0';
  static String buildNumber = '1';

  static String get fullVersion => '$version+$buildNumber';

  static Future<void> load() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
    buildNumber = info.buildNumber;
  }
}
