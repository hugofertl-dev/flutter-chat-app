// To parse this JSON data, do
//
//     final mesanjesResponse = mesanjesResponseFromJson(jsonString);

import 'dart:convert';

MesanjesResponse mesanjesResponseFromJson(String str) =>
    MesanjesResponse.fromJson(json.decode(str));

String mesanjesResponseToJson(MesanjesResponse data) =>
    json.encode(data.toJson());

class MesanjesResponse {
  MesanjesResponse({
    this.ok,
    this.mesajes,
  });

  bool ok;
  List<Mesaje> mesajes;

  factory MesanjesResponse.fromJson(Map<String, dynamic> json) =>
      MesanjesResponse(
        ok: json["ok"],
        mesajes:
            List<Mesaje>.from(json["mesajes"].map((x) => Mesaje.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "mesajes": List<dynamic>.from(mesajes.map((x) => x.toJson())),
      };
}

class Mesaje {
  Mesaje({
    this.de,
    this.para,
    this.mensaje,
    this.createdAt,
    this.updatedAt,
  });

  String de;
  String para;
  String mensaje;
  DateTime createdAt;
  DateTime updatedAt;

  factory Mesaje.fromJson(Map<String, dynamic> json) => Mesaje(
        de: json["de"],
        para: json["para"],
        mensaje: json["mensaje"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "de": de,
        "para": para,
        "mensaje": mensaje,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
