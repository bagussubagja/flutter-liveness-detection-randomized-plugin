import 'dart:convert';

LivenessDetectionLabelModel livenessDetectionLabelModelFromJson(String str) =>
    LivenessDetectionLabelModel.fromJson(json.decode(str));

String livenessDetectionLabelModelToJson(LivenessDetectionLabelModel data) =>
    json.encode(data.toJson());

class LivenessDetectionLabelModel {
  String? smile;
  String? lookUp;
  String? lookDown;
  String? lookLeft;
  String? lookRight;
  String? blink;

  LivenessDetectionLabelModel({
    this.smile,
    this.lookUp,
    this.lookDown,
    this.lookLeft,
    this.lookRight,
    this.blink,
  });

  factory LivenessDetectionLabelModel.fromJson(Map<String, dynamic> json) =>
      LivenessDetectionLabelModel(
        smile: json["smile"],
        lookUp: json["lookUp"],
        lookDown: json["lookDown"],
        lookLeft: json["lookLeft"],
        lookRight: json["lookRight"],
        blink: json["blink"],
      );

  Map<String, dynamic> toJson() => {
    "smile": smile,
    "lookUp": lookUp,
    "lookDown": lookDown,
    "lookLeft": lookLeft,
    "lookRight": lookRight,
    "blink": blink,
  };
}
