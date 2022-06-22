import 'package:kanga/providers/network_provider.dart';
import 'package:kanga/providers/perf_provider.dart';
import 'package:kanga/utils/constants.dart';
import 'package:kanga/utils/extensions.dart';

class UserModel {
  String id;
  String first_name;
  String last_name;
  String email;
  String dob;
  String avatar;
  String step;
  String fitness_goal;
  String focus_on;
  String gender;
  String reg_date;
  String exp_date;
  String level;
  String city;
  String state;

  UserModel({
    this.id = '',
    this.first_name = '',
    this.last_name = '',
    this.email = '',
    this.dob = '',
    this.avatar = '',
    this.step = '',
    this.fitness_goal = '',
    this.focus_on = '',
    this.gender = '',
    this.reg_date = '',
    this.exp_date = '',
    this.level = '',
    this.city = '',
    this.state = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      first_name: json["first_name"],
      last_name: json["last_name"],
      email: json["email"],
      dob: json["dob"],
      avatar: json["avatar"],
      step: json["step"],
      fitness_goal: json["fitness_goal"],
      focus_on: json["focus_on"],
      gender: json["gender"],
      reg_date: json["reg_date"],
      exp_date: json["exp_date"],
      level: json["level"],
      city: json["city"],
      state: json["state"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "first_name": this.first_name,
      "last_name": this.last_name,
      "email": this.email,
      "dob": this.dob,
      "avatar": this.avatar,
      "step": this.step,
      "fitness_goal": this.fitness_goal,
      "focus_on": this.focus_on,
      "gender": this.gender,
      "reg_date": this.reg_date,
      "exp_date": this.exp_date,
      "level": this.level,
      "city": this.city,
      "state": this.state,
    };
  }

  Map<String, dynamic> toAddJson() {
    return {
      "first_name": this.first_name,
      "last_name": this.last_name,
      "email": this.email,
      "dob": this.dob,
    };
  }

  bool validPrimaryData(String password) {
    return (first_name.validateName == 0 &&
        last_name.validateName == 0 &&
        email.validateEmail == 0 &&
        password.validatePassword == 0);
  }

  bool validLoginData(String password) {
    return (email.validateEmail == 0 && password.validatePassword == 0);
  }

  Future<dynamic> register(String pass) async {
    var param = toAddJson();
    param['password'] = pass;
    print('$param');
    var result = await NetworkProvider.of(null).post(
      Constants.header_auth,
      Constants.link_register,
      param,
      isProgress: false,
    );
    return result;
  }

  Future<dynamic> login(String pass) async {
    var param = {
      'email': email,
      'password': pass,
    };
    var result = await NetworkProvider.of(null).post(
      Constants.header_auth,
      Constants.link_login,
      param,
      isProgress: false,
    );
    return result;
  }

  Future<void> save() async {
    await PrefProvider().setUser(this);
  }

  int getAge() {
    if (dob == '0000-00-00') {
      return 65;
    }
    var currentDate = DateTime.now();
    var dobYear = int.parse(dob.split('-')[0]);
    var dobMonth = int.parse(dob.split('-')[1]);
    var dobDay = int.parse(dob.split('-')[2]);

    int age = currentDate.year - dobYear;
    if (dobMonth > currentDate.month) {
      age--;
    } else if (dobMonth == currentDate.month) {
      int day1 = currentDate.day;
      if (dobDay > day1) {
        age--;
      }
    }
    return age;
  }

  String getName() {
    return first_name[0].toUpperCase() +
        first_name.substring(1) +
        ' ' +
        last_name[0].toUpperCase() +
        '.';
  }

  bool contains(String key) {
    if (first_name.contains(key)) return true;
    if (last_name.contains(key)) return true;
    if (email.contains(key)) return true;
    if (dob.contains(key)) return true;
    if (city.contains(key)) return true;
    if (state.contains(key)) return true;
    return false;
  }

  bool isExpired() {
    var expiredDate = exp_date.getDateYMD.toLocal();
    return !expiredDate.isAfter(DateTime.now());
  }

  int monthIndex() {
    if (reg_date.getDateYMD.add(Duration(days: 90)).isBefore(DateTime.now())) {
      return 2;
    }
    if (reg_date.getDateYMD.add(Duration(days: 60)).isBefore(DateTime.now())) {
      return 1;
    }
    if (reg_date.getDateYMD.add(Duration(days: 30)).isBefore(DateTime.now())) {
      return 0;
    }
    return -1;
  }
}
