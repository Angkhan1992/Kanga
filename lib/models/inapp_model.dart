class InAppModel {
  String? id;
  String? title;
  String? yPackage;
  String? mPackage;
  String? yValue;
  String? mValue;
  String? discount;
  String? regDate;
  String? endDate;
  String? other;

  InAppModel({
    this.id,
    this.title,
    this.yPackage,
    this.mPackage,
    this.yValue,
    this.mValue,
    this.discount,
    this.regDate,
    this.endDate,
    this.other,
  });

  factory InAppModel.fromJson(Map<String, dynamic> json) {
    return InAppModel(
      id: json["ia_id"],
      title: json["ia_title"],
      yPackage: json["ia_package_year"],
      mPackage: json["ia_package_month"],
      yValue: json["ia_value_year"],
      mValue: json["ia_value_month"],
      discount: json["ia_discount"],
      regDate: json["reg_date"],
      endDate: json["end_date"],
      other: json["other"],
    );
  }
}
