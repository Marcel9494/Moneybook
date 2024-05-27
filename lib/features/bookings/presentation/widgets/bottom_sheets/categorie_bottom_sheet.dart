import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/features/bookings/presentation/widgets/buttons/grid_view_button.dart';

import '../deco/bottom_sheet_header.dart';

openCategorieBottomSheet({required BuildContext context, required String title, required TextEditingController controller}) {
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
                      // TODO Kategorieliste dynamisch laden und implementieren, sobald Kategorien vorhanden sind.
                      children: <Widget>[
                        GridViewButton(
                          onPressed: () => _setCategorie(context, 'Lebensmittel', controller),
                          text: 'Lebensmittel',
                        ),
                        GridViewButton(
                          onPressed: () => _setCategorie(context, 'Wohnen / Nebenkosten', controller),
                          text: 'Wohnen / Nebenkosten',
                        ),
                        GridViewButton(
                          onPressed: () => _setCategorie(context, 'Unterhaltung', controller),
                          text: 'Unterhaltung',
                        ),
                        GridViewButton(
                          onPressed: () => _setCategorie(context, 'Haushaltswaren', controller),
                          text: 'Haushaltswaren',
                        ),
                        GridViewButton(
                          onPressed: () => _setCategorie(context, 'Technik', controller),
                          text: 'Technik',
                        ),
                        GridViewButton(
                          onPressed: () => _setCategorie(context, 'Restaurant / Lieferdienst', controller),
                          text: 'Restaurant / Lieferdienst',
                        ),
                        GridViewButton(
                          onPressed: () => _setCategorie(context, 'Urlaub', controller),
                          text: 'Urlaub',
                        ),
                        GridViewButton(
                          onPressed: () => _setCategorie(context, 'Auto / Fahrtkosten', controller),
                          text: 'Auto / Fahrtkosten',
                        ),
                        GridViewButton(
                          onPressed: () => _setCategorie(context, 'Geschenke', controller),
                          text: 'Geschenke',
                        ),
                        GridViewButton(
                          onPressed: () => _setCategorie(context, 'Sonstiges', controller),
                          text: 'Sonstiges',
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

void _setCategorie(BuildContext context, String text, TextEditingController controller) {
  controller.text = text;
  Navigator.pop(context);
}
