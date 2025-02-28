import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resto_app/core/assets/assets.gen.dart';
import 'package:resto_app/core/components/scroll_bar_view.dart';
import 'package:resto_app/core/components/spaces.dart';
import 'package:resto_app/core/constants/colors.dart';
import 'package:resto_app/core/extensions/build_context_ext.dart';
import 'package:resto_app/core/extensions/int_ext.dart';
import 'package:resto_app/core/extensions/string_ext.dart';
import 'package:resto_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:resto_app/presentation/home/bloc/order/order_bloc.dart';
import 'package:resto_app/presentation/home/dialog/discount_dialog.dart';
import 'package:resto_app/presentation/home/dialog/service_dialog.dart';
import 'package:resto_app/presentation/home/dialog/tax_dialog.dart';
import 'package:resto_app/presentation/home/models/order_item.dart';
import 'package:resto_app/presentation/home/models/product__quantity.dart';
import 'package:resto_app/presentation/home/widgets/success_payment_dialog.dart';

import '../../../core/components/buttons.dart';
import '../models/product_category.dart';
import '../models/product_model.dart';
import '../widgets/column_button.dart';
import '../widgets/order_menu.dart';

class ConfirmPaymentPage extends StatefulWidget {
  const ConfirmPaymentPage({super.key});

  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
  final totalPriceController = TextEditingController();
  final _scrollController = ScrollController();
  final products = [
    ProductModel(
        image: Assets.images.product1.path,
        name: 'Vanila Late Vanila itu',
        category: ProductCategory.drink,
        price: 200000,
        stock: 10),
    ProductModel(
        image: Assets.images.product2.path,
        name: 'V60',
        category: ProductCategory.drink,
        price: 1200000,
        stock: 10),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Hero(
        tag: 'confirmation_screen',
        child: Scaffold(
          body: Row(
            children: [
              // LEFT CONTENT
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Konfirmasi',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Orders #1',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                context.pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                height: 60.0,
                                width: 60.0,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SpaceHeight(8.0),
                        const Divider(),
                        const SpaceHeight(24.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              width: 160,
                            ),
                            SizedBox(
                              width: 50.0,
                              child: Text(
                                'Qty',
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
                        BlocBuilder<CheckoutBloc, CheckoutState>(
                          builder: (context, state) {
                            return state.maybeWhen(
                              orElse: () => const Center(
                                child: Text('No Items'),
                              ),
                              loaded: (products, discount, tax, serviceCharge) {
                                if (products.isEmpty) {
                                  return const Center(
                                    child: Text('No Items'),
                                  );
                                }
                                return Expanded(
                                  child: ScrollBarView(
                                    scrollController: _scrollController,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      controller: _scrollController,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          OrderMenu(data: products[index]),
                                      separatorBuilder: (context, index) =>
                                          const SpaceHeight(0),
                                      itemCount: products.length,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SpaceHeight(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ColumnButton(
                              label: 'Diskon',
                              svgGenImage: Assets.icons.diskon,
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => const DiscountDialog(),
                              ),
                            ),
                            ColumnButton(
                              label: 'Pajak',
                              svgGenImage: Assets.icons.pajak,
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => const TaxDialog(),
                              ),
                            ),
                            ColumnButton(
                              label: 'Layanan',
                              svgGenImage: Assets.icons.layanan,
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => const ServiceDialog(),
                              ),
                            ),
                          ],
                        ),
                        const SpaceHeight(8.0),
                        const Divider(),
                        const SpaceHeight(8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sub total',
                              style: TextStyle(color: AppColors.black),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final price = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (products, discount, tax,
                                          serviceCharge) =>
                                      products.fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue +
                                              (element.product.price!
                                                      .replaceAll(".00", "")
                                                      .toIntegerFromText *
                                                  element.quantity)),
                                );
                                return Text(
                                  price.currencyFormatRp,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SpaceHeight(8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Diskon',
                              style: TextStyle(color: AppColors.black),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final discount = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded:
                                      (products, discount, tax, serviceCharge) {
                                    if (discount == null) {
                                      return 0;
                                    } else {
                                      return discount.value!
                                          .replaceAll(".00", "")
                                          .toIntegerFromText;
                                    }
                                  },
                                );
                                final discountName = state.maybeWhen(
                                  orElse: () => "",
                                  loaded:
                                      (items, discount, tax, serviceCharge) {
                                    if (discount == null) {
                                      return 0;
                                    } else {
                                      return discount.name;
                                    }
                                  },
                                );
                                final subTotal = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (products, discount, tax,
                                          serviceCharge) =>
                                      products.fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue +
                                              (element.product.price!
                                                      .replaceAll(".00", "")
                                                      .toIntegerFromText *
                                                  element.quantity)),
                                );
                                final finalDiscount = discount / 100 * subTotal;
                                if (discount == 0) {
                                  return Text(
                                    finalDiscount.toInt().currencyFormatRp,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    '($discountName, $discount%) ${finalDiscount.toInt().currencyFormatRp}',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SpaceHeight(8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Pajak',
                              style: TextStyle(color: AppColors.black),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final tax = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (products, discount, tax,
                                          serviceCharge) =>
                                      tax,
                                );
                                final price = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (products, discount, tax,
                                          serviceCharge) =>
                                      products.fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue +
                                              (element.product.price!
                                                      .replaceAll(".00", "")
                                                      .toIntegerFromText *
                                                  element.quantity)),
                                );
                                final discount = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded:
                                      (products, discount, tax, serviceCharge) {
                                    if (discount == null) {
                                      return 0;
                                    } else {
                                      return discount.value!
                                          .replaceAll(".00", "")
                                          .toIntegerFromText;
                                    }
                                  },
                                );
                                final subTotal =
                                    price - (discount / 100 * price);
                                final finalTax = subTotal * 0.11;
                                return Text(
                                  '$tax % (${finalTax.toInt().currencyFormatRp})',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SpaceHeight(16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final price = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (products, discount, tax,
                                          serviceCharge) =>
                                      products.fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue +
                                              (element.product.price!
                                                      .replaceAll(".00", "")
                                                      .toIntegerFromText *
                                                  element.quantity)),
                                );
                                final discount = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded:
                                      (products, discount, tax, serviceCharge) {
                                    if (discount == null) {
                                      return 0;
                                    } else {
                                      return discount.value!
                                          .replaceAll(".00", "")
                                          .toIntegerFromText;
                                    }
                                  },
                                );
                                final subTotal =
                                    price - (discount / 100 * price);
                                final tax = subTotal * 0.11;
                                final total = subTotal + tax;
                                return Text(
                                  total.ceil().currencyFormatRp,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        // const SpaceHeight(20.0),
                        // Button.filled(
                        //   onPressed: () {},
                        //   label: 'Lanjutkan Pembayaran',
                        // ),
                      ],
                    ),
                  ),
                ),
              ),

              // RIGHT CONTENT
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pembayaran',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              '1 opsi pembayaran tersedia',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SpaceHeight(8.0),
                            const Divider(),
                            const SpaceHeight(8.0),
                            const Text(
                              'Metode Bayar',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SpaceHeight(12.0),
                            Row(
                              children: [
                                Button.filled(
                                  width: 120.0,
                                  height: 50.0,
                                  onPressed: () {},
                                  label: 'Cash',
                                ),
                                const SpaceWidth(8.0),
                                // Button.outlined(
                                //   width: 120.0,
                                //   height: 50.0,
                                //   onPressed: () {},
                                //   label: 'QRIS',
                                //   disabled: true,
                                // ),
                              ],
                            ),
                            const SpaceHeight(8.0),
                            const Divider(),
                            const SpaceHeight(8.0),
                            const Text(
                              'Total Bayar',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SpaceHeight(12.0),
                            TextFormField(
                              controller: totalPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                hintText: 'Total harga',
                              ),
                            ),
                            const SpaceHeight(45.0),
                            Row(
                              children: [
                                BlocBuilder<CheckoutBloc, CheckoutState>(
                                  builder: (context, state) {
                                    return Button.filled(
                                      width: 150.0,
                                      onPressed: () {
                                        final price = state.maybeWhen(
                                          orElse: () => 0,
                                          loaded: (products, discount, tax,
                                                  serviceCharge) =>
                                              products.fold(
                                                  0,
                                                  (previousValue, element) =>
                                                      previousValue +
                                                      (element.product.price!
                                                              .replaceAll(
                                                                  ".00", "")
                                                              .toIntegerFromText *
                                                          element.quantity)),
                                        );
                                        final discount = state.maybeWhen(
                                          orElse: () => 0,
                                          loaded: (products, discount, tax,
                                              serviceCharge) {
                                            if (discount == null) {
                                              return 0;
                                            } else {
                                              return discount.value!
                                                  .replaceAll(".00", "")
                                                  .toIntegerFromText;
                                            }
                                          },
                                        );
                                        final subTotal =
                                            price - (discount / 100 * price);
                                        final tax = subTotal * 0.11;
                                        final total = subTotal + tax;
                                        totalPriceController.text =
                                            total.ceil().toString();
                                      },
                                      label: 'UANG PAS',
                                    );
                                  },
                                ),
                                const SpaceWidth(20.0),
                                Button.filled(
                                  width: 150.0,
                                  onPressed: () {
                                    totalPriceController.text = '50000';
                                  },
                                  label: 'Rp 50.000',
                                ),
                                const SpaceWidth(20.0),
                                Button.filled(
                                  width: 150.0,
                                  onPressed: () {
                                    totalPriceController.text = '100000';
                                  },
                                  label: 'Rp 100.000',
                                ),
                              ],
                            ),
                            const SpaceHeight(16),
                            Row(
                              children: [
                                Button.filled(
                                  width: 150.0,
                                  onPressed: () {
                                    totalPriceController.text = '200000';
                                  },
                                  label: 'Rp 200.000',
                                ),
                                const SpaceWidth(20.0),
                                Button.filled(
                                  width: 150.0,
                                  onPressed: () {
                                    totalPriceController.text = '300000';
                                  },
                                  label: 'Rp 300.000',
                                ),
                                const SpaceWidth(20.0),
                                Button.filled(
                                  width: 150.0,
                                  onPressed: () {
                                    totalPriceController.text = '500000';
                                  },
                                  label: 'Rp 500.000',
                                ),
                              ],
                            ),
                            const SpaceHeight(100.0),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ColoredBox(
                          color: AppColors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Button.outlined(
                                    onPressed: () => context.pop(),
                                    label: 'Batalkan',
                                  ),
                                ),
                                const SpaceWidth(8.0),
                                BlocBuilder<CheckoutBloc, CheckoutState>(
                                  builder: (context, state) {
                                    final price = state.maybeWhen(
                                      orElse: () => 0,
                                      loaded: (products, discount, tax,
                                              serviceCharge) =>
                                          products.fold(
                                              0,
                                              (previousValue, element) =>
                                                  previousValue +
                                                  (element.product.price!
                                                          .replaceAll(".00", "")
                                                          .toIntegerFromText *
                                                      element.quantity)),
                                    );
                                    final discount = state.maybeWhen(
                                      orElse: () => 0,
                                      loaded: (products, discount, tax,
                                          serviceCharge) {
                                        if (discount == null) {
                                          return 0;
                                        } else {
                                          return discount.value!
                                              .replaceAll(".00", "")
                                              .toIntegerFromText;
                                        }
                                      },
                                    );
                                    final subTotal =
                                        price - (discount / 100 * price);
                                    final tax = subTotal * 0.11;
                                    final total = subTotal + tax;
                                    List<ProductQuantity> items =
                                        state.maybeWhen(
                                      orElse: () => [],
                                      loaded: (products, discount, tax,
                                              serviceCharge) =>
                                          products,
                                    );
                                    final totalQty = items.fold(
                                      0,
                                      (previousValue, element) =>
                                          previousValue + element.quantity,
                                    );
                                    final totalPrice = state.maybeWhen(
                                      orElse: () => 0,
                                      loaded: (products, discount, tax,
                                              serviceCharge) =>
                                          products.fold(
                                        0,
                                        (previousValue, element) =>
                                            previousValue +
                                            (element.product.price!
                                                    .replaceAll(".00", "")
                                                    .toIntegerFromText *
                                                element.quantity),
                                      ),
                                    );
                                    final totalDiscount =
                                        discount / 100 * price;
                                    return Flexible(
                                      child: Button.filled(
                                        onPressed: () async {
                                          context.read<OrderBloc>().add(
                                              OrderEvent.order(
                                                  items,
                                                  discount,
                                                  tax.toInt(),
                                                  0,
                                                  totalPriceController
                                                      .text.toIntegerFromText));
                                          await showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) =>
                                                SuccessPaymentDialog(
                                              data: items,
                                              totalPrice: totalPrice.toInt(),
                                              totalQty: totalQty,
                                              totalDiscount:
                                                  totalDiscount.toInt(),
                                              totalTax: tax.toInt(),
                                              subTotal: subTotal.toInt(),
                                              nominalBayar: totalPriceController
                                                  .text.toIntegerFromText,
                                              normalPrice: price,
                                            ),
                                          );
                                        },
                                        label: 'Bayar',
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
