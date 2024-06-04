import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_link_manager/config/config.dart';
import 'package:smart_link_manager/models/news_model.dart';
import 'package:smart_link_manager/models/place_model.dart';
import 'package:smart_link_manager/news/photo_gallery.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/loading.dart';
import '../config/my_colors.dart';

class CreateNews extends StatefulWidget {
  final PlaceModel place;

  const CreateNews({super.key, required this.place});

  @override
  State<CreateNews> createState() => _CreateNewsState();
}

class _CreateNewsState extends State<CreateNews> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<CroppedFile> files = [];
  List<String> imagesDownloadUrl = [];
  List images = [];
  final picker = ImagePicker();
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();

  bool uploading = false;

  late String newsId;

  @override
  void initState() {
    newsId = DateTime.now().millisecondsSinceEpoch.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sSize = size.width / 7;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addNews),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.newsImages,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        )),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < images.length; i++)
                          Container(
                            margin: const EdgeInsets.all(4),
                            width: sSize,
                            height: sSize,
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PhotoGallery(
                                                  imagesUrl: [images[i]],
                                                  url: true,
                                                  index: 0,
                                                )));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            width: 2, color: MyColors.border),
                                        image: DecorationImage(
                                            image: NetworkImage(images[i]),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                                Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Opacity(
                                      opacity: 0.7,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            images.removeAt(i);
                                          });
                                        },
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: MyColors.border,
                                            borderRadius:
                                                BorderRadius.circular(500),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        for (int i = 0; i < files.length; i++)
                          Container(
                            margin: const EdgeInsets.all(4),
                            width: sSize,
                            height: sSize,
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PhotoGallery(
                                                    imagesUrl: [
                                                      File(files[i].path)
                                                    ],
                                                    url: false,
                                                    index: 0)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            width: 2, color: MyColors.border),
                                        image: DecorationImage(
                                            image:
                                                FileImage(File(files[i].path)),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                                Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Opacity(
                                      opacity: 0.7,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            files.removeAt(i);
                                          });
                                        },
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: MyColors.border,
                                            borderRadius:
                                                BorderRadius.circular(500),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        for (int i = 0;
                            i < 6 - files.length - images.length;
                            i++)
                          InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              takeImage(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              width: sSize,
                              height: sSize,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: MyColors.border, width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    MdiIcons.cameraPlusOutline,
                                    size: sSize / 2.5,
                                  ),
                                  Text(AppLocalizations.of(context)!.addPhoto)
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: kToolbarHeight / 3,
                            ),
                            Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.newsTitle,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                )),
                            TextFormField(
                              controller: _titleTextController,
                              maxLength: 30,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .errorRequired;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: MyColors.border, width: 2.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: MyColors.border, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: MyColors.border, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: MyColors.border, width: 2.0),
                                ),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .newsDescription,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                )),
                            TextFormField(
                              controller: _descriptionTextController,
                              scrollPadding: const EdgeInsets.only(bottom: 70),
                              maxLines: null,
                              minLines: 3,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .errorRequired;
                                }
                                return null;
                              },
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: MyColors.border, width: 2.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: MyColors.border, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: MyColors.border, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: MyColors.border, width: 2.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: kToolbarHeight / 3,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(8.0),
                width: size.width,
                child: uploading
                    ? const WhiteLoading()
                    : Center(
                        child: Text(
                          AppLocalizations.of(context)!.submit,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
              onPressed: () {
                if (!uploading) {
                  if (_formKey.currentState!.validate()) {
                    addInfo();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.fillAllInputsError)));
                  }
                }
              }),
        ],
      ),
    );
  }

  takeImage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.camera),
                  title: Text(AppLocalizations.of(context)!.camera),
                  onTap: () => {captureWithCamera()}),
              ListTile(
                leading: const Icon(Icons.image),
                title: Text(AppLocalizations.of(context)!.gallery),
                onTap: () => {pickPhotoFromGallery()},
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: Text(AppLocalizations.of(context)!.returnText),
                onTap: () => {Navigator.pop(context)},
              ),
            ],
          );
        });
  }

  captureWithCamera() async {
    Navigator.pop(context);
    final imageFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (imageFile != null) {
        _cropImage(imageFile);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (imageFile != null) {
        _cropImage(imageFile);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  Future<Null> _cropImage(imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio4x3,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: MyColors.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
          aspectRatioPickerButtonHidden: false,
          aspectRatioLockEnabled: true,
          aspectRatioLockDimensionSwapEnabled: true,
          title: '',
        )
      ],
    );
    if (croppedFile != null) {
      setState(() {
        files.add(croppedFile);
      });
    }
  }

  upload() async {
    for (int i = 0; i < images.length; i++) {
      imagesDownloadUrl.add(images[i]);
    }
    for (int i = 0; i < files.length; i++) {
      await uploadImage(File(files[i].path), "File${i + images.length}");
    }
  }

  uploadImage(fileImage, String fileName) async {
    try {
      await Config.firebaseStorage
          .ref()
          .child("${Config.placesCollection}/${widget.place.id}/news/$newsId/news_${newsId}_$fileName.jpg")
          .putFile(fileImage);
      String downloadURL = await Config.firebaseStorage
          .ref('${Config.placesCollection}/${widget.place.id}/news/$newsId/news_${newsId}_$fileName.jpg')
          .getDownloadURL();
      if (kDebugMode) {
        print(downloadURL);
      }
      imagesDownloadUrl.add(downloadURL);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  addInfo() async {
    setState(() {
      uploading = true;
    });

    await upload();
    saveInfo();
  }

  saveInfo() async {
    try {
      final itemRef = Config.fireStore
          .collection(Config.placesCollection)
          .doc(widget.place.id)
          .collection(Config.newsCollection);
      NewsModel newsModel = NewsModel(
          id: newsId,
          title: _titleTextController.text.trim(),
          images: imagesDownloadUrl,
          description: _descriptionTextController.text.trim(),
          publishDateTime: Timestamp.now());
      itemRef.doc(newsId).set(newsModel.toJson());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.newsAddedSuccessfully)));
      Navigator.pop(context);
      setState(() {
        files.clear();
        imagesDownloadUrl.clear();
        newsId = DateTime.now().millisecondsSinceEpoch.toString();

        _titleTextController.clear();
        _descriptionTextController.clear();
        uploading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
