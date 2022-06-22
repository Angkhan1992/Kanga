import 'package:flutter/material.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/screens/auth/change_password_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/button_widget.dart';
import 'package:kanga/widgets/common_widget.dart';
import 'package:kanga/widgets/textfield_widget.dart';

class ForgotScreen extends StatefulWidget {
  final String email;

  const ForgotScreen({
    Key? key,
    this.email = '',
  }) : super(key: key);

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  bool _isVerifyCode = false;

  var _emailController = TextEditingController();
  var _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: KangaAppbar(
          title: S.current.forgotPass,
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
                S.current.enterForgotEmail,
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: offsetXMd,
              ),
              KangaTextField(
                controller: _emailController,
                hintText: S.current.usernameOrEmail,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                ),
              ),
              if (_isVerifyCode)
                Column(
                  children: [
                    SizedBox(
                      height: offsetBase,
                    ),
                    KangaTextField(
                      controller: _codeController,
                      hintText: S.current.verifyCode,
                      textInputAction: TextInputAction.go,
                      prefixIcon: Icon(
                        Icons.code,
                        color: Colors.white,
                      ),
                      onSubmitted: (value) => _forgotPass(),
                    ),
                    SizedBox(
                      height: offsetBase,
                    ),
                    Text(
                      S.current.resendCode,
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: KangaColor.kangaButtonBackColor),
                    ),
                  ],
                ),
              SizedBox(
                height: offsetXMd,
              ),
              KangaButton(
                onPressed: () => _forgotPass(),
                btnText: _isVerifyCode
                    ? S.current.submit
                    : S.current.sendCode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _forgotPass() async {
    FocusScope.of(context).unfocus();
    if (_isVerifyCode) {
      var email = _emailController.text;
      var code = _codeController.text;
      if (code.isEmpty) {
        DialogProvider.of(context).showSnackBar(
          S.current.emptyCode,
        );
        return;
      }
      var param = {
        'email': email,
        'code': code,
      };
      var res = await NetworkProvider.of(context).post(
        Constants.header_auth,
        Constants.link_submit_code,
        param,
        isProgress: true,
      );
      if (res['ret'] == 10000) {
        NavigatorProvider.of(context).pushToWidget(
          screen: ChangePasswordScreen(
            email: email,
          ),
          replace: true,
        );
      } else {
        DialogProvider.of(context).showSnackBar(
          res['msg'],
          type: SnackBarType.ERROR,
        );
      }
    } else {
      var email = _emailController.text;
      if (email.isEmpty) {
        DialogProvider.of(context).showSnackBar(
          S.current.emptyEmail,
        );
        return;
      }
      var param = {
        'email': email,
      };
      var res = await NetworkProvider.of(context).post(
        Constants.header_auth,
        Constants.link_send_code,
        param,
        isProgress: true,
      );
      if (res['ret'] == 10000) {
        setState(() {
          _isVerifyCode = true;
        });
      } else {
        DialogProvider.of(context).showSnackBar(
          res['msg'],
          type: SnackBarType.ERROR,
        );
      }
    }
  }
}
