import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resto_app/data/datasources/product_local_datasource.dart';
import 'package:resto_app/presentation/home/models/order_model.dart';

part 'transaction_report_event.dart';
part 'transaction_report_state.dart';
part 'transaction_report_bloc.freezed.dart';

class TransactionReportBloc
    extends Bloc<TransactionReportEvent, TransactionReportState> {
  final ProductLocalDataSource productLocalDataSource;
  TransactionReportBloc(this.productLocalDataSource) : super(const _Initial()) {
    on<_GetReport>((event, emit) async {
      emit(const _Loading());
      final result = await productLocalDataSource.getAllOrder(
          event.startDate, event.endDate);

      emit(_Loaded(result));
    });
  }
}
