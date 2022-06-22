import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/screens/auth/login_screen.dart';
import 'package:kanga/screens/auth/signup_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/widgets/button_widget.dart';
import 'package:kanga/widgets/dots_indicator.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset('assets/videos/kanga.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    _videoController!.setLooping(true);
    _videoController!.play();
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
    _videoController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            _videoController!.value.isInitialized
                ? Positioned.fill(
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  )
                : Container(),
            PageView.builder(
              physics: ClampingScrollPhysics(),
              controller: _pageController,
              itemCount: 3,
              onPageChanged: (index) {
                if (mounted) {
                  setState(() {
                    // _currentIndex = index;
                  });
                }
              },
              itemBuilder: (BuildContext context, int index) {
                return index == 0
                    ? _buildFirstSlide()
                    : index == 1
                        ? _secondChild()
                        : _thirdChild();
              },
            ),
            Column(
              children: [
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: DotsIndicator(
                    controller: _pageController,
                    itemCount: 3,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: offsetXLg),
                  child: KangaButton(
                    btnColor: KangaColor().pinkButtonColor(1),
                    onPressed: () {
                      NavigatorProvider(context)
                          .pushToWidget(screen: SignupScreen());
                    },
                    btnText: S.current.getStarted,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                // Log in screen
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: offsetXLg),
                  child: KangaButton(
                      btnColor: Color(0xFF8D99B2).withOpacity(0.28),
                      borderWidth: 2,
                      btnText: S.current.login.toUpperCase(),
                      onPressed: () {
                        NavigatorProvider(context)
                            .pushToWidget(screen: LoginScreen());
                      },
                      textColor: Colors.white),
                ),
                SizedBox(
                  height: offsetXMd,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstSlide() {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.40),
          height: double.infinity,
          width: double.infinity,
        ),
        Column(
          children: [
            Expanded(
              child: Container(),
              flex: 2,
            ),
            Image.asset(
              'assets/images/circularLogo.png',
              width: 120,
            ),
            Expanded(
              child: Container(),
              flex: 3,
            ),
            Text(
              S.current.ownYourBalance,
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              S.current.experienceToStay,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Container(),
              flex: 3,
            ),
            Container(
              height: 179,
              color: Colors.transparent,
            )
          ],
        ),
      ],
    );
  }

  Widget _secondChild() {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.84),
          height: double.infinity,
          width: double.infinity,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FittedBox(
                child: Text(
                  S.current.decreaseYourRisk,
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            _buildImage(
                img: 'assets/images/balance.png',
                imageTitle: S.current.balance),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildImage(
                  img: 'assets/images/strength.png',
                  imageTitle: S.current.strength,
                ),
                _buildImage(
                  img: 'assets/images/mobility.png',
                  imageTitle: S.current.mobility,
                ),
              ],
            ),
            Container(
              height: 179,
              color: Colors.transparent,
            )
          ],
        ),
      ],
    );
  }

  Widget _buildImage({required String img, required String imageTitle}) {
    return Column(
      children: [
        Image.asset(
          img,
          width: 100,
          height: 100,
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          imageTitle.toUpperCase(),
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _thirdChild() {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.84),
          height: double.infinity,
          width: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                S.current.takeLife,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                S.current.getRealTime,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                S.current.followOnDemand,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              Container(
                height: 179,
                color: Colors.transparent,
              )
            ],
          ),
        ),
      ],
    );
  }
}
