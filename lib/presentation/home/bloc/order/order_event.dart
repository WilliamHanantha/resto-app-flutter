part of 'order_bloc.dart';

@freezed
class OrderEvent with _$OrderEvent {
  const factory OrderEvent.started() = _Started;
  const factory OrderEvent.order(
    List<ProductQuantity> items,
    int discount,
    int tax,
    int serviveCharge,
    int paymentAmount,
  ) = _Order;
}
