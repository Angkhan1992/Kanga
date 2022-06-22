import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/native_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/screens/auth/complete_profile_screen.dart';
import 'package:kanga/screens/auth/forgot_screen.dart';
import 'package:kanga/screens/auth/signup_screen.dart';
import 'package:kanga/screens/auth/verify_screen.dart';
import 'package:kanga/screens/main_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/utils/extensions.dart';
import 'package:kanga/widgets/button_widget.dart';
import 'package:kanga/widgets/textfield_widget.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  var _isObSecure = true;
  var _isLoginLoading = false;

  var socialBtns = [];

  var _loginUser = UserModel();
  TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    super.initState();

    socialBtns = [
      {
        'icon': 'assets/icons/ic_google.svg',
        'action': _onGoogleLogin,
      },
      {
        'icon': 'assets/icons/ic_facebook.svg',
        'action': _onFacebookLogin,
      },
      {
        'icon': 'assets/icons/ic_apple.svg',
        'action': _onAppleLogin,
      },
    ];

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _autoValidate = AutovalidateMode.always;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: offsetXMd),
          child: Column(
            children: [
              SizedBox(
                height: offsetMd,
              ),
              Image.asset(
                'assets/images/circularLogo.png',
                width: 120.0,
              ),
              SizedBox(
                height: offsetXLg,
              ),
              Text(
                S.current.login.toUpperCase(),
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(
                height: offsetLg,
              ),
              _buildForm(),
              InkWell(
                onTap: () => NavigatorProvider.of(context)
                    .pushToWidget(screen: ForgotScreen()),
                child: Padding(
                  padding: const EdgeInsets.only(top: offsetBase),
                  child: Text(
                    S.current.forgotYourPass,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: KangaColor().textGreyColor(0.6),
                        ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    NavigatorProvider.of(context)
                        .pushToWidget(screen: SignupScreen());
                  },
                  child: Center(
                    child: Text('You have not account, Go to register'),
                  ),
                ),
              ),
              _isLoginLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        KangaColor().pinkButtonColor(1),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: offsetXLg),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (var social in socialBtns)
                                SocialButton(
                                  icon: SvgPicture.asset(social['icon']),
                                  action: social['action'],
                                )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: offsetXMd,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: offsetBase),
                          child: KangaButton(
                            btnColor: KangaColor().pinkButtonColor(1),
                            onPressed: () => _onLogin(),
                            btnText: S.current.login.toUpperCase(),
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: offsetXLg,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidate,
      child: Column(
        children: [
          KangaTextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            hintText: S.current.usernameOrEmail,
            prefixIcon: Icon(
              Icons.email,
              size: offsetMd,
              color: KangaColor().textGreyColor(1),
            ),
            onSaved: (email) {
              _loginUser.email = email!;
            },
            validator: (email) {
              switch (email!.validateEmail) {
                case 1:
                  return S.current.emptyEmail;
                case 2:
                  return S.current.validEmail;
                default:
                  return null;
              }
            },
          ),
          SizedBox(
            height: offsetMd,
          ),
          KangaTextField(
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.visiblePassword,
            hintText: S.current.password,
            obscureText: _isObSecure,
            controller: _passController,
            prefixIcon: Icon(
              Icons.lock,
              size: offsetMd,
              color: KangaColor().textGreyColor(1),
            ),
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  _isObSecure = !_isObSecure;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: SvgPicture.asset(
                  _isObSecure
                      ? 'assets/icons/ic_eye_shown.svg'
                      : 'assets/icons/ic_eye_hidden.svg',
                  color: KangaColor().textGreyColor(1),
                ),
              ),
            ),
            validator: (password) {
              switch (password!.validatePassword) {
                case 1:
                  return S.current.emptyPwd;
                case 2:
                  return S.current.validPassword;
                default:
                  return null;
              }
            },
            onSubmitted: (value) => _onLogin(),
          ),
        ],
      ),
    );
  }

  void _onGoogleLogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      var result = await _googleSignIn.signIn();
      print('$result');
      print('[GOOGLE AUTH] request ===> $result');
      var param = {
        'first_name': result!.displayName,
        'last_name': result.displayName,
        'email': result.email,
        'avatar': result.photoUrl ?? '',
        'account_type': 'GOOGLE',
      };
      _socialLogin(param);
    } catch (error) {
      DialogProvider.of(context).showSnackBar(
        error.toString(),
        type: SnackBarType.ERROR,
      );
    }
  }

  void _onAppleLogin() async {
    if (Platform.isAndroid) {
      String redirectionUri =
          'https://kangabalance.laodev.info/Auth/apple_sign';
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: 'example-nonce',
        state: 'example-state',
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.kagna.measurement',
          redirectUri: Uri.parse(
            redirectionUri,
          ),
        ),
      );
      try {
        Map<String, dynamic> payload = Jwt.parseJwt(credential.identityToken!);
        String email = payload['email'] as String;
        var param = {
          'first_name': email.split('@').first,
          'last_name': email.split('@').first,
          'email': email,
          'account_type': 'APPLE',
        };
        _socialLogin(param);
      } catch (e) {
        DialogProvider.of(context).showSnackBar(
          S.current.errorSocialSign,
          type: SnackBarType.ERROR,
        );
      }
    } else {
      var resp = await NativeProvider.initAppleSign();
      if (resp == "Not found any auth") {
        DialogProvider.of(context).showSnackBar(
          S.current.errorSocialSign,
          type: SnackBarType.ERROR,
        );
        return;
      }

      Map<String, dynamic> payload = Jwt.parseJwt(resp);
      print('[APPLE] sign: ${jsonEncode(payload)}');
      String email = payload['email'] as String;

      var param = {
        'first_name': email.split('@').first,
        'last_name': email.split('@').first,
        'email': email,
        'account_type': 'APPLE',
      };
      _socialLogin(param);
    }
  }

  void _onFacebookLogin() async {
    // final LoginResult result = await FacebookAuth.instance.login(
    //   permissions: [
    //     'public_profile',
    //     'email',
    //     'pages_show_list',
    //     'pages_messaging',
    //     'pages_manage_metadata'
    //   ],
    // );
    //
    // if (result.status == LoginStatus.success) {
    //   final userData = await FacebookAuth.i.getUserData(
    //     fields: "name,email,picture.width(200),birthday,friends,gender,link",
    //   );
    //   var param = {
    //     'first_name': userData['name'],
    //     'last_name': userData['name'],
    //     'email': userData['email'],
    //     'avatar': userData['picture']['data']['url'],
    //     'account_type': 'FACEBOOK',
    //   };
    //   _socialLogin(param);
    // } else {
    //   print(result.status);
    //   print(result.message);
    // }
  }

  void _onLogin() async {
    _formKey.currentState!.save();
    _autoValidate = AutovalidateMode.always;
    var pass = _passController.text;

    var isValid = _loginUser.validLoginData(pass);
    if (!isValid) return;

    setState(() {
      _isLoginLoading = true;
    });
    var result = await _loginUser.login(pass);
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
    } else if (result['ret'] == 10001) {
      NavigatorProvider.of(context).pushToWidget(
        screen: VerifyScreen(
          email: _loginUser.email,
        ),
        replace: true,
      );
    } else {
      DialogProvider.of(context).showSnackBar(
        result['msg'],
        type: SnackBarType.ERROR,
      );
    }
  }

  void _socialLogin(Map<String, dynamic> param) async {
    var res = await NetworkProvider.of(context).post(
      Constants.header_auth,
      Constants.link_login_social,
      param,
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      var token = res['result']['token'];
      await PrefProvider().setToken(token);
      var _currentUser = UserModel.fromJson(res['result']);
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
        S.current.failedSocialLogin,
        type: SnackBarType.ERROR,
      );
    }
  }
}
