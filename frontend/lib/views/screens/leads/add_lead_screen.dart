import 'dart:io';

import 'package:capital_care/controllers/providers/lead_provider.dart';
import 'package:capital_care/models/add_leads_model.dart';
import 'package:capital_care/services/api_service.dart';
import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/widgets/custom_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddLeadScreen extends StatefulWidget {
  String userId;
  String userName;
  AddLeadScreen({super.key, required this.userId, required this.userName});

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController loanPercentageController =
      TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController nextMeetingTimeController = TextEditingController();
  TextEditingController loanTypeController = TextEditingController();
  File? lastSalaryController;
  File? cibilController;
  File? identityController;
  File? fileDetailsController;

  List<String> branchOptions = ["Default"];
  List<String> sourceOptions = [
    "Internet",
    "Newspaper",
    "Website",
    "Refrence",
    "Bulk excel",
  ];
  List<String> levelOptions = [
    "Lower",
    "Mid",
    "Important",
    "High Priority and Important",
  ];
  List<String> statusOptions = [
    "Interested",
    "Call Back",
    "No Requirement",
    "Follow up",
    "Document Rejected",
    "Documents Summited",
    "Loan Section",
    "Loan Disbursement",
  ];
  List<String> loanType = [
    "Home Loan",
    "Mortgage Loan",
    "User Car Loan",
    "Business Loan",
    "Personal Loan",
    "Personal Loan",
    "Other",
  ];

  void handleSubmit() async {
    if (contactNameController.text.isEmpty ||
        contactNumberController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Name and Number can't be null")));
    } else {
      AddLeads lead = AddLeads(
        person_id: widget.userId,
        name: contactNameController.text,
        number: contactNumberController.text,
        owner: ownerController.text,
        branch: branchController.text,
        source: sourceController.text,
        priority: levelController.text,
        status: statusController.text,
        next_meeting: nextMeetingTimeController.text,
        refrence: referenceController.text,
        description: descriptionController.text,
      );

      bool success = await ApiService.addLead(lead);
      Provider.of<LeadProvider>(context, listen: false).addLead();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(success ? "success" : "Error")));
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ownerController.text = widget.userName;
    levelController.text = "Lower";
  }

  @override
  void dispose() {
    contactNameController.dispose();
    ownerController.dispose();
    referenceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Lead'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: "Contact Details"),
            const SizedBox(height: 8),
            CustomTextField(
              hint: "Contact Name",
              controller: contactNameController,
            ),
            SizedBox(height: 12),
            CustomTextField(
              hint: "Contact Number",
              controller: contactNumberController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            const SectionTitle(title: "Company Other Details"),
            const SizedBox(height: 8),
            CustomTextField(hint: "Owner", controller: ownerController),
            const SizedBox(height: 12),
            CustomDropdown(
              hint: "-- Select Branch --",
              options: branchOptions,
              onChange: (value) {
                branchController.text = value;
              },
            ),
            const SizedBox(height: 12),
            CustomDropdown(
              hint: "-- Select Source --",
              options: sourceOptions,
              onChange: (value) {
                sourceController.text = value;
              },
            ),
            const SizedBox(height: 12),
            CustomDropdown(
              hint: "Lower",
              options: levelOptions,
              onChange: (value) {
                levelController.text = value;
              },
            ),
            const SizedBox(height: 12),
            CustomDropdown(
              hint: "Select Status",
              options: statusOptions,
              onChange: (value) {
                setState(() {
                  statusController.text = value;
                  // print("=======================>${statusController.text}");
                });
              },
            ),
            const SizedBox(height: 12),
            if (statusController.text == "Interested")
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2026),
                  );
                  if (pickedDate != null) {
                    nextMeetingTimeController.text =
                        pickedDate.toLocal().toString().split(
                          ' ',
                        )[0]; // or use DateFormat
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: nextMeetingTimeController,
                    decoration: InputDecoration(
                      hintText: 'Select Next Meeting Date',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            if (statusController.text == "Interested") SizedBox(height: 12),
            CustomTextField(hint: "Reference", controller: referenceController),
            const SizedBox(height: 12),
            CustomTextField(
              hint: "Description",
              controller: descriptionController,
            ),
            const SizedBox(height: 20),

            const SectionTitle(title: "Company Dynamic Questions"),
            const SizedBox(height: 20),

            CustomDropdown(
              hint: "--Loan Type--",
              options: loanType,
              onChange: (value) {
                loanTypeController.text = value;
              },
            ),
            SizedBox(height: 10),
            addDocumentContainer(
              documentName: "Last 3 months Salary",
              onFileSelected: (file) {
                setState(() {
                  lastSalaryController = file;
                });
              },
            ),
            SizedBox(height: 10),
            addDocumentContainer(
              documentName: "Cibil Score",
              onFileSelected: (file) {
                setState(() {
                  cibilController = file;
                });
              },
            ),
            SizedBox(height: 10),
            addDocumentContainer(
              documentName: "Identity Proof",
              onFileSelected: (file) {
                setState(() {
                  identityController = file;
                });
              },
            ),
            SizedBox(height: 10),
            addDocumentContainer(
              documentName: "File Details",
              onFileSelected: (file) {
                setState(() {
                  fileDetailsController = file;
                });
              },
            ),
            SizedBox(height: 10),
            CustomTextField(
              hint: "Enter Loan Percentage",
              controller: loanPercentageController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            CustomButton(
              text: "Add Lead",
              onPressed: () {
                handleSubmit();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final keyboardType;
  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String hint;
  final List<String> options;
  final onChange;
  const CustomDropdown({
    super.key,
    required this.hint,
    required this.options,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items:
          options.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
      onChanged: (value) {
        onChange(value);
      },
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }
}

class addDocumentContainer extends StatefulWidget {
  final documentName;
  final Function(File?) onFileSelected;

  addDocumentContainer({
    super.key,
    required this.documentName,
    required this.onFileSelected,
  });

  @override
  State<addDocumentContainer> createState() => _addDocumentContainerState();
}

class _addDocumentContainerState extends State<addDocumentContainer> {
  File? _file;
  String? _filePath;
  String? _fileName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        customDialogBox();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _file != null
                ? Image.file(_file!, width: 100, height: 140, fit: BoxFit.cover)
                : Icon(
                  Icons.add_circle,
                  color: AppColors.primaryColor,
                  size: 100,
                ),

            Text(
              _fileName != null ? _fileName : widget.documentName,
              style: TextStyle(fontSize: 17, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _file = File(photo.path); // Just keep in memory, don't save permanently
      });
      widget.onFileSelected(_file);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _file = File(image.path); // Temporarily hold in memory
      });
      widget.onFileSelected(_file);
    }
  }

  Future<void> _pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _fileName = result.files.single.name;
        _filePath = result.files.single.path;
        _file = File(_filePath!);
      });
      widget.onFileSelected(_file);

      // print('Picked file: $_filePath');
    }
  }

  Future<dynamic> customDialogBox() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Take a picture",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () {
                  _takePicture();
                  Navigator.pop(context);
                },
              ),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Choose a picture",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () {
                  _pickImageFromGallery();
                  Navigator.pop(context);
                },
              ),

              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),

                  child: Text(
                    textAlign: TextAlign.center,
                    "Choose a PDF",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () {
                  _pickPdfFile();
                  Navigator.pop(context);
                },
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  // color: AppColors.primaryColor,
                  child: Text(
                    textAlign: TextAlign.center,
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
