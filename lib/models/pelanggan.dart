class Pelanggan {
  final String id_pelanggan;
  final String nama;
  final String nomor_wa;
  final String alamat;
  final String username;
  final String password;
  final String jml;

  Pelanggan(
      {required this.id_pelanggan,
      required this.nama,
      required this.nomor_wa,
      required this.alamat,
      required this.username,
      required this.password,
      required this.jml});

  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    return Pelanggan(
      id_pelanggan: json['id_pelanggan'],
      nama: json['nama'],
      nomor_wa: json['nomor_wa'],
      alamat: json['alamat'],
      username: json['username'],
      password: json['password'],
      jml: json['jumlah_kendaraan'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_pelanggan': id_pelanggan,
        'nama': nama,
        'nomor_wa': nomor_wa,
        'alamat': alamat,
        'username': username,
        'password': password,
        'jml': jml,
      };
}
