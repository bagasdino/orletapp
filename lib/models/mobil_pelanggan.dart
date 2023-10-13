class MobilPelanggan {
  final String noid;
  final String id_user;
  final String jenis_mobil;
  final String plat_mobil;
  final String no_simcard;
  final String imei;
  final String status;

  MobilPelanggan(
      {required this.noid,
      required this.id_user,
      required this.jenis_mobil,
      required this.plat_mobil,
      required this.no_simcard,
      required this.imei,
      required this.status});

  factory MobilPelanggan.fromJson(Map<String, dynamic> json) {
    return MobilPelanggan(
        noid: json['noid'],
        id_user: json['id_user'],
        jenis_mobil: json['jenis_mobil'],
        plat_mobil: json['plat_mobil'],
        no_simcard: json['no_simcard'],
        imei: json['imei'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() => {
        'noid': noid,
        'id_user': id_user,
        'jenis_mobil': jenis_mobil,
        'plat_mobil': plat_mobil,
        'no_simcard': no_simcard,
        'imei': imei,
        'status': status,
      };
}
