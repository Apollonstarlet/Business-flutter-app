import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../app_theme.dart';
import '../service/http_service.dart';

class CreateTransaction extends StatefulWidget {
  const CreateTransaction({Key? key}) : super(key: key);

  @override
  State<CreateTransaction> createState() => _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransaction> {

  var company = TextEditingController();
  var routine_solution = TextEditingController();
  var transaction_date = TextEditingController();
  var metrics = TextEditingController();
  var amount = TextEditingController();

  bool isChecked = false;
  PlatformFile? file1, file2, file3;
  bool is_terms1 = false, is_terms2 = false, is_terms3 = false;
  bool isLoading = false;

  File? selectedfile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Container(
      color: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: isLoading ? Center(child: CircularProgressIndicator()) : Padding(
            padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10))),
                    child: TextField(
                      controller: company,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Other Transacting Company',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  SizedBox( height: 20,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10))),
                    child: TextField(
                      controller: routine_solution,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Routine Solution LLC',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  SizedBox( height: 20,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10))),
                    child: TextField(
                      controller: transaction_date,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Date of Transaction',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  SizedBox( height: 20,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10))),
                    child: TextField(
                      controller: metrics,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Metrics',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  SizedBox( height: 20,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10))),
                    child: TextField(
                      controller: amount,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Transaction Amount',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  SizedBox( height: 20,),
                  Row(
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () { },
                        child: Text('Download', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      SizedBox(width: 5,),
                      Expanded(child: Text("Invoice terms and condition document", style: TextStyle(fontSize: 16)),)
                    ],
                  ),
                  SizedBox( height: 20,),
                  Row(
                    children: [
                      Text("Upload Terms", style: TextStyle(fontSize: 16,)),
                      SizedBox(width: 5,),
                      TextButton(
                        onPressed: () async {
                          FilePickerResult? result = await await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
                          );
                          if (result != null) {
                            setState(() {
                              file1 = result.files.first;
                              is_terms1 = true;
                              // term_file_path = file1?.path.toString();
                            });
                          } else {
                            print('No file selected');
                          }
                        },
                        child: Text('Choose File', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      SizedBox(width: 5,),
                      is_terms1 ? Text(file1!.name, style: TextStyle(color: Colors.redAccent, fontSize: 12),) : Container(),
                    ],
                  ),
                  SizedBox( height: 20,),
                  Row(
                    children: [
                      Text("Upload Invoice", style: TextStyle(fontSize: 16,)),
                      SizedBox(width: 5,),
                      TextButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            setState(() {
                              file2 = result.files.first;
                              is_terms2 = true;
                              // invoice_file_path = file2?.path.toString();
                            });
                          } else {
                            print('No file selected');
                          }
                        },
                        child: Text('Choose File', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      SizedBox(width: 5,),
                      is_terms2 ? Text(file2!.name, style: TextStyle(color: Colors.redAccent, fontSize: 12),) : Container(),
                    ],
                  ),
                  SizedBox( height: 20,),
                  Row(
                    children: [
                      Text("Upload Manifest", style: TextStyle(fontSize: 16,)),
                      SizedBox(width: 5,),
                      TextButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            setState(() {
                              file3 = result.files.first;
                              is_terms3 = true;
                              // manifest_file_path = file3?.path.toString();
                            });
                          } else {
                            print('No file selected');
                          }
                        },
                        child: Text('Choose File', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      SizedBox(width: 5,),
                      is_terms3 ? Text(file3!.name, style: TextStyle(color: Colors.redAccent, fontSize: 12),) : Container(),
                    ],
                  ),
                  SizedBox( height: 20,),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Expanded(child: Text("I confirm the documents I have uploaded are True and not Falsified", style: TextStyle(fontSize: 16)))
                    ],
                  ),
                  SizedBox( height: 20,),
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    height: 20,
                    minWidth: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Theme.of(context).primaryColor)),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () async {
                      isLoading = !isLoading;
                      var transaction = await HttpService().upload_term(file1, "term");
                      // var transaction = await HttpService().transaction(company.text, routine_solution.text, transaction_date.text, metrics.text, amount.text, file1, file2, file3);
                      if(transaction != null){
                        await EasyLoading.showSuccess('Success');
                      } else{
                        await EasyLoading.showSuccess('Failed');
                      }
                      setState(() {
                        isLoading = !isLoading;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
