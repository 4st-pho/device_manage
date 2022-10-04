import 'package:manage_devices_app/helper/shared_preferences.dart';
import 'package:manage_devices_app/resource/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/onbroad_bloc.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_image.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/pages/onbroad/widgets/onbroad_item.dart';
import 'package:manage_devices_app/widgets/custom_button.dart';

class OnbroadPage extends StatefulWidget {
  const OnbroadPage({Key? key}) : super(key: key);

  @override
  State<OnbroadPage> createState() => _OnbroadPageState();
}

class _OnbroadPageState extends State<OnbroadPage> {
  late final OnbroadBloc _onbroadBloc;
  @override
  void initState() {
    _onbroadBloc = context.read<OnbroadBloc>();
    super.initState();
  }

  final PageController _pageController = PageController(initialPage: 0);
  final List<OnroadItem> _listOnbroadItem = [
    const OnroadItem(
        image: AppImage.onbroad1,
        title: AppString.welcome,
        content: AppString.welcomeContent),
    const OnroadItem(
        image: AppImage.onbroad2,
        title: AppString.support,
        content: AppString.supportContent),
    const OnroadItem(
        image: AppImage.onbroad3,
        title: AppString.explore,
        content: AppString.exploreContent),
  ];
  @override
  void dispose() {
    _onbroadBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                onPageChanged: _onbroadBloc.onPageChanged,
                children: _listOnbroadItem,
              ),
            ),
            _buildControlPageView()
          ],
        ),
      ),
    );
  }

  StreamBuilder<int> _buildControlPageView() {
    return StreamBuilder<int>(
      initialData: 0,
      stream: _onbroadBloc.stream,
      builder: (context, snapshot) {
        final currentIndex = snapshot.data ?? 0;

        return Column(
          children: [
            Row(
              children: [
                const Spacer(),
                _buildSelectBox(currentIndex: currentIndex, index: 0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: _buildSelectBox(currentIndex: currentIndex, index: 1),
                ),
                _buildSelectBox(currentIndex: currentIndex, index: 2),
                const Spacer(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                text: _onbroadBloc.isFinish(_listOnbroadItem.length)
                    ? AppString.getStarted
                    : AppString.next,
                onPressed: _onbroadBloc.isFinish(_listOnbroadItem.length)
                    ? () {
                        SharedPreferencesMethod.saveSkipOnbroading();
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.authWrapper);
                      }
                    : () => _onbroadBloc.selectPage(
                          pageController: _pageController,
                          listLength: _listOnbroadItem.length,
                        ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  AnimatedContainer _buildSelectBox({
    required int currentIndex,
    required int index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: currentIndex == index ? 30 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: AppColor.lightBlue,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
