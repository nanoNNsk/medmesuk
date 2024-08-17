class Product {
  final String className;
  final String imageUrl;
  final String name;
  final double price;

  Product({
    required this.className,
    required this.imageUrl,
    required this.name,
    required this.price,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    double parsePrice(String price) {
      price = price.replaceAll(',', '').replaceAll(' บาท', '');
      return double.tryParse(price) ?? 0.0;
    }

    return Product(
      className: "ClassNamePlaceholder",
      imageUrl: json['image_url'] as String,
      name: json['name'] as String,
      price: parsePrice(json['price'] as String),
    );
  }

  Product copyWith({
    String? className,
    String? imageUrl,
    String? name,
    double? price,
  }) {
    return Product(
      className: className ?? this.className,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }
}

List<Product> products = [
  Product(
    className: 'chair',
    imageUrl:
        'https://www.scghome.com/_next/image?url=https%3A%2F%2Fd2sfvqdmhak4f9.cloudfront.net%2Fproduct%252F319604%252Fimages%252F309802%252FP0009573-01.jpg&w=1920&q=75',
    name: 'LUCAS เก้าอี้ทำงาน มีที่พักเท้า รุ่น MD สีขาว',
    price: 2799.00,
  ),
  Product(
    className: 'chair',
    imageUrl:
        'https://www.scghome.com/_next/image?url=https%3A%2F%2Fd2sfvqdmhak4f9.cloudfront.net%2Fproduct%252F319596%252Fimages%252F309790%252FP0009569-01.jpg&w=1920&q=75',
    name: 'LUCAS เก้าอี้ทำงาน มีฟังก์ชั่นสั่น มีที่พักเท้า รุ่น Boss สีดำ',
    price: 3509.00,
  ),
  Product(
    className: 'chair',
    imageUrl:
        'https://www.scghome.com/_next/image?url=https%3A%2F%2Fd2sfvqdmhak4f9.cloudfront.net%2Fproduct%252F319618%252Fimages%252F309843%252FP0009580-01.jpg&w=1920&q=75',
    name: 'เก้าอี้ทำงานอเนกประสงค์พับได้ RESTAR รุ่น Easton สีดำ',
    price: 1659.00,
  ),
  Product(
    className: 'chair',
    imageUrl:
        'https://www.scghome.com/_next/image?url=https%3A%2F%2Fd2sfvqdmhak4f9.cloudfront.net%2Fproduct%252F319622%252Fimages%252F309849%252FP0009582-01.jpg&w=1920&q=75',
    name: 'เก้าอี้ทำงานอเนกประสงค์พับได้ RESTAR รุ่น Easton สีดำ เบาะสีน้ำตาล',
    price: 2039.00,
  ),
  Product(
    className: 'chair',
    imageUrl:
        'https://www.scghome.com/_next/image?url=https%3A%2F%2Fd2sfvqdmhak4f9.cloudfront.net%2Fproduct%252F326896%252Fimages%252F323184%252F5060444794410-01.jpg&w=1920&q=75',
    name: 'เก้าอี้พนักพิงสูง รุ่น COMFORT FIRENZE สีดำ',
    price: 2300.00,
  ),
  Product(
    className: 'chair',
    imageUrl:
        'https://www.scghome.com/_next/image?url=https%3A%2F%2Fd2sfvqdmhak4f9.cloudfront.net%2Fproduct%252F326894%252Fimages%252F323179%252F5056446107495-01.jpg&w=1920&q=75',
    name: 'เก้าอี้พนักพิงสูง รุ่น QUATTRO MILANO REDUX สีเขียว',
    price: 8400.00,
  ),
  Product(
    className: 'chair',
    imageUrl:
        'https://www.scghome.com/_next/image?url=https%3A%2F%2Fd2sfvqdmhak4f9.cloudfront.net%2Fproduct%252F319608%252Fimages%252F309808%252FP0009575-01.jpg&w=1920&q=75',
    name:
        'LUCAS เก้าอี้ เก้าอี้เกมมิ่ง เก้าอี้ทำงาน เก้าอี้พักผ่อน รุ่น Classic SR',
    price: 2089.00,
  ),
  Product(
    className: 'chair',
    imageUrl:
        'https://www.scghome.com/_next/image?url=https%3A%2F%2Fd2sfvqdmhak4f9.cloudfront.net%2Fproduct%252F326902%252Fimages%252F323201%252F5060646164356-01.jpg&w=1920&q=75',
    name: 'เก้าอี้แคมป์ปิ้ง รุ่น TUB180 สีเทาเข้ม',
    price: 2700.00,
  ),
  Product(
    className: 'chair',
    imageUrl:
        'https://www.scghome.com/_next/image?url=https%3A%2F%2Fd2sfvqdmhak4f9.cloudfront.net%2Fproduct%252F326910%252Fimages%252F323341%252F6951218428824-01.jpg&w=1920&q=75',
    name: 'เก้าอี้้แคมป์ปิ้ง รุ่น CMP-C1 สีเทาฟ้า',
    price: 6200.00,
  ),
  Product(
    className: 'chair',
    imageUrl:
        'https://www.scghome.com/_next/image?url=https%3A%2F%2Fd2sfvqdmhak4f9.cloudfront.net%2Fproduct%252F319610%252Fimages%252F309811%252FP0009576-01.jpg&w=1920&q=75',
    name: 'LUCAS เก้าอี้ทำงาน รุ่น P1 สีดำ',
    price: 2699.00,
  ),
];
