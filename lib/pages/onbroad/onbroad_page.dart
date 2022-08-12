import 'package:flutter/material.dart';
import '../../bloc/onbroad_bloc.dart';
import '../../constants/app_color.dart';
import '../../widgets/custom_button.dart';

class OnbroadPage extends StatefulWidget {
  const OnbroadPage({Key? key}) : super(key: key);

  @override
  State<OnbroadPage> createState() => _OnbroadPageState();
}

class _OnbroadPageState extends State<OnbroadPage> {
  final _onbroadBloc = OnbroadBloc();
  final PageController _pageController = PageController(initialPage: 0);
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
                children: _onbroadBloc.listOnbroadItem,
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
        final currentIndex = snapshot.data!;
        return Column(
          children: [
            Row(
              children: [
                const Spacer(),
                _buildSelectBox(currentIndex: currentIndex, index: 0),
                const SizedBox(width: 5),
                _buildSelectBox(currentIndex: currentIndex, index: 1),
                const SizedBox(width: 5),
                _buildSelectBox(currentIndex: currentIndex, index: 2),
                const Spacer(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                text: _onbroadBloc.isFinish ? 'Get Started' : 'Next',
                onPressed: () => _onbroadBloc.selectPage(
                  pageController: _pageController,
                  context: context,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  AnimatedContainer _buildSelectBox(
      {required int currentIndex, required int index}) {
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
