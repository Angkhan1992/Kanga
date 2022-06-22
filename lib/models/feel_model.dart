class FeelModel {
  String id;
  String user_id;
  String reg_date;
  String feel;
  String other;

  FeelModel({
    this.id = '',
    this.user_id = '',
    this.reg_date = '',
    this.feel = '',
    this.other = '',
  });

  factory FeelModel.fromJson(Map<String, dynamic> json) {
    return FeelModel(
      id: json["id"],
      user_id: json["user_id"],
      reg_date: json["reg_date"],
      feel: json["feel"],
      other: json["other"],
    );
  }

}
