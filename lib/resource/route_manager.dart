import 'package:flutter/material.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/main.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/pages/create_device/create_device_page.dart';
import 'package:manage_devices_app/pages/create_request/create_request_page.dart';
import 'package:manage_devices_app/pages/create_user/create_user_page.dart';
import 'package:manage_devices_app/pages/detail_device/detail_device_page.dart';
import 'package:manage_devices_app/pages/device_manage/device_manage_page.dart';
import 'package:manage_devices_app/pages/login/login_page.dart';
import 'package:manage_devices_app/pages/main_page/main_page.dart';
import 'package:manage_devices_app/pages/my_device/my_device_page.dart';
import 'package:manage_devices_app/pages/request_detail/request_detail_page.dart';
import 'package:manage_devices_app/pages/search_result/search_result_page.dart';
import 'package:manage_devices_app/services/init/init_page.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/loginRoute";
  static const String myDevice = "/myDevice";
  static const String searchResultRoute = "/searchResultRoute";
  static const String authWrapper = "/authWrapper";
  static const String detailRequestRoute = "/detailRequestRoute";
  static const String mainRoute = "/mainRoute";
  static const String initRoute = "/initRoute";
  static const String createDeviceRoute = "/createDeviceRoute";
  static const String createUserRoute = "/createUserRoute";
  static const String detailDeviceRoute = "/detailDeviceRoute";
  static const String createRequestRoute = "/createRequestRoute ";
  static const String manageDeviceRoute = "/manageDeviceRoute ";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.mainRoute:
        return MaterialPageRoute(
          builder: (context) => const MainPage(),
        );
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );
      case Routes.createRequestRoute:
        return MaterialPageRoute(
          builder: (context) => const CreateRequestPage(),
        );
      case Routes.manageDeviceRoute:
        return MaterialPageRoute(
          builder: (context) => const DeviceManagePage(),
        );
      case Routes.createUserRoute:
        return MaterialPageRoute(
          builder: (context) => const CreateUserPage(),
        );
      case Routes.detailRequestRoute:
        final args = routeSettings.arguments as Request;
        return MaterialPageRoute(
          builder: (context) => DetailRequestPage(request: args),
        );
      case Routes.authWrapper:
        return MaterialPageRoute(
          builder: (context) => const AuthWrapper(),
        );
      case Routes.createDeviceRoute:
        return MaterialPageRoute(
          builder: (context) => const CreateDevicePage(),
        );
      case Routes.myDevice:
        return MaterialPageRoute(
          builder: (context) => const MyDevicePage(),
        );
      case Routes.detailDeviceRoute:
        final args = routeSettings.arguments as Device;
        return MaterialPageRoute(
          builder: (context) => DetailDevicePage(device: args),
        );
      case Routes.searchResultRoute:
        final args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) =>
              SearchResultPage(keywork: args[0], data: args[1] as List<Device>),
        );
      case Routes.initRoute:
        return MaterialPageRoute(
          builder: (context) => const InitPage(),
        );
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(AppString.noRouteFound),
        ),
        body: const Center(child: Text(AppString.noRouteFound)),
      ),
    );
  }
}
