import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/remote_config_service.dart';

class RemoteConfigState {
  final bool flashSaleEnabled;
  final double freeShippingThreshold;
  final bool maintenanceMode;
  final String promoBannerText;

  const RemoteConfigState({
    required this.flashSaleEnabled,
    required this.freeShippingThreshold,
    required this.maintenanceMode,
    required this.promoBannerText,
  });

  factory RemoteConfigState.fromService() {
    return RemoteConfigState(
      flashSaleEnabled: RemoteConfigService.flashSaleEnabled,
      freeShippingThreshold: RemoteConfigService.freeShippingThreshold,
      maintenanceMode: RemoteConfigService.maintenanceMode,
      promoBannerText: RemoteConfigService.promoBannerText,
    );
  }
}

final remoteConfigProvider = Provider<RemoteConfigState>((ref) {
  return RemoteConfigState.fromService();
});

final remoteConfigRefreshProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    await RemoteConfigService.refresh();
    ref.invalidate(remoteConfigProvider);
  };
});
