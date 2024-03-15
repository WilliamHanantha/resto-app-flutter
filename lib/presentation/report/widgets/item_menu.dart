// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:resto_app/core/components/spaces.dart';
import 'package:resto_app/core/constants/colors.dart';
import 'package:resto_app/core/constants/variables.dart';
import 'package:resto_app/core/extensions/int_ext.dart';
import 'package:resto_app/core/extensions/string_ext.dart';

class ItemMenu extends StatefulWidget {
  const ItemMenu({
    Key? key,
    required this.productId,
    required this.name,
    required this.image,
    required this.quantitySold,
    required this.price,
    required this.totalPrice,
  }) : super(key: key);
  final String productId;
  final String name;
  final String image;
  final int quantitySold;
  final int price;
  final int totalPrice;

  @override
  State<ItemMenu> createState() => _ItemMenuState();
}

class _ItemMenuState extends State<ItemMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  child: Image.network(
                    widget.image.contains("http")
                        ? widget.image!
                        : "${Variables.baseUrl}/${widget.image}",
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(widget.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    )),
                subtitle: Text(
                    widget.price.toString().toIntegerFromText.currencyFormatRp),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 30.0,
                  child: Center(
                      child: Text(
                    widget.quantitySold.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
                ),
              ],
            ),
            const SpaceWidth(8),
            SizedBox(
              width: 80.0,
              child: Text(
                widget.totalPrice.currencyFormatRp,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SpaceHeight(0),
      ],
    );
  }
}
