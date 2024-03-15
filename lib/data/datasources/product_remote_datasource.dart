import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:resto_app/core/constants/variables.dart';
import 'package:resto_app/data/datasources/auth_local_datasource.dart';
import 'package:resto_app/data/models/response/product_response_model.dart';

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final url = Uri.parse("${Variables.baseUrl}/api/api-products");
    final authData = await AuthLocalDatasources().getAuthData();
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${authData.token}',
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      return Right(ProductResponseModel.fromJson(response.body));
    } else {
      return const Left('Failed to get products');
    }
  }
}
