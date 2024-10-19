import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ConfigData {
  ConfigData._();

  static final remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> initialize() async {
    try {
      await remoteConfig.setDefaults(const {
        'appName': 'Kasir SUPER',
        'privacyPolicy': 'https://kodingworks.io/privacy-policy/',
        'maxVersion': 1,
        'minVersion': 1,
        'uxCamKey': 'nw6p6qhpdccjd9y',
        'appStoreUrl':
            'https://play.google.com/store/apps/details?id=io.kodingworks.superkasir',
        'xenditKey':
            'xnd_development_s7lg2wx6gEol5STm2YSo6lWa2UMu39c1fjtFotpVAWvqIKYdi48SkfdxG96u7A',
      });

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: const Duration(minutes: 1),
      ));

      await remoteConfig.fetchAndActivate();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static String getValue(String key) {
    return remoteConfig.getValue(key).asString();
  }

  static Future<AppVersionType> checkUpdate() async {
    try {
      final maxVersion = remoteConfig.getInt('maxVersion');
      final minVersion = remoteConfig.getInt('minVersion');

      final packageInfo = await PackageInfo.fromPlatform();

      final nowVersion = int.parse(packageInfo.buildNumber);

      log('''
        NOW VERSION : $nowVersion
        MIN VERSION : $minVersion
        MAX VERSION : $maxVersion
      ''', name: 'VERSION APP');

      if (nowVersion < minVersion) {
        return AppVersionType.expired;
      } else if (nowVersion < maxVersion) {
        return AppVersionType.haveUpdate;
      } else {
        return AppVersionType.upToDate;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
