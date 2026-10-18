import 'package:rice_delivery/core/config/flavor_config.dart';
import 'package:rice_delivery/core/constants/api_endpoints.dart';
import 'package:rice_delivery/core/constants/app_end_points.dart';

/// Sets [FlavorConfig.appFlavor] and syncs API hosts before [runApp].
void bootstrapFlavor(Flavor flavor) {
  FlavorConfig.appFlavor = flavor;
  ApiEndpoints.setBaseUrl = FlavorConfig.baseUrl;
  ApiEndPoints.setAppDomain = FlavorConfig.baseUrl;
}
