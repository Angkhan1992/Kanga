class ResultModel {
  String id = '';
  String left_leg = '0.0';
  String right_leg = '0.0';
  int sit_stand = 0;
  String ten_sec = '0.0';
  String ten_meter = '0.0';
  String mode = 'SENSOR'; //Sensor or Voice
  String type = 'SLB'; //SLB, STS, TMW
  String date_time = '1990-01-01';

  ResultModel({
    this.id = '',
    this.left_leg = '',
    this.right_leg = '',
    this.sit_stand = 0,
    this.ten_sec = '',
    this.ten_meter = '',
    this.mode = '',
    this.type = '',
    this.date_time = '1900-01-01',
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      id: json["id"],
      left_leg: json["left_leg"],
      right_leg: json["right_leg"],
      sit_stand: int.parse(json["sit_stand"]),
      ten_sec: json["ten_sec"],
      ten_meter: json["ten_meter"],
      mode: json["mode"],
      type: json["type"],
      date_time: json["date_time"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "left_leg": this.left_leg,
      "right_leg": this.right_leg,
      "sit_stand": this.sit_stand,
      "ten_sec": this.ten_sec,
      "ten_meter": this.ten_meter,
      "mode": this.mode,
      "type": this.type,
      "date_time": this.date_time,
    };
  }

  ResultModel clone() {
    return ResultModel(
      id: id,
      left_leg: left_leg,
      right_leg: right_leg,
      sit_stand: sit_stand,
      ten_sec: ten_sec,
      ten_meter: ten_meter,
      mode: mode,
      type: type,
      date_time: date_time,
    );
  }
}
