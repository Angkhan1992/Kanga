import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/screens/auth/login_screen.dart';
import 'package:kanga/screens/html_view_screen.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/utils/extensions.dart';
import 'package:kanga/widgets/button_widget.dart';
import 'package:kanga/widgets/textfield_widget.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  var _isObSecure = true;
  var _isLoginLoading = false;

  TextEditingController _dobController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  var _registerUser = UserModel();

  @override
  void initState() {
    super.initState();

    _dobController.text = Constants.date_dob_default;
    _selectedDate = Constants.date_dob_default.getDateYMD;
  }

  @override
  void dispose() {
    super.dispose();

    _dobController.dispose();
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
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                  S.current.createAccount.toUpperCase(),
                  style: Theme.of(context).textTheme.headline2,
                ),
                SizedBox(
                  height: offsetLg,
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
                        btnText: S.current.createAccount.toUpperCase(),
                        onPressed: () => _onCreate(_passController.text),
                      ),
                SizedBox(
                  height: offsetLg,
                ),
                Text(S.current.byCreatingAccount),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => NavigatorProvider(context).pushToWidget(
                            screen: HtmlViewScreen(
                                title: S.current.termsOfServices,
                                viewType: HtmlViewType.TermsService)),
                        child: Text(
                          '${S.current.termsOfServices},',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Colors.white,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      Text(' '),
                      InkWell(
                        onTap: () => NavigatorProvider(context).pushToWidget(
                            screen: HtmlViewScreen(
                                title: S.current.privacyPolicy,
                                viewType: HtmlViewType.PrivacyPolicy)),
                        child: Text(
                          S.current.privacyPolicy,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Colors.white,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      Text(' ${S.current.and} '),
                      InkWell(
                        onTap: () => NavigatorProvider(context).pushToWidget(
                            screen: HtmlViewScreen(
                                title: S.current.membershipTerms,
                                viewType: HtmlViewType.MembershipTerm)),
                        child: Text(
                          S.current.membershipTerms,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Colors.white,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: offsetXLg,
                ),
              ],
            ),
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
            hintText: S.current.firstName,
            keyboardType: TextInputType.name,
            prefixIcon: Icon(
              Icons.person,
              size: offsetMd,
              color: KangaColor().textGreyColor(1),
            ),
            onSaved: (firstName) {
              _registerUser.first_name = firstName!;
            },
            validator: (firstName) {
              switch (firstName!.validateName) {
                case 1:
                  return S.current.validateFirstName;
                default:
                  return null;
              }
            },
          ),
          SizedBox(
            height: offsetMd,
          ),
          KangaTextField(
            textInputAction: TextInputAction.next,
            hintText: S.current.lastName,
            keyboardType: TextInputType.name,
            prefixIcon: Icon(
              Icons.person,
              size: offsetMd,
              color: KangaColor().textGreyColor(1),
            ),
            onSaved: (lastName) {
              _registerUser.last_name = lastName!;
            },
            validator: (lastName) {
              switch (lastName!.validateName) {
                case 1:
                  return S.current.validateLastName;
                default:
                  return null;
              }
            },
          ),
          SizedBox(
            height: offsetMd,
          ),
          KangaTextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            hintText: S.current.emailAddress,
            prefixIcon: Icon(
              Icons.email,
              size: offsetMd,
              color: KangaColor().textGreyColor(1),
            ),
            onSaved: (email) {
              _registerUser.email = email!;
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
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            controller: _dobController,
            hintText: S.current.dateOfBirth,
            readOnly: true,
            prefixIcon: Icon(
              Icons.perm_contact_calendar_outlined,
              size: offsetMd,
              color: KangaColor().textGreyColor(1),
            ),
            onSaved: (dob) {
              _registerUser.dob = dob!;
            },
            validator: (dob) {
              return null;
            },
            onTap: () => _showDialogPicker(),
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
            onSaved: (password) {
              // _userInfoObj.email = email;
            },
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
            onSubmitted: (password) => _onCreate(password),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialogPicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      helpText: S.current.dateOfBirth,
      initialDate: _selectedDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: KangaColor().pinkButtonColor(1),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
  }

  void _onCreate(String pass) async {
    _formKey.currentState!.save();
    _autoValidate = AutovalidateMode.always;

    var isValid = _registerUser.validPrimaryData(pass);
    if (!isValid) return;

    setState(() {
      _isLoginLoading = true;
    });
    var result = await _registerUser.register(pass);
    setState(() {
      _isLoginLoading = false;
    });
    if (result['ret'] == 10000) {
      NavigatorProvider.of(context).pushToWidget(screen: LoginScreen(), replace: true);
    } else {
      DialogProvider.of(context).showSnackBar(
        result['result'],
        type: SnackBarType.ERROR,
      );
    }
  }
}
