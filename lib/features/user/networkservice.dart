import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:cura_frontend/features/user/api_constant.dart';
import 'package:cura_frontend/models/user.dart';

class NetWorkService {
  Future<List<User>?> getUsers() async {
    try {
      var url = Uri.parse(ApiConstant.baseurl + ApiConstant.addUserEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<User> model = usermodelFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
