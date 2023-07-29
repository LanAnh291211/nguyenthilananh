class ProductModel {
  final num id;
  final String errorDescription;
   String name;
   String sku;
  final String image;
   num? color;

  ProductModel({
    required this.id,
    required this.errorDescription,
    required this.name,
    required this.sku,
    required this.image,
    this.color,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      errorDescription: json['errorDescription'],
      name: json['name'],
      sku: json['sku'],
      image: json['image'],
      color: json['color'],
    );
  }
  // toJson() 
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'errorDescription': errorDescription,
      'name': name,
      'sku': sku,
      'image': image,
      'color': color,
    };
  }
}

class ColorModel {
  final num id;
  final String name;

  ColorModel(this.id, this.name);

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      json['id'] ,
      json['name']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
