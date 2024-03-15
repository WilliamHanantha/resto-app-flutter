import 'package:resto_app/presentation/setting/models/tax_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDatasource {
  Future<bool> saveTax(TaxModel taxModel) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('tax', taxModel.toJson());
  }

  Future<TaxModel> getTax() async {
    final prefs = await SharedPreferences.getInstance();
    final tax = prefs.getString('tax');
    if (tax != null) {
      return TaxModel.fromJson(tax);
    } else {
      return TaxModel(name: 'Tax', type: TaxType.pajak, value: 11);
    }
  }

  Future<bool> saveServiceCharge(int serviceCharge) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt('serviceCharge', serviceCharge);
  }

  Future<int> getServiceCharge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('serviceCharge') ?? 0;
  }
}
