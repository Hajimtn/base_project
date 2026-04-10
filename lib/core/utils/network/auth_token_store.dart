import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Storage adapter for access/refresh token in local box.
class AuthTokenStore {
  static const String accessTokenStorageKey = 'auth_access_token';
  static const String refreshTokenStorageKey = 'auth_refresh_token';

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  String? _accessTokenCache;
  String? _refreshTokenCache;
  bool _initialized = false;

  GetStorage get _box =>
      Get.isRegistered<GetStorage>() ? Get.find<GetStorage>() : GetStorage();

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    _accessTokenCache = _normalize(
      await _readFromSecureOrBox(accessTokenStorageKey),
    );
    _refreshTokenCache = _normalize(
      await _readFromSecureOrBox(refreshTokenStorageKey),
    );

    _initialized = true;
  }

  String? get accessToken {
    return _accessTokenCache ??
        _normalize(_box.read<String>(accessTokenStorageKey));
  }

  String? get refreshToken {
    return _refreshTokenCache ??
        _normalize(_box.read<String>(refreshTokenStorageKey));
  }

  Future<void> saveAccessToken(String token) async {
    final String normalized = token.trim();
    _accessTokenCache = normalized;
    await _box.write(accessTokenStorageKey, normalized);
    await _writeSecure(accessTokenStorageKey, normalized);
  }

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    if (refreshToken != null && refreshToken.trim().isNotEmpty) {
      final String normalized = refreshToken.trim();
      _refreshTokenCache = normalized;
      await _box.write(refreshTokenStorageKey, normalized);
      await _writeSecure(refreshTokenStorageKey, normalized);
    }
  }

  Future<void> clear() async {
    _accessTokenCache = null;
    _refreshTokenCache = null;
    await _box.remove(accessTokenStorageKey);
    await _box.remove(refreshTokenStorageKey);
    await _deleteSecure(accessTokenStorageKey);
    await _deleteSecure(refreshTokenStorageKey);
  }

  Future<String?> _readFromSecureOrBox(String key) async {
    final String? secure = _normalize(await _readSecure(key));
    if (secure != null) {
      await _box.write(key, secure);
      return secure;
    }
    return _normalize(_box.read<String>(key));
  }

  Future<String?> _readSecure(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeSecure(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (_) {}
  }

  Future<void> _deleteSecure(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (_) {}
  }

  String? _normalize(String? value) {
    if (value == null) {
      return null;
    }
    final String result = value.trim();
    return result.isEmpty ? null : result;
  }
}
