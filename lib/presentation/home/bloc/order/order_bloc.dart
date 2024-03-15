import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resto_app/core/extensions/string_ext.dart';
import 'package:resto_app/data/datasources/auth_local_datasource.dart';
import 'package:resto_app/data/datasources/product_local_datasource.dart';
import 'package:resto_app/data/models/response/discount_response_model.dart';
import 'package:resto_app/presentation/home/models/order_model.dart';
import 'package:resto_app/presentation/home/models/product__quantity.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const _Initial()) {
    on<_Order>((event, emit) async {
      emit(const _Loading());

      final subTotal = event.items.fold<int>(
          0,
          (previousValue, element) =>
              previousValue +
              (element.product.price!.replaceAll(".00", "").toIntegerFromText *
                  element.quantity));
      final discount = (event.discount / 100 * subTotal).toInt();
      final total = subTotal + event.tax + event.serviveCharge - discount;
      final kembalian = event.paymentAmount - total;
      print(
          "discount:${event.discount}, tax:${event.tax}, service${event.serviveCharge}, subtotal:$subTotal, total:$total");
      final totalItem = event.items.fold<int>(
          0, (previousValue, element) => previousValue + element.quantity);
      final userData = await AuthLocalDatasources().getAuthData();
      final dataInput = OrderModel(
        subTotal: subTotal,
        paymentAmount: event.paymentAmount,
        tax: event.tax,
        discount: event.discount,
        serviceCharge: event.serviveCharge,
        total: total,
        paymentMethod: 'Cash',
        kembalian: kembalian,
        totalItem: totalItem,
        idKasir: userData.user!.id!,
        namaKasir: userData.user!.name!,
        transactionTime: DateTime.now().toIso8601String(),
        isSync: 0,
        orderItems: event.items,
      );

      await ProductLocalDataSource.instance.saveOrder(dataInput);

      emit(_Loaded(dataInput));
    });
  }
}
