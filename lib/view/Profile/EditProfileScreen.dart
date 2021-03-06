import 'dart:io';
import 'package:helbage/shared/_shared.dart';
import 'package:helbage/view/Profile/_profile.dart';

import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> _profileform = GlobalKey<FormState>();
  @override
  XFile? _selectedFile;
  bool _loading = false;
  final ImagePicker _picker = ImagePicker();

  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileScreenViewModel>.reactive(
        viewModelBuilder: () => EditProfileScreenViewModel(),
        builder: (context, model, child) {
          ImageProvider showImage() {
            if (_selectedFile == null) {
              if (model.data!.profilePictureURL == "null" ||
                  model.data!.profilePictureURL == null) {
                return AssetImage("assets/images/person icon.png");
              } else {
                return NetworkImage(model.data!.profilePictureURL);
              }
            } else {
              return FileImage(File(_selectedFile!.path));
            }
          }

          if (!model.dataReady) {
            return Center(
              child: Text("There is no data yet"),
            );
          } else {
            TextEditingController _phone =
                TextEditingController(text: model.data!.phoneNo.toString());
            TextEditingController _home =
                TextEditingController(text: model.data!.homeNo.toString());
            TextEditingController _address =
                TextEditingController(text: model.data!.address.toString());
            TextEditingController _city =
                TextEditingController(text: model.data!.city.toString());
            TextEditingController _postcode =
                TextEditingController(text: model.data!.postcode.toString());
            String? state = model.data!.state;
            return Form(
              key: _profileform,
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: logoColor,
                  centerTitle: true,
                  title: Text("Edit Profile"),
                ),
                body: _loading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Stack(
                                children: [
                                  Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 4,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 2,
                                              blurRadius: 10,
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              offset: Offset(0, 10))
                                        ],
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: showImage())),
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                    height: 80,
                                                    color: logoColor,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  getImage(
                                                                      ImageSource
                                                                          .camera);
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .camera_alt,
                                                                )),
                                                            Text(
                                                                'Choose From Camera')
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  getImage(
                                                                      ImageSource
                                                                          .gallery);

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                icon: Icon(Icons
                                                                    .file_copy)),
                                                            Text(
                                                                'Choose From Gallery')
                                                          ],
                                                        ),
                                                      ],
                                                    ));
                                              });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 4,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                            color: logoColor,
                                          ),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                              child: TextFormField(
                                validator: Validation().validatePhoneNo,
                                controller: _phone,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 3),
                                    labelStyle: TextStyle(
                                        fontSize: 20,
                                        color: logoColor,
                                        fontWeight: FontWeight.bold),
                                    labelText: "Phone No",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                              child: TextFormField(
                                validator: Validation().validateHomeNo,
                                controller: _home,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 3),
                                    labelStyle: TextStyle(
                                        fontSize: 20,
                                        color: logoColor,
                                        fontWeight: FontWeight.bold),
                                    labelText: "Home No",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                              child: TextFormField(
                                controller: _address,
                                validator: Validation().validateForEmpty,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 3),
                                    labelStyle: TextStyle(
                                        fontSize: 20,
                                        color: logoColor,
                                        fontWeight: FontWeight.bold),
                                    labelText: "Address",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                              child: TextFormField(
                                validator: Validation().validateForEmpty,
                                controller: _city,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 3),
                                    labelStyle: TextStyle(
                                        fontSize: 20,
                                        color: logoColor,
                                        fontWeight: FontWeight.bold),
                                    labelText: "City",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                              child: TextFormField(
                                validator: Validation().validatePostcode,
                                controller: _postcode,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 3),
                                    labelStyle: TextStyle(
                                        fontSize: 20,
                                        color: logoColor,
                                        fontWeight: FontWeight.bold),
                                    labelText: "Postcode",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                              child: getStateDropDown(
                                  onChanged: (String? value) {
                                    state = value;
                                  },
                                  value: model.data!.state),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(27, 10, 27, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (!_profileform.currentState!
                                          .validate()) {
                                      } else {
                                        setState(() {
                                          _loading = true;
                                        });
                                        await Future.delayed(
                                            Duration(seconds: 2));
                                        model
                                            .edit(
                                                _phone,
                                                _home,
                                                _address,
                                                _city,
                                                _postcode,
                                                state,
                                                model.data!.profilePictureURL,
                                                imagePath: _selectedFile != null
                                                    ? _selectedFile!.path
                                                    : "Empty")
                                            .whenComplete(() {
                                          setState(() {
                                            _loading = false;
                                          });
                                        });
                                      }
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1.5,
                                          color: Colors.black),
                                    ),
                                    style: ButtonStyle(
                                        elevation:
                                            MaterialStateProperty.resolveWith(
                                                (states) => 2),
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.white),
                                        padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(horizontal: 40),
                                        ),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20)))),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (!_profileform.currentState!
                                          .validate()) {
                                      } else {
                                        setState(() {
                                          _loading = true;
                                        });
                                        await Future.delayed(
                                            Duration(seconds: 2));
                                        model
                                            .edit(
                                                _phone,
                                                _home,
                                                _address,
                                                _city,
                                                _postcode,
                                                state,
                                                model.data!.profilePictureURL,
                                                imagePath: _selectedFile != null
                                                    ? _selectedFile!.path
                                                    : "Empty")
                                            .whenComplete(() {
                                          setState(() {
                                            _loading = false;
                                          });
                                        });
                                      }
                                    },
                                    child: Text(
                                      "SAVE",
                                      style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1.5,
                                          color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                        elevation:
                                            MaterialStateProperty.resolveWith(
                                                (states) => 2),
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => logoColor),
                                        padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(horizontal: 40),
                                        ),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20)))),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            );
          }
        });
  }

  getImage(ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      _selectedFile = image;
      setState(() {});
    }
  }
}
