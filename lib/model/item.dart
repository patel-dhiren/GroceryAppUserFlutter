class Item {
  String? id;
  String name;
  String description;
  double price;
  int stock;
  String unit;
  String categoryId;
  String imageUrl;
  int createdAt;
  bool inTop = false;

  Item(
      {this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.stock,
      required this.unit,
      required this.categoryId,
      required this.imageUrl,
      required this.createdAt,
      this.inTop = false});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "description": this.description,
      "price": this.price,
      "stock": this.stock,
      "unit": this.unit,
      "categoryId": this.categoryId,
      "imageUrl": this.imageUrl,
      "createdAt": this.createdAt,
      "inTop": this.inTop,
    };
  }

  factory Item.fromJson(Map<dynamic, dynamic> json) {
    return Item(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      price: double.parse(json["price"].toString()),
      stock: json["stock"],
      unit: json["unit"],
      categoryId: json["categoryId"],
      imageUrl: json["imageUrl"],
      createdAt: json["createdAt"],
      inTop: json["inTop"],
    );
  }
//
}
