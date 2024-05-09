import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/colors.dart';

class CommonImagePicker {
  openCustomFilePickerSheet(
      {required BuildContext context,
      bool isMultipleSelection = false,

      required Function(dynamic selectedFile) onTap}) async {
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 1,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 36,
                          width: 36,
                        ),
                        const Text(
                          "Choose option",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: primaryBlack,
                              )),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      onTap(getFromCamera());
                    },
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 15),
                      child: Icon(
                        CupertinoIcons.camera,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      "Camera",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      onTap(getVideoFromCamera());
                    },
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 15),
                      child: Icon(
                        CupertinoIcons.camera,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      "Video",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      onTap(getFromGallery());
                    },
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 15),
                      child: Icon(
                        CupertinoIcons.photo_on_rectangle,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      "Upload photo from gallery",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      onTap(getVideoFromGallery());
                    },
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 15),
                      child: Icon(
                        CupertinoIcons.photo_on_rectangle,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      "Upload video from gallery",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
// select file from user device
  //  selectFiles(FileType fileType) async {
  //   List<String> selectedFil
  //   final _images;
  //   if (fileType == FileType.custom) {
  //     _images = await FilePicker.platform.pickFiles(
  //         type: fileType, allowMultiple: true, allowedExtensions: ['pdf']);
  //   } else {
  //     _images = await FilePicker.platform.pickFiles(
  //       type: fileType,
  //       allowMultiple: true,
  //     );
  //   }
  //   if (_images != null) {
  //     _images.files.forEach((element) {
  //       imageFileList.add(element.path!);
  //       imageFileList.refresh();
  //     });
  //   }
  // }



  Future<File?> getFromCamera() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<File?> getVideoFromCamera() async {
    XFile? image = await ImagePicker().pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(seconds: 30));
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<File?> getFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<File?> getVideoFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
}
