class Ketahanan {
  String? koinId;
  String? modal;
  String? ketahanan;
  String? selisih;
  String? margin;
  String? indikator;
  String? mode;
  String? kenaikan;

  Ketahanan(
      {this.koinId,
      this.modal,
      this.ketahanan,
      this.selisih,
      this.margin,
      this.indikator,
      this.kenaikan,
      this.mode});

  factory Ketahanan.fromJson(Map<String, dynamic> json) {
    return Ketahanan(
      koinId: json['koin_id'],
      modal: json['modal'],
      ketahanan: json['ketahanan'],
      selisih: json['selisih'],
      margin: json['margin'] ?? '0',
      indikator: json['indikator'],
      mode: json['mode'],
      kenaikan: json['kenaikan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'koin_id': koinId,
      'modal': modal,
      'ketahanan': ketahanan,
      'selisih': selisih,
      'margin': margin,
      'indikator': indikator,
      'mode': mode,
      'kenaikan': kenaikan,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['koin_id'] = koinId;
    data['modal'] = modal;
    data['ketahanan'] = ketahanan;
    data['selisih'] = selisih;
    data['indikator'] = indikator;
    data['mode'] = mode;
    data['kenaikan'] = kenaikan;
    return data;
  }
}
