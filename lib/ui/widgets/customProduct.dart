import 'dart:convert';
import 'dart:io';

import 'package:compound/models/user_details.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../ui/shared/app_colors.dart' as col;

class CustomProduct extends StatefulWidget {
  UserDetails details;
  CustomProduct({required this.details});
  @override
  State<CustomProduct> createState() => _CustomProductState();
}

class _CustomProductState extends State<CustomProduct> {
  File? uploadimage = null;
  final descriptionFocus = FocusNode();
  String description = '';
  TextEditingController _textController = TextEditingController();
  bool showProgressIndicator = false;
  String imageUrl = '';
  bool showButton = false;
  int maxline = 1;
  int size = 300;
  bool addSize = true;

  Future<void> chooseImage(bool camera) async {
    final ImagePicker picker = ImagePicker();
    var choosedimage = await picker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery);
    // uploadimage = File(choosedimage!.path);

    setState(() {
      size += 200;
      uploadimage = File(choosedimage!.path);
    });
  }

  Future<void> addProductDetails() async {
    final url = Uri.https(
        'test-1a01a-default-rtdb.firebaseio.com', '/customProduct.json');
    try {
      // var details = await _apiService.getUserData();
      await http.post(url,
          body: json.encode({
            'name': widget.details.name,
            'customerId': widget.details.key.toString(),
            'customerPhone': {
              'code': widget.details.contact!.phone!.code,
              'mobile': widget.details.contact!.phone!.mobile,
            },
            'description': description,
            'Image': imageUrl,
          }));
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadImage() async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot =
        FirebaseStorage.instanceFor(bucket: "gs://test-1a01a.appspot.com")
            .ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      //Store the file
      await referenceImageToUpload.putFile(
          uploadimage!,
          SettableMetadata(
            contentType: "image/jpeg",
          ));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      if (imageUrl.isNotEmpty) {
        print("Image Uploaded");
        print(imageUrl);
      }
    } catch (e) {
      print(e);
      //there is error during converting file image to base64 encoding.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 8.0,
        right: 8.0,
        left: 8.0,
        bottom: MediaQuery.of(context).padding.bottom + 8.0,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Container(
        height: size.toDouble(),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Align(
              child: Container(
                decoration: BoxDecoration(
                    color: col.darkGrey.withOpacity(0.9),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                height: 5,
                width: 150,
              ),
            ),
            Text("Build a Product 🧶",
                style: TextStyle(
                    fontSize: 20.0,
                    color: col.lightGrey.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins')),
            Text("Describe a Product we can create for you !",
                style: TextStyle(
                    fontSize: 10.0,
                    color: col.lightGrey.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins')),
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter the description";
                  }
                  return null;
                },
                controller: _textController,
                maxLines: maxline,
                decoration: InputDecoration(
                  hintText: "* Describe your WISH",
                  hintStyle: TextStyle(
                    color: col.lightGrey.withOpacity(0.7),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: col.lightGrey.withOpacity(0.9),
                    ),
                  ),
                ),
                onChanged: (value) {
                  description = value;
                  setState(() {
                    if (description.length > 80) {
                      maxline = 3;
                    } else if (description.length > 35) {
                      maxline = 2;
                    } else {
                      maxline = 1;
                    }
                  });
                },
                focusNode: descriptionFocus,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    child: uploadimage == null
                        ? Container()
                        : SizedBox(
                            height: 150, child: Image.file(uploadimage!))),
                showProgressIndicator
                    ? Container()
                    : uploadimage == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      chooseImage(false);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.folder_open,
                                      color: col.logoRed,
                                      size: 26,
                                    ),
                                    label: Text("CHOOSE IMAGE",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: col.logoRed,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins')),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Colors.white,
                                        ),
                                        elevation: MaterialStateProperty.all(0),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          side: BorderSide(
                                              color: col.logoRed, width: 2.5),
                                        )))),
                              ),
                              Container(
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      chooseImage(true);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.camera_alt_outlined,
                                      color: col.logoRed,
                                      size: 26,
                                    ),
                                    label: Text("TAKE IMAGE",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: col.logoRed,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins')),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Colors.white,
                                        ),
                                        elevation: MaterialStateProperty.all(0),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          side: BorderSide(
                                              color: col.logoRed, width: 2.5),
                                        )))),
                              ),
                            ],
                          )
                        : Container(
                            width: 300,
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    uploadimage = null;
                                    size -= 200;
                                  });
                                },
                                icon: Icon(Icons.delete_forever),
                                label: Text("Delete Image"),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.red,
                                    ),
                                    elevation: MaterialStateProperty.all(0),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))))),
              ],
            ),
            showProgressIndicator
                ? CircularProgressIndicator(
                    color: col.logoRed,
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: description.isEmpty
                            ? col.lightGrey.withOpacity(0.3)
                            : col.logoRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (description.isEmpty) {
                          return;
                        } else {
                          setState(() {
                            showProgressIndicator = true;
                          });
                          uploadImage();
                          addProductDetails()
                              .then((value) => Navigator.of(context).pop())
                              .then((value) => Get.snackbar("Yayy 🎉",
                                  "Thanks for sending us your wish. \nWe’ll get back within 24 hours! ⏰",
                                  snackPosition: SnackPosition.BOTTOM));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
