import 'package:http/http.dart' as http;
import 'package:resto_app/core/constants/variables.dart';
import 'package:resto_app/data/datasources/auth_local_datasource.dart';
import 'package:resto_app/presentation/home/models/order_model.dart';

class OrderRemoteDatasource {
  Future<bool> saveOrder(OrderModel orderModel) async {
    final authData = await AuthLocalDatasources().getAuthData();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/save-order'),
      body: orderModel.toJson(),
      headers: {
        'Authorization': 'Bearer ${authData.token}',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
