import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resto_app/core/components/buttons.dart';
import 'package:resto_app/core/extensions/build_context_ext.dart';
import 'package:resto_app/core/extensions/string_ext.dart';
import 'package:resto_app/data/datasources/discount_remote_datasource.dart';
import 'package:resto_app/data/models/response/discount_response_model.dart';
import 'package:resto_app/presentation/setting/bloc/add_discount/add_discount_bloc.dart';
import 'package:resto_app/presentation/setting/bloc/discount/discount_bloc.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/constants/colors.dart';
import '../models/discount_model.dart';

class ManageDiscountCard extends StatelessWidget {
  final Discount data;
  final VoidCallback onEditTap;

  const ManageDiscountCard({
    super.key,
    required this.data,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    int discount = double.parse(data.value!).toInt();
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.card),
          borderRadius: BorderRadius.circular(19),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.only(top: 30.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.disabled.withOpacity(0.4),
                ),
                child: Text(
                  '$discount%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Nama Promo : ',
                    children: [
                      TextSpan(
                        text: data.name,
                        style: GoogleFonts.quicksand(
                          color: AppColors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                    style: GoogleFonts.quicksand(
                      color: AppColors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: BlocConsumer<AddDiscountBloc, AddDiscountState>(
              listener: (context, state) {
                context
                    .read<DiscountBloc>()
                    .add(const DiscountEvent.getDiscounts());
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "Delete ${data.name}?",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            content: Text(
                              "Are you sure to delete ${data.name}\ndiscount?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.black.withOpacity(0.8)),
                            ),
                            // titlePadding: EdgeInsets.only(bottom: 0),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text(
                                  "No",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<AddDiscountBloc>().add(
                                      AddDiscountEvent.deleteDiscount(
                                          id: data.id!));
                                  context.pop();
                                },
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                            contentPadding: const EdgeInsets.all(24),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(9.0)),
                          border: Border.all(width: 2, color: AppColors.red),
                        ),
                        child: Assets.icons.delete.svg(color: AppColors.red),
                      ),
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
