import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/screens/success_screen.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/button_widget.dart';
import 'package:kanga/widgets/common_widget.dart';
import 'package:kanga/widgets/textfield_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;

  const ChangePasswordScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var _isShow = false;
  var _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: KangaAppbar(
          title: S.current.changePassword,
        ),
        body: Padding(
          padding: const EdgeInsets.all(offsetXMd),
          child: Column(
            children: [
              Image.asset(
                'assets/images/circularLogo.png',
                width: 120.0,
              ),
              SizedBox(
                height: offsetXMd,
              ),
              Text(
                S.current.enterNewPassword,
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: offsetXMd,
              ),
              KangaTextField(
                controller: _passController,
                hintText: S.current.newPassword,
                textInputAction: TextInputAction.done,
                obscureText: _isShow,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      _isShow = !_isShow;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.0),
                    child: SvgPicture.asset(
                        _isShow
                            ? 'assets/icons/ic_eye_shown.svg'
                            : 'assets/icons/ic_eye_hidden.svg',
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: offsetXLg,
              ),
              KangaButton(
                onPressed: () => _changePassword(),
                btnText: S.current.changePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() async {
    var password = _passController.text;
    if (password.length < 6) {
      DialogProvider.of(context).showSnackBar(
        S.current.validPassword,
        type: SnackBarType.ERROR,
      );
      return;
    }
    var param = {
      'email': widget.email,
      'password': password,
    };
    var res = await NetworkProvider.of(context).post(
      Constants.header_auth,
      Constants.link_change_password,
      param,
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      NavigatorProvider.of(context).pushToWidget(
        screen: SuccessScreen(
          title: S.current.changePassword,
          description: S.current.changePassDesc,
        ),
        replace: true,
      );
    } else {
      DialogProvider.of(context).showSnackBar(
        res['msg'],
        type: SnackBarType.ERROR,
      );
    }
  }
}
