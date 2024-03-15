part of 'order_items_report_bloc.dart';

@freezed
class OrderItemsReportEvent with _$OrderItemsReportEvent {
  const factory OrderItemsReportEvent.started() = _Started;
  const factory OrderItemsReportEvent.getItems({
    required DateTime startDate,
    required DateTime endDate,
  }) = _GetItems;
}
