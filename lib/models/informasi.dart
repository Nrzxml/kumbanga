class Informasi {
  final String id;
  final String judul;
  final String deskripsi;
  final String tanggal;

  Informasi({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
  });

  factory Informasi.fromJson(Map<String, dynamic> json) {
    return Informasi(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      tanggal: json['tanggal'],
    );
  }
}
