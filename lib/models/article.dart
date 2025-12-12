class Article {
  final String id;
  final String title;
  final String description;
  final String content;
  final String category;
  final String image;
  final String readTime;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    required this.image,
    required this.readTime,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      content: json['content'],
      category: json['category'],
      image: json['image'],
      readTime: json['read_time'],
    );
  }
}
