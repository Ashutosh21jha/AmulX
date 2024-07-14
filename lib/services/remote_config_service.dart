import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<bool> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      return await _remoteConfig.fetchAndActivate();
    } catch (e) {
      return false;
    }
  }

  bool get lastFetchAttemptSuccess {
    return _remoteConfig.lastFetchStatus == RemoteConfigFetchStatus.success;
  }

  String get cashfreeApi {
    return _remoteConfig.getString('cashfree_api');
  }

  String get amulXVersion {
    return _remoteConfig.getString('AmulX_version');
  }

  String get cashfreeSecret {
    return _remoteConfig.getString('cashfree_secret');
  }

  String get cashfreeApiVersion {
    return _remoteConfig.getString('cashfree_api_version');
  }
}
