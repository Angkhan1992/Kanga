import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/live_model.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/widgets/avatar_widget.dart';
import 'package:kanga/widgets/common_widget.dart';
import 'package:kanga/widgets/textfield_widget.dart';

class InviteFriendScreen extends StatefulWidget {
  final LiveModel liveModel;

  const InviteFriendScreen({
    Key? key,
    required this.liveModel,
  }) : super(key: key);

  @override
  _InviteFriendScreenState createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  List<UserModel> _contactUsers = [];
  List<UserModel> _showUsers = [];
  List<String> _userIDs = [];

  var _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Timer.run(() => _getData());
    _searchController.addListener(() => _getShowData());
  }

  void _getData() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> allContacts = await FlutterContacts.getContacts();
      allContacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      List<Contact> validContacts = [];
      for (var contact in allContacts) {
        if (contact.emails.isNotEmpty) {
          validContacts.add(contact);
        }
      }
      List<String> emails = [];
      for (var contact in validContacts) {
        emails.add(contact.emails.first.address);
      }
      if (emails.isNotEmpty) {
        var res = await NetworkProvider.of(context).post(
          Constants.header_profile,
          Constants.link_get_contacts,
          {
            'emails': emails.join(','),
          },
          isProgress: true,
        );
        if (res['ret'] == 10000) {
          _contactUsers.clear();
          for (var json in res['result']) {
            var user = UserModel.fromJson(json);
            _contactUsers.add(user);
          }
          _contactUsers.sort((a, b) => a.getName().compareTo(b.getName()));
          _getShowData();

          print('[Contacts] validContacts : ${_showUsers.length}');
        } else {
          DialogProvider.of(context).showSnackBar(
            res['msg'],
            type: SnackBarType.ERROR,
          );
        }
        setState(() {});
      }
    } else {
      Navigator.of(context).pop();
      DialogProvider.of(context).showSnackBar(
        S.current.permissionDenied,
        type: SnackBarType.ERROR,
      );
    }
  }

  void _getShowData() {
    _showUsers.clear();
    var search = _searchController.text;
    if (search.isEmpty) {
      _showUsers.addAll(_contactUsers);
      return;
    }
    for (var user in _contactUsers) {
      if (user.contains(search)) {
        _showUsers.add(user);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.current.contacts,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: KangaColor().secondDarkColor(1),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add_to_drive),
              onPressed: () => _invite(),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(offsetBase),
              child: KangaTextField(
                controller: _searchController,
                hintText: S.current.searchKey,
                textInputAction: TextInputAction.done,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                circleConner: true,
              ),
            ),
            Expanded(
              child: _showUsers.isEmpty
                  ? EmptyWidget(
                      context,
                      title: S.current.emptyList,
                      isProgress: false,
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        var user = _showUsers[index];
                        return InkWell(
                          onTap: () {
                            if (_userIDs.contains(user.id)) {
                              _userIDs.remove(user.id);
                            } else {
                              _userIDs.add(user.id);
                            }
                            setState(() {});
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: offsetBase,
                              vertical: offsetXSm,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(offsetBase),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: offsetBase,
                                vertical: offsetSm,
                              ),
                              child: Row(
                                children: [
                                  user.avatar == null || user.avatar.isEmpty
                                      ? EmptyAvatar(name: user.first_name)
                                      : CachedNetworkImage(
                                          width: 48.0,
                                          height: 48.0,
                                          imageUrl: user.avatar,
                                          placeholder: (context, url) => Stack(
                                            children: [
                                              Center(
                                                child: Image.asset(
                                                  'assets/images/logo.png',
                                                  width: 48.0,
                                                  height: 48.0,
                                                ),
                                              ),
                                              Center(
                                                  child:
                                                      CupertinoActivityIndicator()),
                                            ],
                                          ),
                                          errorWidget: (context, url, error) =>
                                              EmptyAvatar(
                                                  name: user.first_name),
                                          fit: BoxFit.cover,
                                        ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: offsetBase),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.getName(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                          Text(
                                            user.email,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    _userIDs.contains(user.id)
                                        ? Icons.check_circle_rounded
                                        : Icons.radio_button_unchecked,
                                    color: KangaColor.kangaButtonBackColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: _showUsers.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _invite() async {
    if (_userIDs.isEmpty) {
      DialogProvider.of(context).showSnackBar(
        S.current.noSelectContact,
        type: SnackBarType.ERROR,
      );
      return;
    }
    var res = await NetworkProvider.of(context).post(
      Constants.header_demand,
      Constants.link_share_live,
      {
        'receiver_id': _userIDs.join(','),
        'content': jsonEncode({
          'id': widget.liveModel.id,
          'join_link': widget.liveModel.join_link,
          'join_id': widget.liveModel.join_id,
          'join_pass': widget.liveModel.join_pass,
        }),
      },
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      DialogProvider.of(context).showSnackBar(
        S.current.sentInvitationSuccess,
      );
      Navigator.of(context).pop();
    } else {
      DialogProvider.of(context).showSnackBar(
        res['msg'],
        type: SnackBarType.ERROR,
      );
    }
  }
}
