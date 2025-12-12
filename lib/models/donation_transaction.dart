class DonationTransaction {
  final int id;
  final int campaignId;
  final int? userId;
  final int amount;
  final DateTime createdAt;

  DonationTransaction({
    required this.id,
    required this.campaignId,
    this.userId,
    required this.amount,
    required this.createdAt,
  });

  factory DonationTransaction.fromJson(Map<String, dynamic> json) {
    return DonationTransaction(
      id: int.parse(json['id'].toString()),
      campaignId: int.parse(json['campaign_id'].toString()),
      userId: json['user_id'] != null
          ? int.tryParse(json['user_id'].toString())
          : null,
      amount: int.parse(json['amount'].toString()),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
