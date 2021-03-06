import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'dart:convert' as convert;

class OnDutyService {
  
  

  Future<List<dynamic>> getPharmacyDuties(
      {required double lat, required double lng}) async {
    var url =
        '${FlutterConfig.get('PHARMACY_DUTIES_URL')}/api/pharmacy-duties?lon=$lng&lat=$lat';
    var response = await http.get(Uri.parse(url));
    var data = convert.jsonDecode(response.body);
    var result = (data['result']?? []) as List;
    List phoneNumbers = [];
    for (var element in result) {
      phoneNumbers.add(element['phone'].toString());
    }
   
    return result;
  }
}
