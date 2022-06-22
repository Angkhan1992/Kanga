class MeasureModel {
  String id;
  String title;
  String desc_sensor;
  String desc_voice;
  String thumb_sensor;
  String thumb_voice;
  String video_sensor;
  String video_voice;
  String reg_date;
  String sort_num;
  String other;
  String f_release;

  MeasureModel({
    this.id = '',
    this.title = '',
    this.desc_sensor = '',
    this.desc_voice = '',
    this.thumb_sensor = '',
    this.thumb_voice = '',
    this.video_sensor = '',
    this.video_voice = '',
    this.reg_date = '',
    this.sort_num = '',
    this.other = '',
    this.f_release = '',
  });

  factory MeasureModel.fromJson(Map<String, dynamic> json) {
    return MeasureModel(
      id: json["id"],
      title: json["title"],
      desc_sensor: json["desc_sensor"],
      desc_voice: json["desc_voice"],
      thumb_sensor: json["thumb_sensor"],
      thumb_voice: json["thumb_voice"],
      video_sensor: json["video_sensor"],
      video_voice: json["video_voice"],
      reg_date: json["reg_date"],
      sort_num: json["sort_num"],
      other: json["other"],
      f_release: json["f_release"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "desc_sensor": this.desc_sensor,
      "desc_voice": this.desc_voice,
      "thumb_sensor": this.thumb_sensor,
      "thumb_voice": this.thumb_voice,
      "video_sensor": this.video_sensor,
      "video_voice": this.video_voice,
      "reg_date": this.reg_date,
      "sort_num": this.sort_num,
      "other": this.other,
    };
  }
}

enum MeasureAction {
  Prepare,
  PreData,
  Measure,
  Done,
}
