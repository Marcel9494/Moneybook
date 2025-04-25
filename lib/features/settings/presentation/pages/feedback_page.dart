import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/core/consts/common_consts.dart';
import 'package:moneybook/core/github/github_functions.dart';
import 'package:moneybook/shared/presentation/widgets/buttons/save_button.dart';
import 'package:moneybook/shared/presentation/widgets/input_fields/long_description_text_field.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/utils/app_localizations.dart';
import '../../../../shared/presentation/widgets/input_fields/title_text_field.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final GlobalKey<FormState> _feedbackFormKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final RoundedLoadingButtonController _sendFeedbackBtnController = RoundedLoadingButtonController();

  Future<void> createFeedbackIssue() async {
    GithubApi github = GithubApi();
    bool successful = await github.createGitHubIssue(
        formKey: _feedbackFormKey,
        title: titleController.text,
        description: descriptionController.text,
        milestoneTitle: "User: Feedback",
        labels: ["feedback"]);
    if (successful == false) {
      _sendFeedbackBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _sendFeedbackBtnController.reset();
      });
      return;
    }
    _sendFeedbackBtnController.success();
    Flushbar(
      message: AppLocalizations.of(context).translate('feedback_erfolgreich_gesendet'),
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
        title: Text(AppLocalizations.of(context).translate('feedback_einreichen')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Card(
            child: Form(
              key: _feedbackFormKey,
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
                      hintText: AppLocalizations.of(context).translate('feedback_beschreibung'),
                      descriptionController: descriptionController,
                    ),
                  ),
                  SaveButton(
                      text: AppLocalizations.of(context).translate('senden'),
                      saveBtnController: _sendFeedbackBtnController,
                      onPressed: () => createFeedbackIssue()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
