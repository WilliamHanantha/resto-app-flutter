part of 'order_items_report_bloc.dart';

@freezed
class OrderItemsReportState with _$OrderItemsReportState {
  const factory OrderItemsReportState.initial() = _Initial;
  const factory OrderItemsReportState.loading() = _Loading;
  const factory OrderItemsReportState.error(String message) = _Error;
  const factory OrderItemsReportState.loaded(
      List<ProductQuantity> itemsReport) = _Loaded;
}
