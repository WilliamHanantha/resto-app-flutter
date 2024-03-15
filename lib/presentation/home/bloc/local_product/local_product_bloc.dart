import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resto_app/data/datasources/product_local_datasource.dart';
import 'package:resto_app/data/models/response/product_response_model.dart';

part 'local_product_event.dart';
part 'local_product_state.dart';
part 'local_product_bloc.freezed.dart';

class LocalProductBloc extends Bloc<LocalProductEvent, LocalProductState> {
  final ProductLocalDataSource productLocalDataSource;
  LocalProductBloc(this.productLocalDataSource) : super(const _Initial()) {
    on<_GetLocalProduct>((event, emit) async {
      emit(const _Loading());
      final result = await productLocalDataSource.getProducts();
      emit(_Loaded(result));
    });
  }
}
