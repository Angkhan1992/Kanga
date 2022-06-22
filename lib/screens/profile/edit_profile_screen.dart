import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/navigator_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/providers/stt_provider.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/utils/extensions.dart';
import 'package:kanga/widgets/button_widget.dart';
import 'package:kanga/widgets/measure_widget.dart';
import 'package:kanga/widgets/textfield_widget.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel? currentUser;

  const EditProfileScreen({
    Key? key,
    this.currentUser,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _user = UserModel();
  var _avatarPath = '';
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  var _firstController = TextEditingController();
  var _lastController = TextEditingController();
  var _cityController = TextEditingController();
  var _stateController = TextEditingController();
  var _dobController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  DateTime _selectedDate = DateTime.now();
  var _isUpdating = false;

  @override
  void initState() {
    super.initState();

    _user = widget.currentUser!;

    _firstController.text = _user.first_name;
    _lastController.text = _user.last_name;
    _cityController.text = _user.city;
    _stateController.text = _user.state;
    _dobController.text = _user.dob == '0000-00-00'
        ? DateTime.now().subtract(Duration(days: 365 * 65)).getDateMDY
        : _user.dob.getDateYMD.getDateMDY;

    _avatarPath = _user.avatar;

    _selectedDate = _user.dob == '0000-00-00'
        ? DateTime.now().subtract(Duration(days: 365 * 65))
        : _user.dob.getDateYMD;
  }

  void _imagePicker() async {
    var isPermission = await checkLibraryPermission();
    if (isPermission) {
      DialogProvider.of(context).kangaBubbleDialog(
        child: Column(
          children: [
            Text(
              S.current.chooseMethod,
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: offsetBase,
            ),
            Text(
              S.current.chooseMethodDetail,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontSize: 16.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          KangaMeasureDialogButton(
            context,
            action: () {
              Navigator.of(context).pop();
              _pickImage(
                isCamera: false,
              );
            },
            text: S.current.fromGallery,
          ),
          KangaMeasureDialogButton(
            context,
            action: () {
              Navigator.of(context).pop();
              _pickImage(
                isCamera: true,
              );
            },
            text: S.current.fromCamera,
            isFull: true,
          ),
        ],
      );
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.permissionDenied,
        type: SnackBarType.ERROR,
      );
    }
  }

  void _pickImage({
    bool isCamera = true,
  }) async {
    var _image = await _picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );

    if (_image != null) {
      setState(() {
        _avatarPath = _image.path;
      });
    }
  }

  void _showStatsSheet() async {
    NavigatorProvider.of(context).showCustomBottomModal(Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(offsetBase),
          child: Text(
            'Choose state',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Divider(
          color: Colors.white,
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, i) {
              var item = unitedStatesStateList[i];
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _stateController.text = item;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: offsetSm),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(),
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                  ),
                ),
              );
            },
            itemCount: unitedStatesStateList.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: offsetBase),
              child: Divider(),
            ),
          ),
        ),
      ],
    ));
  }

  void _showDialogPicker() async {
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
        _dobController.text = _selectedDate.getDateMDY;
      });
  }

  void _updateProfile() async {
    setState(() {
      _autoValidate = AutovalidateMode.always;
    });

    var firstName = _firstController.text;
    var lastName = _lastController.text;
    var city = _cityController.text;
    var state = _stateController.text;
    var dob = _dobController.text;
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        city.isEmpty ||
        state.isEmpty ||
        dob.isEmpty ||
        _avatarPath.isEmpty) {
      DialogProvider.of(context).showSnackBar(
        S.current.completeProfile,
        type: SnackBarType.ERROR,
      );
      return;
    }

    setState(() => _isUpdating = true);
    String url =
        '${(kReleaseMode || PRODUCTTEST) ? RELEASEBASEURL : DEBUGBASEURL}Profile/update_profile';
    var request = http.MultipartRequest("POST", Uri.parse(url));

    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['city'] = city;
    request.fields['state'] = state;
    request.fields['dob'] = _selectedDate.getUTCTime;
    request.fields['token'] = await PrefProvider().getToken();

    print('[REQUEST] ===> ${request.fields}');
    var pic = await http.MultipartFile.fromPath("avatar", _avatarPath);
    request.files.add(pic);

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print('[RESPONSE] ===> $responseString');

    setState(() => _isUpdating = false);
    try {
      var jsonData = json.decode(responseString);
      if (jsonData['ret'] == 10000) {
        var _currentUser = UserModel.fromJson(jsonData['result']);
        await _currentUser.save();
        DialogProvider.of(context).showSnackBar(
          S.current.successUpdateProfile,
        );
        Navigator.of(context).pop(true);
      } else {
        DialogProvider.of(context).showSnackBar(
          jsonData['msg'],
          type: SnackBarType.ERROR,
        );
      }
    } catch (e) {
      DialogProvider.of(context).showSnackBar(
        e.toString(),
        type: SnackBarType.ERROR,
      );
    }
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
          title: Text(
            S.current.editProfile,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 225,
                    padding: EdgeInsets.symmetric(horizontal: offsetBase),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 24,
                        ),
                        Container(
                          width: 225,
                          color: KangaColor().bubbleConnerColor(1),
                          child: _avatarPath.contains('http')
                              ? CachedNetworkImage(
                                  imageUrl: _avatarPath,
                                  height: double.infinity,
                                  placeholder: (context, url) => Stack(
                                    children: [
                                      Center(
                                          child: Image.asset(
                                        'assets/images/logo.png',
                                        width: 120.0,
                                        height: 120.0,
                                      )),
                                      Center(
                                        child: CupertinoActivityIndicator(),
                                      ),
                                    ],
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.account_circle,
                                    size: 150,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_avatarPath),
                                  fit: BoxFit.contain,
                                ),
                        ),
                        InkWell(
                          onTap: () => _imagePicker(),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: offsetBase),
                            child: Icon(Icons.camera_enhance_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 0.5,
                    color: KangaColor().textGreyColor(1),
                  ),
                  SizedBox(
                    height: offsetXLg,
                  ),
                  _buildForm(),
                  _isUpdating
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              KangaColor().pinkButtonColor(1),
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: offsetLg, vertical: offsetXLg),
                          child: KangaButton(
                            onPressed: () => _updateProfile(),
                            btnText: 'Save',
                          ),
                        ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 165.0,
                  ),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: KangaColor().bubbleColor(1),
                    borderRadius: BorderRadius.all(Radius.circular(60.0)),
                    border: Border.all(
                      color: KangaColor().textGreyColor(1),
                      width: 3.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)),
                    child: _avatarPath.contains('http')
                        ? CachedNetworkImage(
                            imageUrl: _avatarPath,
                            height: double.infinity,
                            placeholder: (context, url) => Stack(
                              children: [
                                Center(
                                    child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 60.0,
                                  height: 60.0,
                                )),
                                Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              ],
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.account_circle,
                              size: 90.0,
                            ),
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(_avatarPath),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.all(offsetBase),
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.firstName,
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(
              height: offsetSm,
            ),
            KangaTextField(
              controller: _firstController,
              hintText: S.current.firstName,
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
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
              height: offsetBase,
            ),
            Text(
              S.current.lastName,
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(
              height: offsetSm,
            ),
            KangaTextField(
              controller: _lastController,
              hintText: S.current.lastName,
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
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
              height: offsetBase,
            ),
            Text(
              S.current.city,
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(
              height: offsetSm,
            ),
            KangaTextField(
              controller: _cityController,
              hintText: S.current.enterYourCity,
              prefixIcon: Icon(
                Icons.location_city,
                color: Colors.white,
              ),
              validator: (city) {
                switch (city!.validateName) {
                  case 1:
                    return S.current.validateCity;
                  default:
                    return null;
                }
              },
            ),
            SizedBox(
              height: offsetBase,
            ),
            Text(
              S.current.state,
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(
              height: offsetSm,
            ),
            KangaTextField(
              controller: _stateController,
              hintText: S.current.selectState,
              prefixIcon: Icon(
                Icons.location_city,
                color: Colors.white,
              ),
              suffixIcon: Icon(
                Icons.arrow_drop_down_outlined,
                color: Colors.white,
              ),
              readOnly: true,
              onTap: () => _showStatsSheet(),
              validator: (state) {
                switch (state!.validateName) {
                  case 1:
                    return S.current.validateState;
                  default:
                    return null;
                }
              },
            ),
            SizedBox(
              height: offsetBase,
            ),
            Text(
              S.current.dateOfBirth,
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(
              height: offsetSm,
            ),
            KangaTextField(
              controller: _dobController,
              hintText: S.current.dateOfBirth,
              prefixIcon: Icon(
                Icons.perm_contact_calendar,
                color: Colors.white,
              ),
              readOnly: true,
              onTap: () => _showDialogPicker(),
              validator: (dob) {
                switch (dob!.validateName) {
                  case 1:
                    return S.current.validateDob;
                  default:
                    return null;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
