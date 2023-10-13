class MobilAktif {
  final String status;
  final String jumlah;

  MobilAktif({required this.status, required this.jumlah});

  factory MobilAktif.fromJson(Map<String, dynamic> json) {
    return MobilAktif(
      status: json['status'],
      jumlah: json['jumlah'],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'jumlah': jumlah,
      };
}
