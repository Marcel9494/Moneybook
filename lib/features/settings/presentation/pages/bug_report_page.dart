import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/core/consts/common_consts.dart';
import 'package:moneybook/shared/presentation/widgets/buttons/save_button.dart';
import 'package:moneybook/shared/presentation/widgets/input_fields/long_description_text_field.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/github/github_functions.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../shared/presentation/widgets/input_fields/title_text_field.dart';

class BugReportPage extends StatefulWidget {
  const BugReportPage({super.key});

  @override
  State<BugReportPage> createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  final GlobalKey<FormState> _bugReportFormKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final RoundedLoadingButtonController _sendBugReportBtnController = RoundedLoadingButtonController();

  Future<void> createBugReportIssue() async {
    GithubApi github = GithubApi();
    bool successful = await github.createGitHubIssue(
        formKey: _bugReportFormKey,
        title: titleController.text,
        description: descriptionController.text,
        milestoneTitle: "User: Bug Report",
        labels: ["bug"]);
    if (successful == false) {
      _sendBugReportBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _sendBugReportBtnController.reset();
      });
      return;
    }
    _sendBugReportBtnController.success();
    Flushbar(
      message: AppLocalizations.of(context).translate('fehler_erfolgreich_gesendet'),
      icon: Icon(
        Icons.done_rounded,
        size: 28.0,
        color: Colors.greenAccent,
      ),
      duration: Duration(milliseconds: 2500),
      leftBarIndicatorColor: Colors.greenAccent,
      flushbarPosition: FlushbarPosition.TOP,
      shouldIconPulse: false,
    )..show(context);
    await Future.delayed(Duration(milliseconds: 2500));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('fehler_melden')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Card(
            child: Form(
              key: _bugReportFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TitleTextField(
                      hintText: AppLocalizations.of(context).translate('titel') + '...',
                      titleController: titleController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 0.0),
                    child: LongDescriptionTextField(
                      hintText: AppLocalizations.of(context).translate('fehler_beschreibung'),
                      descriptionController: descriptionController,
                    ),
                  ),
                  SaveButton(
                      text: AppLocalizations.of(context).translate('senden'),
                      saveBtnController: _sendBugReportBtnController,
                      onPressed: () => createBugReportIssue()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
