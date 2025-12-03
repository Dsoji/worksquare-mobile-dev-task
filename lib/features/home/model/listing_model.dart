class Listing {
  const Listing({
    required this.id,
    required this.title,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.location,
    required this.status,
    required this.image,
  });

  final int id;
  final String title;
  final String price;
  final int bedrooms;
  final int bathrooms;
  final String location;
  final List<String> status;
  final String image;

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as int,
      title: json['title'] as String,
      price: json['price'] as String,
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int,
      location: json['location'] as String,
      status: (json['status'] as List<dynamic>).cast<String>(),
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'price': price,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'location': location,
      'status': status,
      'image': image,
    };
  }
}
