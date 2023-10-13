class Tagih {
  final int biaya;

  Tagih({required this.biaya});

  factory Tagih.fromJson(Map<String, dynamic> json) {
    return Tagih(
      biaya: json['jumlah_tagihan'],
    );
  }

  Map<String, dynamic> toJson() => {
        'jumlah_tagihan': biaya,
      };
}
