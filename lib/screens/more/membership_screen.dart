import 'dart:async';
import 'dart:io';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

import 'package:kanga/generated/l10n.dart';
import 'package:kanga/models/inapp_model.dart';
import 'package:kanga/models/user_model.dart';
import 'package:kanga/providers/dialog_provider.dart';
import 'package:kanga/providers/loading_provider.dart';
import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/popup_service.dart';
import 'package:kanga/themes/color_theme.dart';
import 'package:kanga/themes/dimen_theme.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/utils/extensions.dart';
import 'package:kanga/widgets/button_widget.dart';
import 'package:kanga/widgets/text_widget.dart';

class MembershipScreen extends StatefulWidget {
  final InAppModel model;
  const MembershipScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  _MembershipScreenState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  var _selectedTap = 1;

  List<String> _productLists = [];
  List<IAPItem> _items = [];
  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;
  StreamSubscription? _conectionSubscription;
  LoadingProvider? _loadingProvider;

  var gettingContents = [
    '4-week program',
    'Entire Demo Library',
    'Chat Support',
    'Unlimited Live Sessions',
    'Unlimited Kanga Measure',
  ];
  var gettingDetail = [
    'Follow a 5 day / week sessions guided by a Doctor of Physical Therapy. ',
    'A library of over 50 videos demonstrating how to properly perform exercises. ',
    'Chat with a Kanga Specialist, and receive a reply within 24 hours. ',
    'Sessions Join live sessions and workout in a virtual group setting. ',
    'Asses your progress and receive feedback compared to others. ',
  ];
  var _listKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _tabController!.addListener(() {
      setState(() => _selectedTap = _tabController!.index);
    });

    Timer.run(() => _initialize());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initialize() async {
    print('[Membership] info : ${widget.model.yPackage}');

    _productLists.add(widget.model.mPackage!);
    _productLists.add(widget.model.yPackage!);

    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    print('[Membership] result: $result');
    if (!mounted) return;

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      print('[Membership] consumeAllItems: $msg');
    } catch (err) {
      print('[Membership] consumeAllItems error: $err');
    }

    await _getProduct();

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('[Membership] connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      print('[Membership] purchase-updated: $productItem');
      _loadingProvider!.hide();
      if (Platform.isIOS) {
        if (productItem!.transactionStateIOS == TransactionState.purchased) {
          _upgradeMembership(productItem);
        }
      }
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('[Membership] purchase-error: $purchaseError');
      _loadingProvider!.hide();
      DialogProvider.of(context).showSnackBar(
        'Purchase ${purchaseError!.message!}',
        type: SnackBarType.ERROR,
      );
    });

    _loadingProvider = LoadingProvider.of(context);

    setState(() {});
  }

  void _requestPurchase(IAPItem item) {
    _loadingProvider!.show();
    FlutterInappPurchase.instance.requestPurchase(item.productId!);
  }

  Future _getProduct() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(_productLists);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }
  }

  void _upgradeMembership(PurchasedItem purchaseItem) async {
    var productID = purchaseItem.productId!;
    var param = {
      'membership':
          productID.contains('kangaonemonth') ? 'OneMonth' : 'OneYear',
      'paid': productID.contains('kangaonemonth')
          ? widget.model.mValue
          : widget.model.yValue,
    };
    var res = await NetworkProvider.of(context).post(
      Constants.header_profile,
      Constants.link_update_membership,
      param,
      isProgress: true,
    );
    if (res['ret'] == 10000) {
      print('[IAP] result : ${res['result']}');
      FlutterInappPurchase.instance.clearTransactionIOS();
      var _currentUser = UserModel.fromJson(res['result']);
      await _currentUser.save();

      DialogProvider.of(context).showSnackBar(
        S.current.successMembership,
      );
      Future.delayed(
          Duration(milliseconds: 2500), () => Navigator.of(context).pop());
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.severError,
        type: SnackBarType.ERROR,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.memberships,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: offsetLg,
          ),
          _headerWidget(),
          _selectedTap == 0 ? _monthlyWidget() : _annuallyWidget(),
          SizedBox(
            height: offsetBase,
          ),
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(
                vertical: offsetBase, horizontal: offsetSm),
            decoration: BoxDecoration(
              color: KangaColor().textGreyColor(0.3),
              borderRadius: BorderRadius.circular(60),
            ),
            child: TabBar(
              indicatorPadding: EdgeInsets.all(0),
              controller: _tabController,
              unselectedLabelColor: KangaColor().textGreyColor(1),
              labelStyle: Theme.of(context).textTheme.bodyText1,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BubbleTabIndicator(
                indicatorHeight: 50.0,
                indicatorColor: Colors.white,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              tabs: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pay Monthly',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 12.0,
                            color:
                                _selectedTap == 0 ? Colors.black : Colors.white,
                          ),
                    ),
                    Text(
                      'Commit monthly',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 10.0,
                            color:
                                _selectedTap == 0 ? Colors.black : Colors.white,
                          ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Pay Upfront, ',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 12.0,
                                    color: _selectedTap == 1
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                        ),
                        Text(
                          'Save 25%',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontSize: 12.0,
                                  color: KangaColor().pinkMatColor),
                        ),
                      ],
                    ),
                    Text(
                      'Commit annually',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 10.0,
                            color:
                                _selectedTap == 1 ? Colors.black : Colors.white,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: offsetXMd,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: offsetBase,
            ),
            child: KangaButton(
              onPressed: () => _requestPurchase(_items[_selectedTap]),
              btnText: 'Buy now',
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.only(bottom: offsetXMd),
            decoration: BoxDecoration(
              color: KangaColor().bubbleColor(1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(offsetLg),
                topRight: Radius.circular(offsetLg),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'What you get',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: KangaColor().pinkMatColor,
                        ),
                  ),
                ),
                Divider(),
                for (var content in gettingContents)
                  MembershipResultWidget(
                    context,
                    key: _listKeys[gettingContents.indexOf(content)],
                    content: content,
                    pop: () => _popWidget(gettingContents.indexOf(content)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _popWidget(int selectIndex) {
    var width = MediaQuery.of(context).size.width - 2 * offsetXMd;
    KangaMorePopup(
      context,
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            gettingContents[selectIndex],
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Colors.black,
                ),
          ),
          SizedBox(
            height: offsetSm,
          ),
          Text(
            gettingDetail[selectIndex],
            style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Colors.black,
                ),
          ),
        ],
      ),
      width: width,
      height: 100.0,
      backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: offsetBase,
        vertical: offsetSm,
      ),
      borderRadius: BorderRadius.circular(10.0),
    )..show(widgetKey: _listKeys[selectIndex]);
  }

  Widget _headerWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Starts at',
          style: Theme.of(context).textTheme.caption,
        ),
        if (widget.model.discount! != '0')
          Container(
            margin: EdgeInsets.only(left: offsetBase),
            padding: EdgeInsets.symmetric(
              horizontal: offsetSm,
              vertical: offsetXSm,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(offsetSm),
              color: KangaColor.kangaButtonBackColor,
            ),
            child: Text('Sale ${widget.model.discount!}%'),
          ),
      ],
    );
  }

  Widget _monthlyWidget() {
    var price = widget.model.mValue!;
    return Column(
      children: [
        SizedBox(
          height: offsetSm,
        ),
        Text(
          '\$$price/mo',
          style: Theme.of(context).textTheme.headline1,
        ),
        SizedBox(
          height: offsetSm,
        ),
        Text(
          'Billed monthly',
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  Widget _annuallyWidget() {
    var price = widget.model.yValue!;
    var mPrice = widget.model.mValue!;
    return Column(
      children: [
        SizedBox(
          height: offsetSm,
        ),
        Text(
          '\$${price.calcMonthlyPrice}/mo',
          style: Theme.of(context).textTheme.headline1,
        ),
        SizedBox(
          height: offsetSm,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Billed at ',
              style: Theme.of(context).textTheme.caption,
            ),
            Text(
              '\$${(double.parse(mPrice) * 12).toString()}',
              style: Theme.of(context).textTheme.caption!.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
            ),
            Text(
              ' \$$price/yr',
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
