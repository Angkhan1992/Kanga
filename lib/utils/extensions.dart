import 'package:intl/intl.dart';

extension StringExtension on String {
  DateTime get getDateYMD => DateFormat('yyyy-MM-dd').parse(this);
  DateTime get getDateMDY => DateFormat('MM-dd-yyyy').parse(this);
  DateTime get getDateDMY => DateFormat('dd-MM-yyyy').parse(this);

  // Validate Parts
  static const String emailRegx =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  int get validateEmail => (this.trim().isEmpty)
      ? 1
      : (!RegExp(emailRegx).hasMatch(this.trim()))
          ? 2
          : 0;

  int get validateName => this.trim().isEmpty ? 1 : 0;

  int get validatePassword => this.trim().isEmpty
      ? 1
      : this.trim().length < 6
          ? 2
          : 0;

  String get get2FormattedValue =>
      new NumberFormat("#.##").format(double.parse(this));

  String get getChatTime {
    if (this.isNotEmpty) {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime dateTime = dateFormat.parse(this, true);
      DateTime localTime = dateTime.toLocal();

      return DateFormat("h:mm a").format(localTime);
    } else
      return DateFormat('h:mm a').format(DateTime.now());
  }

  String get getLocalDateTime {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    if (this.isNotEmpty) {
      DateTime dateTime = dateFormat.parse(this, true);
      DateTime localTime = dateTime.toLocal();
      return dateFormat.format(localTime);
    } else
      return dateFormat.format(DateTime.now());
  }

  String get getLocalUSDateTime {
    DateFormat printFormate = DateFormat("EEE, MMM dd · h:mm a");
    if (this.isNotEmpty) {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime dateTime = dateFormat.parse(this, true);
      DateTime localTime = dateTime.toLocal();
      return printFormate.format(localTime);
    } else
      return printFormate.format(DateTime.now());
  }

  String get calcMonthlyPrice {
    var yValue = double.parse(this);
    var mValue = yValue / 12.0;
    var result = mValue.roundToDouble() - 0.01;
    return result.toString();
  }
}

extension DoubleExtension on double {
  String get get2Formatted => NumberFormat("#.##").format(this);
}

extension DateTimeExtension on DateTime {
  String get getUTCTime =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(this.toUtc());
  String get getTime => DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
  String get getDateMDY => DateFormat('MMM, dd yyyy').format(this);
  String get getDateMY => DateFormat('MMM, yyyy').format(this);
}
