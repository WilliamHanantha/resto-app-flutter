import 'package:flutter/material.dart';
import 'package:resto_app/presentation/setting/dialogs/form_tax_dialog.dart';
import 'package:resto_app/presentation/setting/models/tax_model.dart';
import 'package:resto_app/presentation/setting/widgets/manage_tax_card.dart';
import 'package:resto_app/presentation/setting/widgets/settings_title.dart';

import '../../home/widgets/custom_tab_bar.dart';
import '../widgets/add_data.dart';

class TaxPage extends StatefulWidget {
  const TaxPage({super.key});

  @override
  State<TaxPage> createState() => _TaxPageState();
}

class _TaxPageState extends State<TaxPage> {
  final List<TaxModel> items = [
    TaxModel(
      name: 'Pajak',
      value: 11,
      type: TaxType.pajak,
    ),
    TaxModel(
      name: 'Layanan',
      value: 5,
      type: TaxType.layanan,
    ),
  ];

  void onEditTap(TaxModel item) {
    showDialog(
      context: context,
      builder: (context) => FormTaxDialog(data: item),
    );
  }

  void onAddDataTap() {
    showDialog(
      context: context,
      builder: (context) => const FormTaxDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SettingsTitle('Perhitungan Biaya'),
          const SizedBox(height: 24),
          CustomTabBar(
            tabTitles: const ['Pajak', 'Layanan'],
            initialTabIndex: 0,
            tabViews: [
              // LAYANAN TAB
              SizedBox(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: items
                          .where((element) => element.type.isPajak)
                          .toList()
                          .length +
                      1,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.85,
                    crossAxisCount: 3,
                    crossAxisSpacing: 30.0,
                    mainAxisSpacing: 30.0,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return AddData(
                        title: 'Tambah Perhitungan',
                        onPressed: onAddDataTap,
                      );
                    }
                    final item = items
                        .where((element) => element.type.isPajak)
                        .toList()[index - 1];
                    return ManageTaxCard(
                      data: item,
                      onEditTap: () => onEditTap(item),
                    );
                  },
                ),
              ),

              // PAJAK TAB
              SizedBox(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: items
                          .where((element) => element.type.isLayanan)
                          .toList()
                          .length +
                      1,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.85,
                    crossAxisCount: 3,
                    crossAxisSpacing: 30.0,
                    mainAxisSpacing: 30.0,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return AddData(
                        title: 'Tambah Perhitungan',
                        onPressed: onAddDataTap,
                      );
                    }
                    final item = items
                        .where((element) => element.type.isLayanan)
                        .toList()[index - 1];
                    return ManageTaxCard(
                      data: item,
                      onEditTap: () => onEditTap(item),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
