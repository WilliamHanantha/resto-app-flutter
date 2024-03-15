import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resto_app/data/datasources/product_local_datasource.dart';
import 'package:resto_app/presentation/home/models/product__quantity.dart';

part 'order_items_report_event.dart';
part 'order_items_report_state.dart';
part 'order_items_report_bloc.freezed.dart';

class OrderItemsReportBloc
    extends Bloc<OrderItemsReportEvent, OrderItemsReportState> {
  final ProductLocalDataSource productLocalDataSource;
  OrderItemsReportBloc(this.productLocalDataSource) : super(const _Initial()) {
    on<_GetItems>((event, emit) async {
      emit(const _Loading());
      final result = await productLocalDataSource.getAllOrderItem(
          event.startDate, event.endDate);

      emit(_Loaded(result));
    });
  }
}
