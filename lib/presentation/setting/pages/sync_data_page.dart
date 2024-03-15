import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resto_app/core/components/spaces.dart';
import 'package:resto_app/core/constants/colors.dart';
import 'package:resto_app/data/datasources/product_local_datasource.dart';
import 'package:resto_app/presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'package:resto_app/presentation/setting/bloc/sync_product/sync_product_bloc.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({super.key});

  @override
  State<SyncDataPage> createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sync Data")),
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocConsumer<SyncProductBloc, SyncProductState>(
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () {},
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  },
                  loaded: (productResponseModel) {
                    ProductLocalDataSource.instance.deleteProducts();
                    ProductLocalDataSource.instance
                        .insertProducts(productResponseModel.data!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Sync Product Success"),
                        backgroundColor: AppColors.green,
                      ),
                    );
                  },
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return GestureDetector(
                      onTap: () {
                        context
                            .read<SyncProductBloc>()
                            .add(const SyncProductEvent.syncProduct());
                      },
                      child: customButtonSync(
                          "Sync Data",
                          "Sinkronisasi data produk\ndari server",
                          Icons.arrow_circle_down_rounded),
                    );
                  },
                  loading: () {
                    return const SizedBox(
                      height: 250,
                      width: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                );
              },
            ),
            BlocConsumer<SyncOrderBloc, SyncOrderState>(
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () {},
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  },
                  loaded: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Sync Order Success"),
                        backgroundColor: AppColors.green,
                      ),
                    );
                  },
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return GestureDetector(
                      onTap: () {
                        context
                            .read<SyncOrderBloc>()
                            .add(const SyncOrderEvent.syncOrder());
                      },
                      child: customButtonSync(
                          "Sync Order",
                          "Sinkronisasi data pesanan\nke server",
                          Icons.arrow_circle_up_rounded),
                    );
                  },
                  loading: () {
                    return const SizedBox(
                      height: 250,
                      width: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget customButtonSync(String title, String desc, IconData icon) {
    return Expanded(
      child: Container(
        width: 250,
        height: 250,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            // border: Border.all(width: 2, color: AppColors.blueLight),
            boxShadow: [
              BoxShadow(
                blurStyle: BlurStyle.inner,
                color: AppColors.black.withOpacity(0.3),
                offset: const Offset(2, 2),
                blurRadius: 4,
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
                const SpaceWidth(8),
                Icon(icon, color: AppColors.primary, size: 32),
              ],
            ),
            const SpaceHeight(16),
            Text(
              desc,
              style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
