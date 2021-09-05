import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valeeze/animations/animated_content.dart';
import 'package:valeeze/models/customer_model.dart';
import 'package:valeeze/models/trip_model.dart';
import 'package:valeeze/screens/home/main_screen.dart';
import 'package:valeeze/screens/send/ready.dart';
import 'package:valeeze/screens/transporter/become_transporter.dart';
import 'package:valeeze/services/api.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valeeze/utils/constants.dart';
import 'package:valeeze/utils/toast_util.dart';
import 'package:valeeze/widgets/custom_drop_down.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:valeeze/widgets/yellow_button.dart';
import 'package:http/http.dart' as http;

class SendPage extends StatefulWidget {
  const SendPage({Key? key}) : super(key: key);

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  bool imageUploading = false;

  bool _imagePicked = false;

  XFile? _image;
  List<FullCustomerData> fullCustomerData = [];
  Customer customer = Customer();

  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _valueController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _offerController = TextEditingController();

  _resetForm() {
    _fromController.clear();
    _toController.clear();

    _weightController.clear();
    _valueController.clear();
    _descriptionController.clear();
    _offerController.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  bool hasCreatedProfile = true;

  String? _value1;
  String? _value2;
  String? source;
  String? destination;
  String? weight;
  String? value;
  String? _description;
  String? _offerMessage;
  final List<String> nameList = <String>[
    "DXB",
    "CNN",
    "CCJ",
    "MCT",
    "SFO",
    "BLR",
  ];
  @override
  void dispose() {
    super.dispose();
    _fromController.dispose();
    _toController.dispose();

    _weightController.dispose();
    _valueController.dispose();
    _descriptionController.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadSharedPref();
    _value1 = nameList[0];
    _value2 = nameList[3];
  }

  bool loading = true;
  late String phoneNumberFromPref;
  loadSharedPref() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      phoneNumberFromPref = preferences.getString('mobile')!;

      customer = await Api.getCustomerFromPhone(phoneNumberFromPref);
      preferences.setString('custId', customer.id!);
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _handleAlertPress() {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            // padding: EdgeInsets.only(left: 24),
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              // else {
              //   var route = MaterialPageRoute(
              //       builder: (context) => MainScreen(tabIndex: 1));
              //   Navigator.pushAndRemoveUntil(context, route, (route) => false);
              // }
            },
          ),
          centerTitle: true,
          title: Text(
            'Send',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 25),
              height: 25,
              width: 25,
              // color: Colors.teal,
              // child: SvgPicture.asset('assets/svg/box.svg')
              child: Image.asset(
                'assets/icons/menu_icon.png',
                fit: BoxFit.contain,
                height: 25,
                width: 25,
              ),
            )
          ],
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: AnimatedContent(
                  show: true,
                  leftToRight: 5.0,
                  topToBottom: 0.0,
                  time: 2200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _boxImage(),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20.h),
                        child: Text(
                          'What are you sending',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32.sp, fontWeight: FontWeight.w200),
                        ),
                      ),
                      _itemDropDown(),
                      _imageUploadBox(),
                      _textFields(),
                      Container(
                        margin: EdgeInsets.only(top: 25, left: 25, right: 25),
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(15), color: Colors.transparent),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(30),
                          shadowColor: AppTheme.appYellow,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: AppTheme.appYellow,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                if (_imagePicked == false) {
                                  showSnackbar('Please upload item photo');
                                } else {
                                  if (source == destination) {
                                    showSnackbar(
                                        'Source and destination cannot be same');
                                  } else {
                                    setState(() {
                                      imageUploading = true;
                                    });

                                    String result =
                                        await uploadImage(File(_image!.path));
                                    if (result.contains('successfully')) {
                                      setState(() {
                                        imageUploading = false;
                                      });

                                      showSnackbar('Item added Successfully');
                                      var route = MaterialPageRoute(
                                          builder: (context) => SendReady());
                                      // await Navigator.pushReplacement(
                                      //     context, route);

                                      await pushNewScreen(context,
                                          // customPageRoute: route,

                                          screen: SendReady(),
                                          withNavBar: false);
                                      _resetForm();
                                    } else {
                                      showSnackbar(
                                          'Could not add item, try again');
                                      setState(() {
                                        imageUploading = false;
                                      });
                                    }
                                  }
                                }
                              }
                            },
                            child: Text(
                              'START',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      _termsCondition(),
                    ],
                  ),
                ),
              ));
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _boxImage() {
    return Container(
      height: 150.w,
      width: 180.w,
      margin: const EdgeInsets.only(top: 30),
      child: SvgPicture.asset(
        'assets/svg/box.svg',
        fit: BoxFit.fill,
      ),
    );
  }

  _termsCondition() {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 40),
      child: Text(
        '* Terms and conditions',
        style: TextStyle(
            decoration: TextDecoration.underline, fontWeight: FontWeight.w500),
      ),
    );
  }

  _itemDropDown() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 35, top: 20),
      child: SelectDropList(
        optionItemSelected,
        dropListModel,
        (optionItem) {
          optionItemSelected = optionItem;
          setState(() {});
        },
      ),
    );
  }

  @override
  Future<String> uploadImage(File image) async {
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    log('upload called');

    print(' path in upload' + image.path);
    Dio dio = new Dio();
    String fileName;
    String fileNames = image.path.split('/').last;
    FormData formdata = FormData.fromMap({
      "itemImage": await MultipartFile.fromFile(
        image.path,
      ),
      "customerId": customer.id,
      "mobile": phoneNumberFromPref,
      "itemValue": value,
      "itemWeight": weight,
      "itemFrom": source,
      "itemTo": destination,
      "itemId": 1,
      "description": _description
    });

    fileName = await dio
        .post(Constants.BASE_URL + "addDeliveryItems",
            data: formdata, options: Options(method: 'POST'))
        .then((response) => response.toString())
        .catchError((error) => print(error));

    log('res add item' + fileName);

    return fileName;
  }

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  final ImagePicker _picker = ImagePicker();
  _imgFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 50,
      );
      setState(() {
        _image = pickedFile;
        _imagePicked = true;
      });
      // await
      // mage(File(_image!.path));
    } catch (e) {
      // setState(() {
      //   _pickImageError = e;
      // });
    }
  }

  _imgFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 50,
      );
      setState(() {
        _image = pickedFile;
        _imagePicked = true;
        print(_image!.path);
      });
    } catch (e) {
      // setState(() {
      //   _pickImageError = e;
      // });
    }
  }

  _imageUploadBox() {
    return GestureDetector(
      onTap: _showPicker,
      child: Container(
        margin: EdgeInsets.only(left: 25, right: 25, bottom: 18),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          padding: EdgeInsets.all(6),
          color: AppTheme.appGrey,
          // strokeWidth: .6,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              padding: EdgeInsets.zero,
              height: 200.h,
              width: MediaQuery.of(context).size.width,
              child: _imagePicked
                  ? Container(
                      child: Image.file(
                        File(_image!.path),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset('assets/svg/camera_filled.svg'),
                        Container(
                          alignment: Alignment.center,
                          height: 100.w,
                          width: 100.w,
                          child: SvgPicture.asset(
                              'assets/svg/camera_filled.svg',
                              semanticsLabel: 'Acme Logo'),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Take a pic of your item',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  _dropdown() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Departure'),
            content: DropdownButton(
              value: _value1,
              onChanged: (value) {
                setState(() {
                  _value1 = value.toString();
                  _fromController.text = _value1!;
                });
                Navigator.pop(context);
              },
              items: nameList.map(
                (item) {
                  return DropdownMenuItem(
                    value: item,
                    child: new Text(
                      item,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                },
              ).toList(),
            ),
          );
        });
  }

  _dropdownDestination() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Arrival'),
            content: DropdownButton(
              value: _value1,
              onChanged: (value) {
                setState(() {
                  _value1 = value.toString();
                  _toController.text = _value1!;
                });
                Navigator.pop(context);
              },
              items: nameList.map(
                (item) {
                  return DropdownMenuItem(
                    value: item,
                    child: new Text(
                      item,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                },
              ).toList(),
            ),
          );
        });
  }

  _textFields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 0),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 5,
              shadowColor: Colors.white,
              child: TextFormField(
                controller: _descriptionController,
                onSaved: (val) => _description = val,
                validator: (val) {
                  if (val!.isEmpty || val.length < 5) {
                    return 'Enter valid data';
                  }
                },
                keyboardType: TextInputType.text,
                maxLines: 3,
                textInputAction: TextInputAction.next,
                style: TextStyle(fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // suffix: Text('KG'),
                    suffixIcon: Transform.translate(
                      // alignment: Alignment(.9, -2),
                      offset: Offset(-5, -25),
                      child: Container(
                        height: 10,
                        width: 10,
                        //  padding: EdgeInsets.all(2),
                        child: Transform.scale(
                          scale: .4,
                          child: SvgPicture.asset(
                            'assets/svg/bio_icon.svg',
                            height: 10,
                            width: 10,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    hintText: 'Item description',
                    hintStyle: TextStyle(
                        color: AppTheme.appGrey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 0),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 5,
              shadowColor: Colors.white,
              child: TextFormField(
                style: TextStyle(fontWeight: FontWeight.w500),
                controller: _valueController,
                onSaved: (val) => value = val,
                validator: (val) {
                  if (val!.isEmpty || val.length < 1) {
                    return 'Enter valid data';
                  }
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    //  suffixIcon: Text('DHS'),
                    suffixIcon: Container(
                      height: 8,
                      width: 5,
                      padding: EdgeInsets.all(17),
                      child: Image.asset(
                        'assets/icons/dollar.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Approximate value in USD',
                    hintStyle: TextStyle(
                        color: AppTheme.appGrey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 0),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 5,
              shadowColor: Colors.white,
              child: TextFormField(
                style: TextStyle(fontWeight: FontWeight.w500),
                controller: _weightController,
                onSaved: (val) => weight = val,
                validator: (val) {
                  if (val!.isEmpty || val.length < 1) {
                    return 'Enter valid data';
                  }
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // suffix: Text('KG'),
                    suffixIcon: Container(
                        height: 10,
                        width: 10,
                        padding: EdgeInsets.all(15),
                        child: SvgPicture.asset(
                          'assets/svg/weight.svg',
                          color: AppTheme.appGrey,
                          fit: BoxFit.contain,
                        )),
                    hintText: 'Approximate weight in KG',
                    hintStyle: TextStyle(
                        color: AppTheme.appGrey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(right: 10),
                    // margin:
                    //     EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 0),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5,
                      shadowColor: Colors.white,
                      child: TextFormField(
                        style: TextStyle(fontWeight: FontWeight.w500),
                        controller: _fromController,
                        readOnly: true,
                        validator: (val) {
                          if (val!.isEmpty || val.length < 2) {
                            return 'Enter valid data';
                          }
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (val) => source = val!,
                        onTap: _dropdown,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          suffixIcon: Container(
                            padding: EdgeInsets.all(10),
                            height: 10,
                            width: 10,
                            child:
                                SvgPicture.asset('assets/svg/address_icon.svg'),
                          ),
                          // hintText: 'From',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'From',
                          labelStyle: TextStyle(
                              color: AppTheme.appGrey,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10),
                    // margin:
                    //     EdgeInsets.only(left: 25, right: 25, bottom: 15, top: 20),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5,
                      shadowColor: Colors.white,
                      child: TextFormField(
                        controller: _toController,
                        style: TextStyle(fontWeight: FontWeight.w500),
                        readOnly: true,
                        validator: (val) {
                          if (val!.isEmpty || val.length < 2) {
                            return 'Enter valid data';
                          }
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (val) => destination = val!,
                        onTap: _dropdownDestination,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          suffixIcon: Container(
                            padding: EdgeInsets.all(10),
                            height: 10,
                            width: 10,
                            child:
                                SvgPicture.asset('assets/svg/address_icon.svg'),
                          ),
                          // hintText: 'From',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'To',
                          labelStyle: TextStyle(
                              color: AppTheme.appGrey,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //new field
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 0),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 5,
              shadowColor: Colors.white,
              child: TextFormField(
                controller: _offerController,
                onSaved: (val) => _offerMessage = val,
                validator: (val) {
                  if (val!.isEmpty || val.length < 5) {
                    return 'Enter valid data';
                  }
                },
                keyboardType: TextInputType.text,
                maxLines: 3,
                textInputAction: TextInputAction.next,
                style: TextStyle(fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // suffix: Text('KG'),
                    suffixIcon: Transform.translate(
                      // alignment: Alignment(.9, -2),
                      offset: Offset(-5, -25),
                      child: Container(
                        height: 10,
                        width: 10,
                        //  padding: EdgeInsets.all(2),
                        child: Transform.scale(
                          scale: .4,
                          child: SvgPicture.asset(
                            'assets/svg/bio_icon.svg',
                            height: 10,
                            width: 10,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    hintText:
                        'Make an offer to find Angels faster\n(Suggest a payment or a gift if very urgent)',
                    hintStyle: TextStyle(
                        color: AppTheme.appGrey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///
///
///
///
///
///
///
///
/// Sample data for dropdown
DropListModel dropListModel = DropListModel([
  OptionItem(id: "1", title: "Medicine"),
  OptionItem(id: "2", title: "Computer"),
  OptionItem(id: "1", title: "Smartphone"),
  OptionItem(id: "2", title: "Food item"),
]);
OptionItem optionItemSelected = OptionItem(id: null, title: "Select your item");
