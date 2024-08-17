// ignore: unused_import
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medmesuk/function/product.dart';
import 'dart:async';
import 'dart:io';
// ignore: depend_on_referenced_packages, unused_import
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
// ignore: unused_import
import 'package:image/image.dart' as img;
import 'package:flutter_pytorch/pigeon.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'package:medmesuk/function/LoaderState.dart';
import 'package:medmesuk/function/func.dart';
// ignore: depend_on_referenced_packages, unused_import
import 'package:path/path.dart' as path;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ModelObjectDetection _objectModel;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool objectDetection = false;
  List<ResultObjectDetection?> objDetect = [];
  bool firststate = false;
  bool message = true;
  //List<Product> products = [];
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    String pathObjectDetectionModel = "assets/models/yolov5s.torchscript";
    try {
      _objectModel = await FlutterPytorch.loadObjectDetectionModel(
          // change the 80 with number of classes in your model pretrained yolov5 had almost 80 classes so I added 80 here.
          pathObjectDetectionModel,
          80,
          640,
          640,
          labelPath: "assets/labels/labels.txt");
    } catch (e) {
      if (e is PlatformException) {
        // ignore: avoid_print
        print("only supported for android, Error is $e");
      } else {
        // ignore: avoid_print
        print("Error is $e");
      }
    }
  }

  void handleTimeout() {
    // callback function
    // Do some work.
    setState(() {
      firststate = true;
    });
  }

  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);
  //running detections on image
  Future<void> runObjectDetection() async {
    setState(() {
      firststate = false;
      message = false;
    });
    //pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      objDetect = await _objectModel.getImagePrediction(
          await File(image.path).readAsBytes(),
          minimumScore: 0.1,
          IOUThershold: 0.3);
      // ignore: unused_local_variable
      //final response = await uploadImage(File(image.path));
      // ignore: avoid_print
      print("printing image path now");
      // ignore: avoid_print
      print(image.path);
      objDetect =
          objDetect.where((element) => element?.className != 'person').toList();
      Map<String, double> maxScores = {};

      for (var element in objDetect) {
        if (element?.score != null && element?.className != null) {
          // ตรวจสอบว่าค่าคะแนนที่มีอยู่ในแมพน้อยกว่าค่าคะแนนของ element ปัจจุบัน
          if (maxScores[element!.className] == null ||
              element.score > maxScores[element.className]!) {
            maxScores[element.className!] = element.score;
          }
        }
      }
      // แปลง maxScores เป็นอาร์เรย์ของแมพที่เก็บ className และ max score
      List<Map<String, dynamic>> maxScoreArray = maxScores.entries
          .map((entry) => {
                "className": entry.key,
                "maxScore": entry.value,
              })
          .toList();
      // โหลดรูปภาพ
      List<int> imageBytes = await image.readAsBytes();
      Uint8List uint8List =
          Uint8List.fromList(imageBytes); // Convert to Uint8List
      img.Image? originalImage = img.decodeImage(uint8List);

      // ignore: avoid_print
      print("printing originalimage now");
      // ignore: avoid_print
      print(originalImage);

      if (originalImage == null) {
        // ignore: avoid_print
        print('Failed to load image.');
      }

      //List<Product> newProducts = [];
      for (var maxScoreEntry in maxScoreArray) {
        String className = maxScoreEntry["className"];
        double maxScore = maxScoreEntry["maxScore"];

        // หาวัตถุที่มี className และ maxScore ตรงกัน
        var maxElement = objDetect.firstWhere((element) =>
            element?.className == className && element?.score == maxScore);

        // ข้อมูลกรอบของวัตถุที่มีคะแนนสูงสุด
        var rect = maxElement?.rect;

        // ครอบรูปภาพตามกรอบที่มีคะแนนสูงสุด
        // ignore: unused_local_variable
        img.Image croppedImage = img.copyCrop(
          originalImage!,
          x: rect!.left.toInt(),
          y: rect.top.toInt(),
          width: rect.width.toInt(),
          height: rect.height.toInt(),
        );
        // ignore: avoid_print
        print("printing cropimage now");
        // ignore: avoid_print
        print(croppedImage);

        // ignore: unused_local_variable
        String croppedImagePath = path.join(
          (await getTemporaryDirectory()).path,
          'cropped_image_$className.jpg',
        );
        /*
        try {
          // Ensure the file is written successfully
          File(croppedImagePath)
              .writeAsBytesSync(img.encodeJpg(croppedImage), flush: true);

/*
          // Debugging: Check if the file exists and its size
          if (await File(croppedImagePath).exists()) {
            // ignore: avoid_print
            print('Cropped image file exists at $croppedImagePath');
            final fileSize = await File(croppedImagePath).length();
            // ignore: avoid_print
            print('Cropped image size: $fileSize bytes');
          } else {
            // ignore: avoid_print
            print('Cropped image file does not exist at $croppedImagePath');
            return;
          }
          */

          // Attempt to upload the file
          //final response = await uploadImage(File(croppedImagePath));
          // ignore: avoid_print
          //print('Upload response: $response');
        } catch (e) {
          // ignore: avoid_print
          print('Error during upload process: $e');
        }

        //File(croppedImagePath).writeAsBytesSync(img.encodeJpg(croppedImage));

        // ignore: unused_local_variable
        //Uint8List croppedImageBytes = encodeImageToBytes(croppedImage);
        //final response = await uploadImageToGemini(File(croppedImagePath));
        // ignore: unused_local_variable
        //String mimeType = 'image/jpg'; // หรือ 'image/jpeg' ถ้าคุณใช้ JPEG
        //final response = await uploadImageToGemini(croppedImageBytes, mimeType);
        // ignore: unused_local_variable

        final response = await uploadImage(File(croppedImagePath));
        // ignore: avoid_print
        print("printing cropimage path now");
        // ignore: avoid_print
        print(croppedImagePath);

        if (response != null && response.statusCode == 200) {
          // ignore: avoid_print
          print('Upload successful, parsing response body...');
          try {
            final productsFromResponse = parseProducts(response.body);
            newProducts.addAll(
              productsFromResponse.map((p) => p.copyWith(className: className)),
            );
            // ignore: avoid_print
            print('Products parsed and added successfully.');
          } catch (e) {
            // ignore: avoid_print
            print('Error parsing products: $e');
          }
        } else {
          if (response != null) {
            // ignore: avoid_print
            print('Failed to upload image: ${response.statusCode}');
            // ignore: avoid_print
            print('Response body: ${response.body}');
          } else {
            // ignore: avoid_print
            print('Upload failed: No response received.');
          }
        }
        */
      }
      /*
      for (var element in objDetect) {
        // ignore: avoid_print

        // ignore: avoid_print
        //print('Class Index: ${element?.classIndex}');
        // ignore: avoid_print
        //print('Class Name: ${element?.className}');

        // ignore: avoid_print
        print({
          "score": element?.score,
          "className": element?.className,
          "class": element?.classIndex,
          "rect": {
            "left": element?.rect.left,
            "top": element?.rect.top,
            "width": element?.rect.width,
            "height": element?.rect.height,
            "right": element?.rect.right,
            "bottom": element?.rect.bottom,
          },
        });
      }
      */
      scheduleTimeout(5 * 1000);
      /*
      for (var product in newProducts) {
        // ignore: avoid_print
        print('Product ClassName: ${product.className}');
        // ignore: avoid_print
        print('Product Name: ${product.name}');
        // ignore: avoid_print
        print('Product Price: ${product.price}');
        // ignore: avoid_print
        print('Product Image URL: ${product.imageUrl}');
        // ignore: avoid_print
        print('---');
      }
      */
      setState(() {
        _image = File(image.path);
        //products = newProducts;
      });
      // ignore: avoid_print
      print(maxScoreArray);
    } else {
      // Handle the case where the user cancels image selection
      // ignore: avoid_print
      print('No image selected. Object detection canceled.');
      setState(() {
        message = true;
      });
      // You can add additional actions here, like showing a message to the user.
// ignore: empty_statements
    }
  }

  Uint8List encodeImageToBytes(img.Image image) {
    return img.encodeJpg(image); // or use encodeJpg(image) if you prefer JPEG
  }
/*
  List<Product> parseProducts(String jsonResponse) {
    final parsed = json.decode(jsonResponse);
    final productList = parsed['result'] as List;
    return productList.map((json) => Product.fromJson(json)).toList();
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Image with Detections....
          Visibility(
            visible: firststate,
            child: const SizedBox(
              height: 190.0,
            ),
          ),
          !firststate
              ? !message
                  ? const LoaderState()
                  : const Text("Select the Camera to Begin Detections")
              : Expanded(
                  child: Container(
                      child:
                          _objectModel.renderBoxesOnImage(_image!, objDetect)),
                ),
          //Button to click pic
          Visibility(
            visible: firststate,
            child: const SizedBox(height: 20),
          ),
          ElevatedButton(
            onPressed: () async {
              // ignore: unused_local_variable
              await runObjectDetection();
            },
            child: const Icon(Icons.camera),
          ),
          Visibility(
            visible: firststate,
            child: const SizedBox(height: 20),
          ),
          Visibility(
            visible: firststate,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassesListScreen(
                        objDetect: objDetect, products: products),
                  ),
                );
              },
              child: const Text("View Detected Classes"),
            ),
          ),
          Visibility(
            visible: firststate,
            child: const SizedBox(height: 170),
          ),
        ],
      )),
    );
  }
}
