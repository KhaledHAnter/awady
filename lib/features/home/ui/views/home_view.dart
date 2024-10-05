import 'dart:convert';

import 'package:Awady/core/helpers/extentions.dart';
import 'package:Awady/core/theming/colors.dart';
import 'package:Awady/features/home/data/phone_model.dart';
import 'package:Awady/features/home/ui/views/widgets/phone_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io'; // for File operations
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<PhoneModel> _phoneList = [];
  List<PhoneModel> _filteredPhoneList = []; // Filtered phone list
  String _searchQuery = ""; // Holds the search query

  @override
  void initState() {
    super.initState();
    _loadPhoneList();
  }

  Future<void> _savePhoneList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert entire phone list to JSON string
    List<Map<String, dynamic>> phoneListMap =
        _phoneList.map((item) => item.toJson()).toList();
    String phoneListString = jsonEncode(phoneListMap);

    // Save the JSON string
    prefs.setString('phoneList', phoneListString);
  }

  Future<void> _loadPhoneList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneListString = prefs.getString('phoneList');

    if (phoneListString != null) {
      // Decode the JSON string into a list of dynamic maps
      List<dynamic> jsonData = jsonDecode(phoneListString);

      setState(() {
        _phoneList = jsonData
            .map((item) => PhoneModel.fromJson(item as Map<String, dynamic>))
            .toList();
      });
    }
  }

  Future<void> _pickImage() async {
    // Show bottom sheet to choose between Camera or Gallery
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Pick from Camera'),
                onTap: () async {
                  Navigator.of(ctx).pop(); // Close the bottom sheet
                  await _pickImageFromSource(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Pick from Gallery'),
                onTap: () async {
                  Navigator.of(ctx).pop(); // Close the bottom sheet
                  await _pickImageFromSource(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) {
      // User canceled the picker
      return;
    }

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = pickedFile.name;
    final savedImage =
        await File(pickedFile.path).copy('${appDir.path}/$fileName');

    String name = "";
    String priceText = "";
    String description = "";

    // Show dialog for entering additional phone details
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Enter Phone Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  priceText = value;
                },
              ),
              TextField(
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  description = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog without saving
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final price = int.tryParse(priceText) ?? 0;
                setState(() {
                  _phoneList.add(
                    PhoneModel(
                      name: name.isNotEmpty
                          ? name
                          : "Product ${_phoneList.length + 1}",
                      image: savedImage,
                      price: price,
                      dateTime: DateTime.now(),
                      description: description, // Save the description
                    ),
                  );
                });
                _savePhoneList(); // Save the updated list
                Navigator.of(ctx).pop(); // Close the dialog after saving
              },
              child: const Text("Add Product"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePhone(int index) async {
    // Show confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Delete Product"),
          content: const Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              onPressed: () {
                ctx.pop(); // Close the dialog without deleting
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Proceed to delete the item
                setState(() {
                  if (_filteredPhoneList.isNotEmpty) {
                    // Determine whether to delete from _phoneList or _filteredPhoneList
                    PhoneModel phoneToDelete = _filteredPhoneList[index];

                    // Remove the item from the main list
                    _phoneList.removeWhere(
                        (phone) => phone.name == phoneToDelete.name);

                    // Remove the item from the filtered list
                    _filteredPhoneList.removeAt(index);
                  } else {
                    _phoneList.removeAt(index);
                  }
                });
                _savePhoneList(); // Save the updated list after deleting
                _filterPhones(_searchQuery);

                ctx.pop(); // Close the dialog after deleting
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _filterPhones(String query) {
    bool isEnglish = RegExp(r'^[\x00-\x7F]+$').hasMatch(query);

    setState(() {
      _searchQuery = query;

      _filteredPhoneList = _phoneList.where((phone) {
        String phoneName = phone.name;
        if (isEnglish) {
          return phoneName.toLowerCase().contains(query.toLowerCase());
        } else {
          return phoneName.contains(query);
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Phone List",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Phones',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged:
                  _filterPhones, // Call the filter function on text change
            ),
          ),
          Expanded(
            child: Builder(
              builder: (BuildContext context) {
                if (_filteredPhoneList.isEmpty) {
                  if (_searchQuery.isEmpty) {
                    if (_phoneList.isEmpty) {
                      return const Center(
                        child: Text("مفيش أجهزة اتضافت لسه",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      );
                    } else {
                      return PhoneGridView(
                        phoneList: _phoneList,
                        deleteCallback: _deletePhone,
                      );
                    }
                  } else {
                    return const Center(
                      child: Text("لا توجد أجهزة مطابقة",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    );
                  }
                } else {
                  return PhoneGridView(
                    phoneList: _filteredPhoneList,
                    deleteCallback: _deletePhone,
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsManager.mainBlue.withOpacity(.8),
        onPressed: _pickImage,
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      ),
    );
  }
}
