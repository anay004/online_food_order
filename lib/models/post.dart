class Post {
  String? id;
  String? foodName;
  String? foodImage;
  double? price; // Price is a double, so make sure it's properly handled when passed/received.
  String? category;
  String? rating;

  // Constructor
  Post({
    required this.id,
    required this.price, // The price should be passed as a double.
    required this.foodName,
    required this.foodImage,
    required this.category,
    required this.rating,
  });

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price, // Ensure price is serialized as a double
      'foodName': foodName,
      'foodImage': foodImage,
      'category': category,
      'raring': rating,
    };
  }

  // Method to create object from JSON
  static Post fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      price: json['price'] is double ? json['price'] : double.tryParse(json['price'].toString()) ?? 0.0, // Safely parse price to double
      foodName: json['foodName'],
      foodImage: json['foodImage'],
      category: json['category'],
      rating: json['rating'],
    );
  }
}
