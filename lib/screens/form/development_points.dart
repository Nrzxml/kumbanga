// lib/screen/form/development_points.dart

class DevelopmentPoint {
  final String key;
  final String label;

  const DevelopmentPoint({
    required this.key,
    required this.label,
  });
}

/// ===============================
/// PERTUMBUHAN FISIK
/// ===============================
final Map<int, List<DevelopmentPoint>> physicalPoints = {
  6: const [
    DevelopmentPoint(
        key: 'p1', label: 'Berat dan panjang badan sesuai grafik WHO.'),
    DevelopmentPoint(key: 'p2', label: 'Lingkar kepala bertambah sesuai usia.'),
    DevelopmentPoint(
        key: 'p3',
        label: 'Tidak ada penurunan berat badan dalam 2 bulan terakhir.'),
  ],
  9: const [
    DevelopmentPoint(
        key: 'p1',
        label: 'Berat dan tinggi badan naik konsisten setiap bulan.'),
    DevelopmentPoint(key: 'p2', label: 'Panjang badan tidak stagnan.'),
    DevelopmentPoint(key: 'p3', label: 'Tidak menunjukkan tanda gizi kurang.'),
  ],
  12: const [
    DevelopmentPoint(
        key: 'p1', label: 'Tinggi badan sesuai usia (tidak pendek).'),
    DevelopmentPoint(
        key: 'p2', label: 'Berat badan stabil sesuai kurva pertumbuhan.'),
    DevelopmentPoint(
        key: 'p3', label: 'Tidak sering sakit dalam 3 bulan terakhir.'),
  ],
  18: const [
    DevelopmentPoint(
        key: 'p1', label: 'Tinggi badan berada di atas batas stunting WHO.'),
    DevelopmentPoint(key: 'p2', label: 'Berat badan meningkat sesuai usia.'),
    DevelopmentPoint(
        key: 'p3',
        label: 'Tidak mengalami penurunan nafsu makan berkepanjangan.'),
  ],
};

/// ===============================
/// MOTORIK & KOGNITIF
/// ===============================
final Map<int, List<DevelopmentPoint>> cognitivePoints = {
  6: const [
    DevelopmentPoint(key: 'c1', label: 'Bisa tengkurap dan mulai berguling.'),
    DevelopmentPoint(key: 'c2', label: 'Kepala stabil saat duduk dipangku.'),
    DevelopmentPoint(key: 'c3', label: 'Mulai meraih dan memegang benda.'),
  ],
  9: const [
    DevelopmentPoint(key: 'c1', label: 'Bisa duduk tanpa bantuan.'),
    DevelopmentPoint(key: 'c2', label: 'Mulai merangkak atau bergerak aktif.'),
    DevelopmentPoint(key: 'c3', label: 'Responsif saat dipanggil namanya.'),
  ],
  12: const [
    DevelopmentPoint(key: 'c1', label: 'Bisa berdiri dan mulai melangkah.'),
    DevelopmentPoint(key: 'c2', label: 'Mengambil benda kecil dengan jari.'),
    DevelopmentPoint(key: 'c3', label: 'Meniru suara atau kata sederhana.'),
  ],
  18: const [
    DevelopmentPoint(
        key: 'c1', label: 'Bisa berjalan stabil atau berlari kecil.'),
    DevelopmentPoint(key: 'c2', label: 'Menggunakan sendok sederhana.'),
    DevelopmentPoint(key: 'c3', label: 'Mengucapkan 5–10 kata bermakna.'),
  ],
};

/// ===============================
/// GIZI & POLA ASUH
/// ===============================
final Map<int, List<DevelopmentPoint>> socialPoints = {
  6: const [
    DevelopmentPoint(key: 's1', label: 'ASI eksklusif hingga 6 bulan.'),
    DevelopmentPoint(
        key: 's2', label: 'Mulai MPASI tekstur halus tinggi protein.'),
    DevelopmentPoint(key: 's3', label: 'MPASI minimal 2 kali sehari.'),
  ],
  9: const [
    DevelopmentPoint(key: 's1', label: 'MPASI tekstur lumat/kasar.'),
    DevelopmentPoint(key: 's2', label: 'Protein hewani minimal 1x sehari.'),
    DevelopmentPoint(key: 's3', label: 'Makan 3x + 1–2 selingan.'),
  ],
  12: const [
    DevelopmentPoint(key: 's1', label: 'Makanan keluarga dipotong kecil.'),
    DevelopmentPoint(key: 's2', label: 'Protein hewani setiap hari.'),
    DevelopmentPoint(
        key: 's3', label: 'Minum cukup, tidak bergantung susu saja.'),
  ],
  18: const [
    DevelopmentPoint(key: 's1', label: 'Makan 3x + 2 snack sehat.'),
    DevelopmentPoint(key: 's2', label: 'Protein hewani rutin.'),
    DevelopmentPoint(key: 's3', label: 'Tidur dan aktivitas teratur.'),
  ],
};
