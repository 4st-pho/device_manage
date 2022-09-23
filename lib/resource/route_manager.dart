import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/dashbroad_bloc.dart';
import 'package:manage_devices_app/bloc/devices_bloc/create_device_bloc.dart';
import 'package:manage_devices_app/bloc/devices_bloc/detail_device_bloc.dart';
import 'package:manage_devices_app/bloc/devices_bloc/edit_device_bloc.dart';
import 'package:manage_devices_app/bloc/devices_bloc/manage_device_bloc.dart';
import 'package:manage_devices_app/bloc/devices_bloc/provide_device_bloc.dart';
import 'package:manage_devices_app/bloc/main_page_bloc.dart';
import 'package:manage_devices_app/bloc/request_bloc/create_request_bloc.dart';
import 'package:manage_devices_app/bloc/request_bloc/detail_request_bloc.dart';
import 'package:manage_devices_app/bloc/search_bloc/search_bloc.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/main.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/pages/admin/dashboard_page.dart';
import 'package:manage_devices_app/pages/create_device/create_device_page.dart';
import 'package:manage_devices_app/pages/create_request/create_request_page.dart';
import 'package:manage_devices_app/pages/create_user/create_user_page.dart';
import 'package:manage_devices_app/pages/detail_device/detail_device_page.dart';
import 'package:manage_devices_app/pages/edit_device/edit_device_page.dart';
import 'package:manage_devices_app/pages/login/login_page.dart';
import 'package:manage_devices_app/pages/main_page/main_page.dart';
import 'package:manage_devices_app/pages/manage_device/manage_device_page.dart';
import 'package:manage_devices_app/pages/my_device/my_device_page.dart';
import 'package:manage_devices_app/pages/provide_device/provide_device_page.dart';
import 'package:manage_devices_app/pages/request/request_page.dart';
import 'package:manage_devices_app/pages/request_detail/detail_request_page.dart';
import 'package:manage_devices_app/pages/search_result/search_result_page.dart';
import 'package:manage_devices_app/services/splash/splash_page.dart';
import 'package:provider/provider.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/loginRoute";
  static const String myDevice = "/myDevice";
  static const String requestRoute = "/requestRoute";
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
  static const String editDeviceRoute = "/editDeviceRoute ";
  static const String provideDeviceRoute = "/provideDeviceRoute ";
  static const String dashboardPage = "/dashboardPage ";
  static const String showErrorRoute = "/showErrorRoute ";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.mainRoute:
        return MaterialPageRoute(
            builder: (context) => Provider<MainPageBloc>(
                  create: (context) => MainPageBloc(),
                  dispose: (_, prov) => prov.dispose(),
                  child: const MainPage(),
                ),
            settings: routeSettings);
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
          settings: routeSettings,
        );
      case Routes.createRequestRoute:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider<CreateRequestBloc>(
                create: (context) => CreateRequestBloc(),
                dispose: (_, prov) => prov.dispose(),
              ),
            ],
            child: const CreateRequestPage(),
          ),
          settings: routeSettings,
        );
      case Routes.manageDeviceRoute:
        return MaterialPageRoute(
          builder: (context) => Provider<ManageDeviceBloc>(
            create: (context) => ManageDeviceBloc(),
            dispose: (_, prov) => prov.dispose(),
            child: const ManageDevicePage(),
          ),
          settings: routeSettings,
        );
      case Routes.createUserRoute:
        return MaterialPageRoute(
          builder: (context) => const CreateUserPage(),
          settings: routeSettings,
        );
      case Routes.detailRequestRoute:
        final args = routeSettings.arguments as Request;
        return MaterialPageRoute(
          builder: (context) => Provider<DetailRequestBloc>(
            create: (context) => DetailRequestBloc(),
            dispose: (_, prov) => prov.dispose(),
            child: DetailRequestPage(request: args),
          ),
          settings: routeSettings,
        );
      case Routes.authWrapper:
        return MaterialPageRoute(
          builder: (context) => const AuthWrapper(),
          settings: routeSettings,
        );
      case Routes.createDeviceRoute:
        return MaterialPageRoute(
          builder: (context) => Provider<CreateDeviceBloc>(
            create: (context) => CreateDeviceBloc(),
            dispose: (_, prov) => prov.dispose(),
            child: const CreateDevicePage(),
          ),
          settings: routeSettings,
        );
      case Routes.myDevice:
        return MaterialPageRoute(
          builder: (context) => const MyDevicePage(),
          settings: routeSettings,
        );
      case Routes.detailDeviceRoute:
        final args = routeSettings.arguments as Device;
        return MaterialPageRoute(
          builder: (context) => Provider<DetailDeviceBloc>(
            create: (context) => DetailDeviceBloc(),
            dispose: (_, prov) => prov.dispose(),
            child: DetailDevicePage(device: args),
          ),
          settings: routeSettings,
        );
      case Routes.searchResultRoute:
        final args = routeSettings.arguments as SearchBloc;
        return MaterialPageRoute(
          builder: (context) => Provider<SearchBloc>.value(
            value: args,
            builder: (context, _) {
              return const SearchResultPage();
            },
          ),
          settings: routeSettings,
        );
      case Routes.editDeviceRoute:
        final args = routeSettings.arguments as Device;
        return MaterialPageRoute(
          builder: (context) => MultiProvider(providers: [
            Provider<EditDeviceBloc>(
              create: (context) => EditDeviceBloc(),
              dispose: (_, prov) => prov.dispose(),
            ),
          ], child: EditDevicePage(device: args)),
          settings: routeSettings,
        );
      case Routes.provideDeviceRoute:
        final args = routeSettings.arguments as Device;
        return MaterialPageRoute(
          builder: (context) => Provider<ProvideDeviceBloc>(
            create: (context) => ProvideDeviceBloc(),
            dispose: (_, prov) => prov.dispose(),
            child: ProvideDevicePage(device: args),
          ),
          settings: routeSettings,
        );
      case Routes.initRoute:
        return MaterialPageRoute(
          builder: (context) => const SplashPage(),
          settings: routeSettings,
        );
      case Routes.requestRoute:
        return MaterialPageRoute(
          builder: (context) => const RequestPage(),
          settings: routeSettings,
        );
      case Routes.dashboardPage:
        return MaterialPageRoute(
          builder: (context) => Provider<DashbroadBloc>(
            create: (context) => DashbroadBloc(),
            child: const DashboardPage(),
            dispose: (context, prov) => prov.dispose(),
          ),
          settings: routeSettings,
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
