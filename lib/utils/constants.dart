import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:kanga/providers/perf_provider.dart';

class Constants {
  static const date_dob_default = '1990-01-01';

  static const route_splash = '/splash';
  static const route_onboard = '/onboard';
  static const route_main = '/main';

  static const header_auth = 'Auth';
  static const header_measure = 'Measure';
  static const header_demand = 'OnDemand';
  static const header_profile = 'Profile';
  static const header_chat = 'Chat';

  static const link_register = 'register';
  static const link_login = 'login';
  static const link_resend_code = 'resend_code';
  static const link_submit_code = 'submit_code';
  static const link_complete_profile = 'complete_profile';
  static const link_login_token = 'login_token';
  static const link_app_info = 'app_info';
  static const link_check_expired = 'check_expired';
  static const link_add_result = 'add_result';
  static const link_get_result = 'get_result';
  static const link_measure_info = 'measure_info';
  static const link_get_demand = 'get_demand';
  static const link_demand_class = 'get_class_demand';
  static const link_login_social = 'login_social';
  static const link_add_favorite = 'add_favorite';
  static const link_get_profile = 'get_profile';
  static const link_join_room = 'join_room';
  static const link_add_chat = 'add_chat';
  static const link_get_live = 'get_live';
  static const link_accept_live = 'accept_live';
  static const link_cancel_live = 'cancel_live';
  static const link_update_membership = 'update_membership';
  static const link_send_code = 'send_code';
  static const link_change_password = 'change_password';
  static const link_add_feedback = 'add_feedback';
  static const link_add_feel = 'add_daily_feel';
  static const link_get_contacts = 'get_contacts';
  static const link_share_live = 'share_live';
  static const link_unread_notification = 'get_unread_notification';
  static const link_get_notification = 'get_notification';
  static const link_remove_notification = 'remove_notification';
  static const link_live_byid = 'get_live_byid';
  static const link_get_membership = 'get_membership';

  static const keyToken = 'key_token';
  static const keyUserData = 'key_user_data';
  static const keyAppInfo = 'key_app_info';
  static const keyMeasureAgree = 'key_measure_agree';
  static const keyGainLevel = 'key_gain_level';
  static const keyAskMeasure = 'key_ask_measure';
  static const keyBadgeNumber = 'key_badge_number';

  static final voiceDetectWords = [
    'fall',
    'four',
    '4',
    'pour',
    'poll',
    'paul',
    'full',
    'call',
    'phone',
    'false',
    'done',
    'stop',
    'star',
    'far',
    'for',
    'Store',
  ];
}

const PACKAGENAME = 'com.kanga.measurement';

const PRODUCTTEST = true;

const RELEASEBASEURL = 'https://api.kangabalance.info/';
const DEBUGBASEURL = 'https://test-api.kangabalance.info/';

const RELEASESOCKET = 'ws://51.89.17.207:51515';
const DEBUGSOCKET = 'ws://192.168.1.201:51515';

const DELAYTIME = 100;
const MEASUREPREPARE = 70;
const MEASUREPREDATA = 100;
const MEASUREACTION = 400;
const MEASUREACTIONWALK = 700;

const SIT2STANDCOMPARE = [
  {
    'min': 0,
    'max': 60,
    'men': 14,
    'women': 14,
  },
  {
    'min': 59,
    'max': 65,
    'men': 14,
    'women': 12,
  },
  {
    'min': 64,
    'max': 70,
    'men': 12,
    'women': 11,
  },
  {
    'min': 69,
    'max': 75,
    'men': 12,
    'women': 10,
  },
  {
    'min': 74,
    'max': 80,
    'men': 11,
    'women': 10,
  },
  {
    'min': 79,
    'max': 85,
    'men': 10,
    'women': 9,
  },
  {
    'min': 84,
    'max': 90,
    'men': 8,
    'women': 8,
  },
  {
    'min': 89,
    'max': 95,
    'men': 7,
    'women': 4,
  },
  {
    'min': 94,
    'max': 200,
    'men': 4,
    'women': 4,
  },
];

const SINGLELEGCOMPARE = [
  {
    'min': 0,
    'max': 50,
    'no': 28.8,
    'low': 25.5,
    'med': 22.5,
  },
  {
    'min': 49,
    'max': 60,
    'no': 27.1,
    'low': 24.5,
    'med': 21.5,
  },
  {
    'min': 59,
    'max': 70,
    'no': 24.2,
    'low': 20.5,
    'med': 17.5,
  },
  {
    'min': 69,
    'max': 200,
    'no': 18.2,
    'low': 15.5,
    'med': 12.5,
  },
];

const TENMETERMENCOMPARE = [
  {
    'min': 0,
    'max': 30,
    'low': 1.217,
    'med': 1.474,
  },
  {
    'min': 29,
    'max': 40,
    'low': 1.320,
    'med': 1.538,
  },
  {
    'min': 39,
    'max': 50,
    'low': 1.270,
    'med': 1.470,
  },
  {
    'min': 49,
    'max': 60,
    'low': 1.122,
    'med': 1.491,
  },
  {
    'min': 59,
    'max': 70,
    'low': 1.033,
    'med': 1.590,
  },
  {
    'min': 69,
    'max': 80,
    'low': 0.957,
    'med': 1.418,
  },
  {
    'min': 79,
    'max': 100,
    'low': 0.608,
    'med': 1.221,
  },
];

const TENMETERWOMENCOMPARE = [
  {
    'min': 0,
    'max': 30,
    'low': 1.082,
    'med': 1.449,
  },
  {
    'min': 29,
    'max': 40,
    'low': 1.256,
    'med': 1.415,
  },
  {
    'min': 39,
    'max': 50,
    'low': 1.220,
    'med': 1.420,
  },
  {
    'min': 49,
    'max': 60,
    'low': 1.110,
    'med': 1.555,
  },
  {
    'min': 59,
    'max': 70,
    'low': 0.970,
    'med': 1.450,
  },
  {
    'min': 69,
    'max': 80,
    'low': 0.830,
    'med': 1.500,
  },
  {
    'min': 79,
    'max': 100,
    'low': 0.557,
    'med': 1.170,
  },
];

List<String> unitedStatesStateList = [
  "Howland Island",
  "Delaware",
  "Alaska",
  "Maryland",
  "Baker Island",
  "Kingman Reef",
  "New Hampshire",
  "Wake Island",
  "Kansas",
  "Texas",
  "Nebraska",
  "Vermont",
  "Jarvis Island",
  "Hawaii",
  "Guam",
  "United States Virgin Islands",
  "Utah",
  "Oregon",
  "California",
  "New Jersey",
  "North Dakota",
  "Kentucky",
  "Minnesota",
  "Oklahoma",
  "Pennsylvania",
  "New Mexico",
  "American Samoa",
  "Illinois",
  "Michigan",
  "Virginia",
  "Johnston Atoll",
  "West Virginia",
  "Mississippi",
  "Northern Mariana Islands",
  "United States Minor Outlying Islands",
  "Massachusetts",
  "Arizona",
  "Connecticut",
  "Florida",
  "District of Columbia",
  "Midway Atoll",
  "Navassa Island",
  "Indiana",
  "Wisconsin",
  "Wyoming",
  "South Carolina",
  "Arkansas",
  "South Dakota",
  "Montana",
  "North Carolina",
  "Palmyra Atoll",
  "Puerto Rico",
  "Colorado",
  "Missouri",
  "New York",
  "Maine",
  "Tennessee",
  "Georgia",
  "Alabama",
  "Louisiana",
  "Nevada",
  "Iowa",
  "Idaho",
  "Rhode Island",
  "Washington",
  "Ohio"
];

Future<void> initBadge() async {
  if (await FlutterAppBadger.isAppBadgeSupported()) {
    await PrefProvider().setBadge(0);
    FlutterAppBadger.updateBadgeCount(0);
  }
}

Future<void> upgradeBadge() async {
  if (await FlutterAppBadger.isAppBadgeSupported()) {
    var badge = await PrefProvider().getBadge() + 1;
    await PrefProvider().setBadge(badge);
    FlutterAppBadger.updateBadgeCount(badge);
  }
}

// const kConsumables = [
//   {
//     'title': 'com.kanga.measurement.kangaonemonth',
//     'price': 19.99,
//     'type': IAPItemType.NONE,
//   },
//   {
//     'title': 'com.kanga.measurement.kangaoneyear',
//     'price': 179.99,
//     'type': IAPItemType.NONE,
//   },
//   {
//     'title': 'com.kanga.measurement.kangaonemonth20',
//     'price': 15.99,
//     'type': IAPItemType.OFFER20,
//   },
//   {
//     'title': 'com.kanga.measurement.kangaoneyear20',
//     'price': 69.99,
//     'type': IAPItemType.OFFER20,
//   },
//   {
//     'title': 'com.kanga.measurement.kangaonemonth30',
//     'price': 13.99,
//     'type': IAPItemType.OFFER30,
//   },
//   {
//     'title': 'com.kanga.measurement.kangaoneyear30',
//     'price': 64.99,
//     'type': IAPItemType.OFFER30,
//   },
//   {
//     'title': 'com.kanga.measurement.kangaonemonth50',
//     'price': 4.99,
//     'type': IAPItemType.OFFER50,
//   },
//   {
//     'title': 'com.kanga.measurement.kangaoneyear50',
//     'price': 44.99,
//     'type': IAPItemType.OFFER50,
//   },
// ];

const kAchievements = [
  {
    'value': 1,
    'title': 'First Class',
  },
  {
    'value': 3,
    'title': '3 Class',
  },
  {
    'value': 6,
    'title': '6 Class',
  },
  {
    'value': 10,
    'title': '10 Class',
  },
  {
    'value': 15,
    'title': '15 Class',
  },
  {
    'value': 20,
    'title': '20 Class',
  },
];

// double kGetItemPrice(String productID) {
//   for (var iapItem in kConsumables) {
//     if (iapItem['title'] == productID) {
//       return iapItem['price'] as double;
//     }
//   }
//   return 0.0;
// }
