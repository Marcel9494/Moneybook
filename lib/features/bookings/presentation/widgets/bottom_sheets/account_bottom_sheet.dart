import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/features/bookings/presentation/widgets/buttons/grid_view_button.dart';

import '../deco/bottom_sheet_header.dart';

openAccountBottomSheet({required BuildContext context, required String title, required TextEditingController controller}) {
  showCupertinoModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Material(
        child: Wrap(
          children: [
            Column(
              children: [
                BottomSheetHeader(title: title),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(24.0),
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      childAspectRatio: 1.6,
                      // TODO Kontoliste dynamisch laden und implementieren, sobald Konten vorhanden sind.
                      children: <Widget>[
                        GridViewButton(
                          onPressed: () => _setAccount(context, 'Geldbeutel', controller),
                          text: 'Geldbeutel',
                        ),
                        GridViewButton(
                          onPressed: () => _setAccount(context, 'KSK Girokonto', controller),
                          text: 'KSK Girokonto',
                        ),
                        GridViewButton(
                          onPressed: () => _setAccount(context, 'LBS Girokonto', controller),
                          text: 'LBS Girokonto',
                        ),
                        GridViewButton(
                          onPressed: () => _setAccount(context, 'Comdirect Depot', controller),
                          text: 'Comdirect Depot',
                        ),
                        GridViewButton(
                          onPressed: () => _setAccount(context, 'Scalable Capital Depot', controller),
                          text: 'Scalable Capital Depot',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

void _setAccount(BuildContext context, String text, TextEditingController controller) {
  controller.text = text;
  Navigator.pop(context);
}
