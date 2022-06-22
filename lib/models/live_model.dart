class LiveModel {
  String id;
  String admin_id;
  String reg_date;
  String meet_date;
  String title;
  String detail;
  String show_name;
  String join_counter;
  String join_link;
  String join_id;
  String join_pass;
  int join_user;
  bool is_accept;
  String other;

  LiveModel({
    this.id = '',
    this.admin_id = '',
    this.reg_date = '',
    this.meet_date = '',
    this.title = '',
    this.detail = '',
    this.show_name = '',
    this.join_counter = '',
    this.join_link = '',
    this.join_id = '',
    this.join_pass = '',
    this.join_user = 0,
    this.is_accept = false,
    this.other = '',
  });

  factory LiveModel.fromJson(Map<String, dynamic> json) {
    return LiveModel(
      id: json["id"],
      admin_id: json["admin_id"],
      reg_date: json["reg_date"],
      meet_date: json["meet_date"],
      title: json["title"],
      detail: json["detail"],
      show_name: json["show_name"],
      join_counter: json["join_counter"],
      join_link: json["join_link"],
      join_id: json["join_id"],
      join_pass: json["join_pass"],
      join_user: json["join_user"],
      is_accept: json["is_accept"],
      other: json["other"],
    );
  }

}
