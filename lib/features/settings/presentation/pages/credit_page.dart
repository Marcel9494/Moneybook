import 'package:flutter/material.dart';
import 'package:moneybook/features/settings/presentation/widgets/cards/credit_card.dart';

class CreditPage extends StatefulWidget {
  const CreditPage({super.key});

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credits'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
              child: Text(
                'Lottie Animationen:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CreditCard(
              graphicName: 'Finance guru',
              graphicUrl: 'https://lottiefiles.com/free-animation/finance-guru-jHuBVym465',
              creatorName: 'Felipe Degetau',
              creatorUrl: 'https://lottiefiles.com/8ymgg3gsmkhpc7qa',
              license: 'Lottie Simple License',
              licenseUrl: 'https://lottiefiles.com/page/license',
            ),
            CreditCard(
              graphicName: 'Digital Finance Animation',
              graphicUrl: 'https://lottiefiles.com/free-animation/digital-finance-animation-Rkz7RIL6uy',
              creatorName: 'Motion Pixels Studio',
              creatorUrl: 'https://lottiefiles.com/motionpixels',
              license: 'Lottie Simple License',
              licenseUrl: 'https://lottiefiles.com/page/license',
            ),
            CreditCard(
              graphicName: 'Finance',
              graphicUrl: 'https://lottiefiles.com/free-animation/finance-9Qo9FRKc1H',
              creatorName: 'Mahendra Bhunwal',
              creatorUrl: 'https://lottiefiles.com/mahendra',
              license: 'Lottie Simple License',
              licenseUrl: 'https://lottiefiles.com/page/license',
            ),
            CreditCard(
              graphicName: 'Women finance',
              graphicUrl: 'https://lottiefiles.com/free-animation/women-finance-9xPdVTiLBe',
              creatorName: 'John Maxwell',
              creatorUrl: 'https://lottiefiles.com/wcbkkaqpcp',
              license: 'Lottie Simple License',
              licenseUrl: 'https://lottiefiles.com/page/license',
            ),
          ],
        ),
      ),
    );
  }
}
