import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:mime/mime.dart';
// ignore: unused_import
// ignore: depend_on_referenced_packages, unused_import
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:http/http.dart' as http;
import 'package:medmesuk/objectscreen/chair.dart';
// ignore: unused_import
import 'package:medmesuk/objectscreen/default.dart';
import 'package:path_provider/path_provider.dart';
import 'product.dart';

class ClassesListScreen extends StatelessWidget {
  final List<ResultObjectDetection?> objDetect;
  final List<Product> products;

  // ignore: use_key_in_widget_constructors
  const ClassesListScreen({required this.objDetect, required this.products});

  @override
  Widget build(BuildContext context) {
    final classes = objDetect
        .map((e) => e?.className)
        .where((className) => className != 'person')
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Detected Classes")),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final className = classes[index];
          return ListTile(
            title: Text(className ?? "Unknown"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassDetailsPage(
                        className: className, products: products),
                  ));

              /*
              switch (className) {
                case 'char':
                  navigateToPage(context, className!);
                  break;
                default:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassDetailsPage(
                            className: className, products: products),
                      ));
              }
              */
            },
          );
        },
      ),
    );
  }
}

class ClassDetailsPage extends StatelessWidget {
  final String? className;
  final List<Product> products;

  // ignore: use_key_in_widget_constructors
  const ClassDetailsPage({required this.className, required this.products});

  @override
  Widget build(BuildContext context) {
    final filteredProducts =
        products.where((product) => product.className == className).toList();
    return Scaffold(
      appBar: AppBar(title: Text(className ?? "Unknown")),
      body: filteredProducts.isEmpty
          ? const Center(child: Text("Not Found"))
          : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(product: product);
              },
            ),
    );
  }
}

void navigateToPage(BuildContext context, String nameclass,
    {String? className}) {
  switch (nameclass) {
    case 'chair':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Chair()),
      );
      break;
    /*
    default:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Default()),
      );
    */
  }
}

Future<void> openImageInVSCode(String imagePath) async {
  try {
    await Process.run('code', [imagePath]);
  } catch (e) {
    // ignore: avoid_print
    print('Error opening image in VSCode: $e');
  }
}

Future<Directory> getProjectDir() async {
  return Directory.current;
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10.0),
        leading: Image.network(product.imageUrl,
            fit: BoxFit.cover, width: 50, height: 50),
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("฿${product.price}",
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

List<Product> parseProducts(String jsonResponse) {
  final parsed = json.decode(jsonResponse);
  final productList = parsed['result'] as List;
  return productList.map((json) => Product.fromJson(json)).toList();
}

/*
Future<http.Response> uploadImageToGemini(File imageFile) async {
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('https://nlp.wedolabs.net/ytp2024/search/'),
  );
  /*
  request.files.add(await http.MultipartFile.fromPath(
    'image',
    imageFile.path,
    contentType: MediaType('image', 'png'),
  ));
  */
  final response = await request.send();
  return await http.Response.fromStream(response);
}
*/
/*
Future<List<Product>?> uploadImageWithRetry(File imageFile,
    {int retryCount = 3}) async {
  for (int attempt = 0; attempt < retryCount; attempt++) {
    final response = await uploadImageToGemini(imageFile);

    if (response.statusCode == 200) {
      // Upload สำเร็จ
      final productsFromResponse = parseProducts(response.body);
      return productsFromResponse;
    } else if (response.statusCode == 400) {
      // Bad Request - แสดงข้อความข้อผิดพลาดและหยุด retry
      // ignore: avoid_print
      print('Bad Request: Please check the data being sent.');
      return null; // หยุดการ retry
    } else if (attempt < retryCount - 1) {
      // ถ้าไม่ใช่ความพยายามสุดท้าย ให้หน่วงเวลาสักครู่แล้วลองอีกครั้ง
      await Future.delayed(const Duration(seconds: 2));
    } else {
      // ถ้าเป็นความพยายามครั้งสุดท้ายแล้วล้มเหลว ให้พิมพ์ข้อความแสดงข้อผิดพลาด
      // ignore: avoid_print
      print('Failed to upload image to Gemini: ${response.statusCode}');
    }
  }
  return null; // คืนค่า null ถ้าการอัปโหลดล้มเหลวทุกครั้ง
}
*/

/*
Future<http.Response> uploadImageToGemini(File imageFile) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://nlp.wedolabs.net/ytp2024/search/'),
  );

  // เพิ่มไฟล์ในคำขอ
  request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  // เพิ่ม headers หรือ fields ตามที่จำเป็น
  request.headers.addAll({
    'Content-Type': 'multipart/form-data',
    // เพิ่ม headers อื่นๆ ที่จำเป็น เช่น Authorization
  });

  // ส่งคำขอและรับผลลัพธ์
  return await http.Response.fromStream(await request.send());
}
*/

Future<void> uploadCroppedImage(imageBytes) async {
  try {
    // สร้างคำขอ multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://nlp.wedolabs.net/ytp2024/search/'),
    );

    // แปลง byte array เป็นไฟล์ชั่วคราว (ในกรณีนี้ไม่จำเป็นต้องทำ แต่ทำเพื่อแสดงตัวอย่าง)
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/temp_image.png');
    await tempFile.writeAsBytes(imageBytes as List<int>);

    // เพิ่มไฟล์ลงในคำขอ
    request.files.add(await http.MultipartFile.fromPath('file', tempFile.path));

    // ส่งคำขอไปที่เซิร์ฟเวอร์
    var response = await request.send();

    if (response.statusCode == 200) {
      // ignore: avoid_print
      print('Image uploaded successfully');
      // แปลง response.body เป็น string แล้วจัดการผลลัพธ์ตามต้องการ
      final responseString = await response.stream.bytesToString();
      // ignore: avoid_print
      print(responseString);
    } else {
      // ignore: avoid_print
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // ignore: avoid_print
    print('Error occurred while uploading image: $e');
  }
}

/*
Future<http.Response> uploadImageToGemini(Uint8List imageBytes) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://nlp.wedolabs.net/ytp2024/search/'),
  );

  // สร้าง MultipartFile จาก byte array
  request.files.add(http.MultipartFile.fromBytes(
    'file', // ชื่อ field
    imageBytes,
    filename: 'image.png', // ตั้งชื่อไฟล์ที่เหมาะสม
    contentType: MediaType('image', 'png'), // กำหนด MIME type ของไฟล์
  ));

  // เพิ่ม headers หรือ fields ตามที่จำเป็น
  request.headers.addAll({
    'Content-Type': 'multipart/form-data',
    // เพิ่ม headers อื่นๆ ที่จำเป็น เช่น Authorization
  });

  // ส่งคำขอและรับผลลัพธ์
  return await http.Response.fromStream(await request.send());
}
*/

Future<http.Response> uploadImageToGemini(
    Uint8List imageBytes, String mimeType) async {
  final uri = Uri.parse('https://nlp.wedolabs.net/ytp2024/search/');

  final request = http.MultipartRequest('POST', uri)
    ..files.add(
      http.MultipartFile.fromBytes(
        'file', // ชื่อฟิลด์ที่เซิร์ฟเวอร์คาดหวัง
        imageBytes,
        contentType: MediaType.parse(mimeType),
      ),
    );

  final response = await request.send();
  return http.Response.fromStream(response);
}
/*
Future<void> uploadImage(File imageFile) async {
  String url = 'https://nlp.wedolabs.net/ytp2024/search/';

  String? mimeType = lookupMimeType(imageFile.path);
  var mimeTypeData = mimeType?.split('/');

  if (mimeTypeData == null) {
    // ignore: avoid_print
    print('Could not determine mime type for ${imageFile.path}');
    return;
  }

  var request = http.MultipartRequest('POST', Uri.parse(url))
    ..files.add(
      await http.MultipartFile.fromPath(
        'file', // Make sure 'file' is the correct parameter name
        imageFile.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ),
    );

  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      // ignore: avoid_print
      print('File uploaded successfully!');
      var responseData = await response.stream.bytesToString();
      // ignore: avoid_print
      print('Response data: $responseData');
    } else {
      // ignore: avoid_print
      print('Failed to upload file. Status code: ${response.statusCode}');
      var responseData = await response.stream.bytesToString();
      // ignore: avoid_print
      print(
          'Response data: $responseData'); // Log the response data for more details
    }
  } catch (e) {
    // ignore: avoid_print
    print('Error uploading file: $e');
  }
}
*/

Future<http.Response?> uploadImage(File imageFile) async {
  String url = 'https://nlp.wedolabs.net/ytp2024/search/';

  String? mimeType = lookupMimeType(imageFile.path);
  var mimeTypeData = mimeType?.split('/');

  if (mimeTypeData == null) {
    // ignore: avoid_print
    print('Could not determine mime type for ${imageFile.path}');
    return null; // หรือคุณอาจส่ง http.Response แบบกำหนดเองก็ได้
  }

  var request = http.MultipartRequest('POST', Uri.parse(url))
    ..files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ),
    );

  try {
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response;
  } catch (e) {
    // ignore: avoid_print
    print('Error uploading file: $e');
    return null; // หรือคุณอาจส่ง http.Response แบบกำหนดเองก็ได้
  }
}
