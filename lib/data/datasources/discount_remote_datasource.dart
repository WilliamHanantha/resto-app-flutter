import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:resto_app/core/constants/variables.dart';
import 'package:resto_app/data/datasources/auth_local_datasource.dart';
import 'package:resto_app/data/models/response/discount_response_model.dart';

class DiscountRemoteDatasource {
  Future<Either<String, DiscountResponseModel>> getProducts() async {
    final url = Uri.parse("${Variables.baseUrl}/api/api-discounts");
    final authData = await AuthLocalDatasources().getAuthData();
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${authData.token}',
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      return Right(DiscountResponseModel.fromJson(response.body));
    } else {
      return const Left('Failed to get discounts');
    }
  }

  Future<Either<String, bool>> addDiscount(
      String name, String description, int value) async {
    final url = Uri.parse("${Variables.baseUrl}/api/api-discounts");
    final authData = await AuthLocalDatasources().getAuthData();
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${authData.token}',
        'Accept': 'application/json',
      },
      body: {
        'name': name,
        'description': description,
        'value': value.toString(),
        'type': 'percentage',
      },
    );

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left('Failed to add discount');
    }
  }

  Future<Either<String, bool>> deleteDiscount(int id) async {
    final url = Uri.parse("${Variables.baseUrl}/api/api-discounts/$id");
    final authData = await AuthLocalDatasources().getAuthData();
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ${authData.token}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      return const Left('Failed to add discount');
    }
  }
}
