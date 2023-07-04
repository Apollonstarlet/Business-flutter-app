import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cannicheck/models/membership.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../models/business.dart';
import '../models/user.dart';

class HttpService {
  static final _client = http.Client();
  // static var _baseUrl = 'http://10.10.2.2:5000/';
  // static var _baseUrl = 'http://cannicheck.com/';
  static var _baseUrl = 'https://cannicheck.herokuapp.com/';

  Future<User?> login(String email, String password) async {
    var response = await _client.post(Uri.parse(_baseUrl+'api/auth/login'), body: {
      "email": email,
      "password": password,
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['id'] != 0) {
        await EasyLoading.showSuccess('Success');
        print(json);
        return userFromJson(response.body);
      } else {
        EasyLoading.showError(json['message']);
        return null;
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
      return null;
    }
  }

  Future<User?> register(String firstname, String lastname, String email, String password, String business_name, String address, String city, String state,
      String zip, String phone, String type_of_business, String legal_form, String business_since, String tax_id, String title, String state_license_number,
      String parent_company, String name_of_rep, String business_email, String licensed_state) async {
    var response = await _client.post(Uri.parse(_baseUrl+'api/auth/signup'), body: {
      "firstname": firstname, "lastname": lastname, "email": email, "password": password, "business_name": business_name,
      "address": address, "city": city, "state": state, "zip": zip, "phone": phone, "business_since": business_since,
      "title": title, "tax_id": tax_id, "license_num": state_license_number,"parent_company": parent_company,
      "contact_name": name_of_rep, "business_email": business_email, "type_of_business":type_of_business,"legal_form":legal_form,
      "licensed_state": licensed_state
    });

    print(response.statusCode);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['id'] == 0) {
        await EasyLoading.showError(json['message']);
        return null;
      } else {
        await EasyLoading.showSuccess('Success');
        print(json);
        return userFromJson(response.body);
      }
    } else {
      await EasyLoading.showError("Error Code : ${response.statusCode.toString()}");
      return null;
    }
  }

  Future<User?> profile(String id, String firstname, String lastname, String email, String password, String business_name, String address, String city, String state,
      String zip, String phone, String type_of_business, String legal_form, String business_since, String tax_id, String license_num, String title, String licensed_state,
      String parent_company, String name_of_rep, String business_email) async {
    var response = await _client.post(Uri.parse(_baseUrl+'api/profile/update'), body: {
      "id": id, "firstname": firstname, "lastname": lastname, "email": email, "password": password, "business_name": business_name,
      "address": address, "city": city, "state": state, "zip": zip, "phone": phone, "business_since": business_since,
      "title": title, "tax_id": tax_id, "license_num": license_num,"parent_company": parent_company,"licensed_state":licensed_state,
      "contact_name": name_of_rep, "business_email": business_email, "type_of_business":type_of_business,"legal_form":legal_form
    });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print(json);
      if (json['id'] == 0) {
        await EasyLoading.showError(json['message']);
        return null;
      } else {
        await EasyLoading.showSuccess('Success');
        return userFromJson(response.body);
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
      return null;
    }
  }

  Future<List<Business>?> search_business(String search_by, String search_name) async {
    var response = await _client.post(Uri.parse(_baseUrl+'api/business/search'), body: {
      "search_by": search_by, "search": search_name,
    });
    if (response.statusCode == 200) {
      var json = response.body;
      return businessFromJson(json);
    } else {
      return null;
    }
  }

  Future<List<MembershipPlan?>?> plans() async {
    var response = await _client.get(Uri.parse(_baseUrl+'api/membership'),);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var json = response.body;
      print(response.statusCode);
      return membershipPlanFromJson(json);
    } else {
      return null;
    }
  }

  Future<bool?> upload_term(selectedfile, val) async {
    String uploadurl = _baseUrl+'api/upload_term';
    FormData formdata = FormData.fromMap({
      "term_file": await MultipartFile.fromFile(
          selectedfile.path,
          filename: basename(selectedfile.path)
        //show only filename from path
      ),
    });
    Dio dio = new Dio();
    var response = await dio.post(uploadurl, data: formdata,);
    print("okay");
    print(response.statusCode);
    if(response.statusCode == 200){
      print(response.toString());
      //print response from server
      return true;
    }else{
      print("Error during connection to server.");
      return false;
    }
  }

  Future<bool?> transaction(company, routine_solution, transaction_date, metrics, amount, term_filename, invoice_filename, manifest_filename) async {
    var response = await _client.post(Uri.parse(_baseUrl+'api/transaction'), body: {
      "company_name": company, "other_transaction_company": routine_solution, "transaction_date": transaction_date, "metrics": metrics, "transaction_amount": amount, "term_filename": term_filename, "invoice_filename": invoice_filename, "manifest_filename": manifest_filename
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['is_transaction'] != false) {
        print(json);
        return true;
      } else {
        return false;
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
      return null;
    }
  }
}