class Character {
  final String id;
  final String name;
  final String image;
  final String status;
  final String species;
  final String gender;
  final String type;

  Character({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.species,
    required this.gender,
    this.type = '',
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      species: json['species'] ?? '',
      gender: json['gender'] ?? '',
      type: json['type'] ?? '',
    );
  }
}