import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class NetworkInfo {
  Future<bool> get isConnected;

  Stream<bool> get onConnectivityChanged;
}

final class ConnectivityNetworkInfo implements NetworkInfo {
  const ConnectivityNetworkInfo(
    this._connectivity, {
    this.lookupHost = 'example.com',
    this.lookupTimeout = const Duration(seconds: 2),
  });

  final Connectivity _connectivity;
  final String lookupHost;
  final Duration lookupTimeout;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();

    if (!_hasNetworkTransport(results)) {
      return false;
    }

    return _canResolveInternetHost();
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged
        .asyncMap((_) => isConnected)
        .distinct();
  }

  static bool _hasNetworkTransport(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  Future<bool> _canResolveInternetHost() async {
    try {
      final addresses = await InternetAddress.lookup(
        lookupHost,
      ).timeout(lookupTimeout);
      return addresses.any((address) => address.rawAddress.isNotEmpty);
    } on Object {
      return false;
    }
  }
}
