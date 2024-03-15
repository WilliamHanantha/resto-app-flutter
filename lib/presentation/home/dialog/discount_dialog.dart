import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resto_app/core/components/spaces.dart';
import 'package:resto_app/core/constants/colors.dart';
import 'package:resto_app/core/extensions/build_context_ext.dart';
import 'package:resto_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:resto_app/presentation/home/pages/dashboard_page.dart';
import 'package:resto_app/presentation/setting/bloc/discount/discount_bloc.dart';
import 'package:resto_app/presentation/setting/pages/discount_page.dart';
import 'package:resto_app/presentation/setting/pages/settings_page.dart';

class DiscountDialog extends StatefulWidget {
  const DiscountDialog({super.key});

  @override
  State<DiscountDialog> createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  @override
  void initState() {
    context.read<DiscountBloc>().add(const DiscountEvent.getDiscounts());
    super.initState();
  }

  int discountIdSelected = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'DISKON',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.cancel,
                color: AppColors.primary,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
      content: BlocBuilder<DiscountBloc, DiscountState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            loading: () => const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
            loaded: (discounts) {
              return discounts.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: discounts.map((discount) {
                            return ListTile(
                              title: Text('Nama Diskon: ${discount.name}'),
                              subtitle:
                                  Text('Potongan harga (${discount.value}%)'),
                              contentPadding: EdgeInsets.zero,
                              textColor: AppColors.primary,
                              trailing: Checkbox(
                                value: discount.id == discountIdSelected,
                                onChanged: (value) {
                                  setState(() {
                                    discountIdSelected = discount.id!;
                                    context.read<CheckoutBloc>().add(
                                        CheckoutEvent.addDiscount(discount));
                                  });
                                },
                              ),
                              onTap: () {},
                            );
                          }).toList(),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              context
                                  .read<CheckoutBloc>()
                                  .add(const CheckoutEvent.removeDiscount());
                            },
                            child: const Text("Remove Discount"))
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SpaceHeight(24),
                        const Text(
                          "No discount available",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SpaceHeight(8),
                        ElevatedButton(
                          onPressed: () {
                            context.push(DashboardPage(
                              index: 3,
                            ));
                          },
                          child: const Text(
                            "Add new discount",
                          ),
                        )
                      ],
                    );
            },
          );
        },
      ),
    );
  }
}
