class DonationCampaign {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final int totalDonation;
  final DateTime createdAt;

  DonationCampaign({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.totalDonation,
    required this.createdAt,
  });

  factory DonationCampaign.fromJson(Map<String, dynamic> json) {
    return DonationCampaign(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      totalDonation: int.tryParse(json['total_donation'].toString()) ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
