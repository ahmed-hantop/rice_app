import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rice_delivery/core/domain/entity/data_handel_model.dart';

enum AndroidStore { googlePlayStore, apkPure }

class AppVersionChecker {
  final String? currentVersion;
  final String? appId;
  final AndroidStore androidStore;

  AppVersionChecker({
    this.currentVersion,
    this.appId,
    this.androidStore = AndroidStore.googlePlayStore,
  });

  Future<AppCheckerResult> checkUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersionValue = currentVersion ?? packageInfo.version;
    final packageNameValue = appId ?? packageInfo.packageName;

    if (kIsWeb) {
      return AppCheckerResult(
        currentVersionValue,
        null,
        '',
        'Web platform is not supported for store version checks.',
      );
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      switch (androidStore) {
        case AndroidStore.apkPure:
          return _checkApkPureStore(currentVersionValue, packageNameValue);
        case AndroidStore.googlePlayStore:
          return _checkPlayStore(currentVersionValue, packageNameValue);
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _checkAppleStore(currentVersionValue, packageNameValue);
    } else {
      return AppCheckerResult(
        currentVersionValue,
        null,
        '',
        'The target platform "${defaultTargetPlatform.name}" is not yet supported by this package.',
      );
    }
  }

  Future<AppCheckerResult> _checkAppleStore(
    String currentVersion,
    String packageName,
  ) async {
    String? errorMsg;
    String? newVersion;
    String? url;
    final uri = Uri.https('itunes.apple.com', '/lookup', {
      'bundleId': packageName,
    });
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        errorMsg =
            "Can't find an app in the Apple Store with the id: $packageName";
      } else {
        final jsonObj = jsonDecode(response.body);
        final List results = jsonObj['results'];
        if (results.isEmpty) {
          errorMsg =
              "Can't find an app in the Apple Store with the id: $packageName";
        } else {
          newVersion = jsonObj['results'][0]['version']?.toString();
          url = jsonObj['results'][0]['trackViewUrl']?.toString();
        }
      }
    } catch (e) {
      errorMsg = '$e';
    }
    return AppCheckerResult(currentVersion, newVersion, url, errorMsg);
  }

  Future<AppCheckerResult> _checkPlayStore(
    String currentVersion,
    String packageName,
  ) async {
    String? errorMsg;
    String? newVersion;
    String? url;
    final uri = Uri.https('play.google.com', '/store/apps/details', {
      'id': packageName,
    });
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        errorMsg =
            "Can't find an app in the Google Play Store with the id: $packageName";
      } else {
        final patterns = [
          r'"[0-9]+":\[\[\["([0-9]+\.[0-9]+\.[0-9]+)"\]\]',
          r',\[\[\["([0-9,\.]*)"\]\],',
          r'Current Version[^0-9]*([0-9]+\.[0-9]+\.[0-9]+)',
        ];

        for (final pattern in patterns) {
          final match = RegExp(pattern).firstMatch(response.body);
          if (match != null && match.group(1) != null) {
            newVersion = match.group(1);
            url = uri.toString();
            break;
          }
        }

        if (newVersion == null) {
          errorMsg = 'Unable to parse version from Google Play Store response';
        }
      }
    } catch (e) {
      errorMsg = '$e';
    }
    return AppCheckerResult(currentVersion, newVersion, url, errorMsg);
  }

  Future<PostDataHandle<AppCheckerResult>> checkAndUpdateVersion() async {
    final storeData = await checkUpdate();
    // printInfo(
    //   '**********************************************************************************',
    // );
    // printInfo('canUpdate: ${storeData.canUpdate}');
    // printInfo('currentVersion: ${storeData.currentVersion}');
    // printInfo('storeVersion: ${storeData.newVersion}');
    // printInfo('StoreURL: ${storeData.appURL}');
    // printInfo('errorMessage: ${storeData.errorMessage}');
    // printInfo(
    //   '**********************************************************************************',
   // );

    if (storeData.canUpdate) {
      return PostDataHandle(data: storeData);
    }
    return const PostDataHandle(hasError: true);
  }
}

Future<AppCheckerResult> _checkApkPureStore(
  String currentVersion,
  String packageName,
) async {
  String? errorMsg;
  String? newVersion;
  String? url;
  final uri = Uri.https('apkpure.com', '$packageName/$packageName');
  try {
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      errorMsg = "Can't find an app in the ApkPure Store with the id: $packageName";
    } else {
      final match = RegExp(
        r'<div class="details-sdk"><span itemprop="version">(.*?)<\/span>for Android<\/div>',
      ).firstMatch(response.body);
      if (match != null && match.group(1) != null) {
        newVersion = match.group(1)!.trim();
        url = uri.toString();
      } else {
        errorMsg = 'Unable to parse version from ApkPure Store response';
      }
    }
  } catch (e) {
    errorMsg = '$e';
  }
  return AppCheckerResult(currentVersion, newVersion, url, errorMsg);
}

class AppCheckerResult {
  final String currentVersion;
  final String? newVersion;
  final String? appURL;
  final String? errorMessage;

  AppCheckerResult(
    this.currentVersion,
    this.newVersion,
    this.appURL,
    this.errorMessage,
  );

  bool get canUpdate =>
      _shouldUpdate(currentVersion, (newVersion ?? currentVersion));

  bool _shouldUpdate(String versionA, String versionB) {
    final versionNumbersA =
        versionA.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final versionNumbersB =
        versionB.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final versionASize = versionNumbersA.length;
    final versionBSize = versionNumbersB.length;
    final maxSize = math.max(versionASize, versionBSize);

    for (int i = 0; i < maxSize; i++) {
      if ((i < versionASize ? versionNumbersA[i] : 0) >
          (i < versionBSize ? versionNumbersB[i] : 0)) {
        return false;
      } else if ((i < versionASize ? versionNumbersA[i] : 0) <
          (i < versionBSize ? versionNumbersB[i] : 0)) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    return 'Current Version: $currentVersion\nNew Version: $newVersion\nApp URL: $appURL\ncan update: $canUpdate\nerror: $errorMessage';
  }
}
