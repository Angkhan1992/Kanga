import 'package:flutter/material.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/screens/auth/complete_profile_screen.dart';
import 'package:kanga/screens/main_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/button_widget.dart';
import 'package:kanga/widgets/common_widget.dart';
import 'package:kanga/widgets/textfield_widget.dart';

class VerifyScreen extends StatefulWidget {
  final String email;

  const VerifyScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  var _code = '';
  var _isLoginLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _autoValidate = AutovalidateMode.always;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: KangaAppbar(
          title: S.current.emailVerify,
        ),
        body: Padding(
          padding: EdgeInsets.all(offsetXMd),
          child: Column(
            children: [
              Text(
                S.current.welcomeToApp,
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(
                height: offsetXLg,
              ),
              Image.asset(
                'assets/images/circularLogo.png',
                width: 120.0,
              ),
              SizedBox(
                height: offsetXLg,
              ),
              Text(
                S.current.sendVerifyCode + '\n${widget.email}',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: offsetXLg,
              ),
              _buildForm(),
              SizedBox(
                height: offsetXLg,
              ),
              _isLoginLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        KangaColor().pinkButtonColor(1),
                      ),
                    )
                  : KangaButton(
                      btnText: S.current.submit.toUpperCase(),
                      onPressed: () => _onSubmit(),
                    ),
              Spacer(),
              Text(
                S.current.notGotCode,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontSize: 16.0),
              ),
              SizedBox(
                height: offsetSm,
              ),
              InkWell(
                onTap: () => _onResendCode(),
                child: Text(
                  S.current.resendCode,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.white,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidate,
      child: KangaTextField(
        textInputAction: TextInputAction.done,
        hintText: S.current.verifyCode,
        keyboardType: TextInputType.name,
        prefixIcon: Icon(
          Icons.code,
          size: offsetMd,
          color: KangaColor().textGreyColor(1),
        ),
        onSaved: (code) {
          _code = code!;
        },
        validator: (code) {
          return code!.length == 6 ? null : S.current.invalidCode;
        },
      ),
    );
  }

  void _onSubmit() async {
    _formKey.currentState!.save();
    _autoValidate = AutovalidateMode.always;
    if (_code.length != 6) return;

    var param = {
      'email': widget.email,
      'code': _code,
    };
    setState(() {
      _isLoginLoading = true;
    });
    var result = await NetworkProvider.of(context)
        .post(Constants.header_auth, Constants.link_submit_code, param);
    setState(() {
      _isLoginLoading = false;
    });
    if (result['ret'] == 10000) {
      var token = result['result']['token'];
      await PrefProvider().setToken(token);
      var _currentUser = UserModel.fromJson(result['result']);
      await _currentUser.save();

      if (_currentUser.step == '0') {
        NavigatorProvider.of(context).pushToWidget(
          screen: MainScreen(),
          replace: true,
        );
      } else {
        NavigatorProvider.of(context).pushToWidget(
          screen: CompleteProfileScreen(),
          replace: true,
        );
      }
    } else {
      DialogProvider.of(context).showSnackBar(
        result['msg'],
        type: SnackBarType.ERROR,
      );
    }
  }

  void _onResendCode() async {
    var param = {
      'email': widget.email,
    };
    var result = await NetworkProvider.of(context).post(
        Constants.header_auth, Constants.link_resend_code, param,
        isProgress: true);
    DialogProvider.of(context).showSnackBar(
      result['msg'],
      // type: SnackBarType.ERROR,
    );
  }
}
