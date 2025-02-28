import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resto_app/core/assets/assets.gen.dart';
import 'package:resto_app/core/components/custom_date_picker.dart';
import 'package:resto_app/core/components/dashed_line.dart';
import 'package:resto_app/core/components/scroll_bar_view.dart';
import 'package:resto_app/core/components/spaces.dart';
import 'package:resto_app/core/constants/colors.dart';
import 'package:resto_app/core/extensions/date_time_ext.dart';
import 'package:resto_app/core/extensions/int_ext.dart';
import 'package:resto_app/core/extensions/string_ext.dart';
import 'package:resto_app/presentation/report/bloc/order_items_report/order_items_report_bloc.dart';
import 'package:resto_app/presentation/report/bloc/transaction_report/transaction_report_bloc.dart';
import 'package:resto_app/presentation/report/widgets/item_menu.dart';

import '../widgets/report_menu.dart';
import '../widgets/report_title.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int? selectedMenu = 0;
  String title = 'Transaction Report';
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime toDate = DateTime.now();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    String searchDateFormatted =
        '${fromDate.toFormattedDate2()} to ${toDate.toFormattedDate2()}';
    return Scaffold(
      body: Row(
        children: [
          // LEFT CONTENT
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReportTitle(),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CustomDatePicker(
                              prefix: const Text('From: '),
                              initialDate: fromDate,
                              onDateSelected: (selectedDate) {
                                fromDate = selectedDate;
                                setState(() {});
                              },
                            ),
                          ),
                          const SpaceWidth(20.0),
                          Flexible(
                            child: CustomDatePicker(
                              prefix: const Text('To: '),
                              initialDate: toDate,
                              onDateSelected: (selectedDate) {
                                toDate = selectedDate;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Wrap(
                        children: [
                          ReportMenu(
                            label: 'Transaction Report',
                            onPressed: () {
                              selectedMenu = 1;
                              title = 'Transaction Report';
                              setState(() {});
                              context.read<TransactionReportBloc>().add(
                                    TransactionReportEvent.gerReport(
                                      startDate: fromDate,
                                      endDate:
                                          toDate.add(const Duration(days: 1)),
                                    ),
                                  );
                            },
                            isActive: selectedMenu == 1,
                          ),
                          ReportMenu(
                            label: 'Item Sales Report',
                            onPressed: () {
                              selectedMenu = 2;
                              title = 'Item Sales Report';
                              setState(() {});
                              context.read<OrderItemsReportBloc>().add(
                                    OrderItemsReportEvent.getItems(
                                      startDate: fromDate,
                                      endDate:
                                          toDate.add(const Duration(days: 1)),
                                    ),
                                  );
                            },
                            isActive: selectedMenu == 2,
                          ),
                          ReportMenu(
                            label: 'Daily Sales Report',
                            onPressed: () {
                              selectedMenu = 3;
                              title = 'Daily Sales Report';
                              setState(() {});
                            },
                            isActive: selectedMenu == 3,
                          ),
                          ReportMenu(
                            label: 'Summary Sales Report',
                            onPressed: () {
                              selectedMenu = 4;
                              title = 'Summary Sales Report';
                              setState(() {});
                            },
                            isActive: selectedMenu == 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // RIGHT CONTENT
          if (selectedMenu == 3 || selectedMenu == 4)
            const Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text("No Data"),
                    )),
              ),
            ),
          if (selectedMenu == 0)
            const Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text("Pilih menu di samping"),
                    )),
              ),
            ),
          if (selectedMenu == 1)
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: BlocBuilder<TransactionReportBloc,
                      TransactionReportState>(
                    builder: (context, state) {
                      final totalRevenue = state.maybeMap(
                        orElse: () => 0,
                        loaded: (value) {
                          return value.transactionReport.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue + element.total);
                        },
                      );
                      final subTotal = state.maybeMap(
                        orElse: () => 0,
                        loaded: (value) {
                          return value.transactionReport.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue + element.subTotal);
                        },
                      );
                      final discount = state.maybeMap(
                        orElse: () => 0,
                        loaded: (value) {
                          return value.transactionReport.fold(
                            0,
                            (previousValue, element) {
                              return previousValue +
                                  (element.discount / 100 * element.subTotal)
                                      .toInt();
                            },
                          );
                        },
                      );
                      final tax = state.maybeMap(
                        orElse: () => 0,
                        loaded: (value) {
                          return value.transactionReport.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue + element.tax);
                        },
                      );
                      return state.maybeWhen(
                        orElse: () {
                          return const Center(
                            child: Text("No Data"),
                          );
                        },
                        loading: () {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        loaded: (transactionReport) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                              ),
                              Center(
                                child: Text(
                                  searchDateFormatted,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                              const SpaceHeight(16.0),

                              // REVENUE INFO
                              ...[
                                // Text(
                                //   'REVENUE : $totalRevenue',
                                //   style: const TextStyle(
                                //     color: AppColors.primary,
                                //     fontWeight: FontWeight.w800,
                                //     fontSize: 20,
                                //   ),
                                // ),
                                const SpaceHeight(8.0),
                                const Divider(),
                                const SpaceHeight(8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Subtotal',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      subTotal.currencyFormatRp,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SpaceHeight(40.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Assets.icons.diskon.svg(
                                          color: AppColors.primary,
                                          height: 20,
                                        ),
                                        const SpaceWidth(8),
                                        const Text(
                                          'Discount',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      discount.currencyFormatRp,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SpaceHeight(12.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Assets.icons.pajak.svg(
                                          color: AppColors.primary,
                                          height: 20,
                                        ),
                                        const SpaceWidth(8),
                                        const Text(
                                          'Tax',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      tax.currencyFormatRp,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SpaceHeight(8.0),
                                const Divider(),
                                const SpaceHeight(8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'REVENUE',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      totalRevenue.toInt().currencyFormatRp,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SpaceHeight(32.0),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          if (selectedMenu == 2)
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child:
                      BlocBuilder<OrderItemsReportBloc, OrderItemsReportState>(
                    builder: (context, state) {
                      // final tax = state.maybeMap(
                      //   orElse: () => 0,
                      //   loaded: (value) {
                      //     return value.itemsReport.fold(
                      //         0,
                      //         (previousValue, element) =>
                      //             previousValue + element.product);
                      //   },
                      // );
                      return state.maybeWhen(
                        orElse: () {
                          return const Center(
                            child: Text("No Data"),
                          );
                        },
                        loading: () {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        loaded: (transactionReport) {
                          Map<String, Map<String, dynamic>> productSales = {};
                          double totalRevenue = 0.0;

                          for (var element in transactionReport) {
                            // Assuming element.productId, element.product.name, and element.price are properties of your transaction item
                            String productId = element.product.id.toString();
                            String transactionTime =
                                element.product.createdAt.toString();
                            String productName =
                                element.product.name.toString();
                            String image = element.product.image.toString();
                            int quantitySold = element.quantity;
                            int pricePerItem = element.product.price
                                .toString()
                                .toIntegerFromText;

                            // Calculate total price for the product
                            int totalProductPrice = quantitySold * pricePerItem;

                            // Update product sales map
                            productSales.update(
                              productId,
                              (value) {
                                value['productName'] = productName;
                                value['image'] = image;
                                value['quantity'] += quantitySold;
                                value['totalPrice'] += totalProductPrice;
                                value['price'] = pricePerItem;
                                return value;
                              },
                              ifAbsent: () => {
                                'productName': productName,
                                'image': image,
                                'quantity': quantitySold,
                                'totalPrice': totalProductPrice,
                                'price': pricePerItem,
                              },
                            );
                            // Update total revenue
                            totalRevenue += totalProductPrice;
                          }
                          var sortedProductSales = productSales.entries.toList()
                            ..sort((a, b) => b.value['quantity']
                                .compareTo(a.value['quantity']));
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                              ),
                              Center(
                                child: Text(
                                  searchDateFormatted,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                              const SpaceHeight(16.0),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Item',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                  ),
                                  SizedBox(
                                    width: 50.0,
                                    child: Text(
                                      'Sold',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text(
                                      'Price',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SpaceHeight(8),
                              const Divider(),
                              const SpaceHeight(8),
                              // REVENUE INFO
                              Expanded(
                                child: ScrollBarView(
                                  scrollController: _scrollController,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      children: [
                                        ...sortedProductSales.map(
                                          (entry) {
                                            String productId = entry.key;
                                            String productName =
                                                entry.value['productName'];
                                            String image = entry.value['image'];
                                            int quantitySold =
                                                entry.value['quantity'];
                                            int price = entry.value['price'];
                                            int totalPrice =
                                                entry.value['totalPrice'];

                                            return ItemMenu(
                                              productId: productId,
                                              name: productName,
                                              image: image,
                                              price: price,
                                              quantitySold: quantitySold,
                                              totalPrice: totalPrice,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SpaceHeight(8),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'TOTAL',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    totalRevenue.toInt().currencyFormatRp,
                                    style: const TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
