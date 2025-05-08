import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'github_config.dart';

class GithubApi {
  Future<bool> createGitHubIssue(
      {required GlobalKey<FormState> formKey,
      required String title,
      required String description,
      required String email,
      required String milestoneTitle,
      List<String> labels = const []}) async {
    final FormState form = formKey.currentState!;
    if (form.validate() == false) {
      return false;
    } else {
      int? milestoneId = await _getMilestoneId(milestoneTitle);
      if (milestoneId == null) {
        print("Meilenstein: $milestoneTitle wurde nicht gefunden!");
        return false;
      }

      final Uri url = Uri.parse("${githubRootPath}/repos/${githubOwner}/${githubRepo}/issues");
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer ${githubToken}",
          "Accept": "application/vnd.github.v3+json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "title": title,
          "body": "$description\n\n-----\nE-Mail: $email",
          "milestone": milestoneId,
          "labels": labels,
        }),
      );

      if (response.statusCode == 201) {
        print("Issue erfolgreich erstellt!");
        return true;
      } else {
        print("Fehler: ${response.statusCode} - ${response.body}");
        return false;
      }
    }
  }

  Future<int?> _getMilestoneId(String milestoneTitle) async {
    final Uri url = Uri.parse("${githubRootPath}/repos/${githubOwner}/${githubRepo}/milestones");

    final githubResponse = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${githubToken}",
        "Accept": "application/vnd.github.v3+json",
      },
    );

    if (githubResponse.statusCode == 200) {
      List<dynamic> milestones = jsonDecode(githubResponse.body);
      for (var milestone in milestones) {
        if (milestone['title'] == milestoneTitle) {
          return milestone['number']; // GitHub verwendet "number" als ID
        }
      }
    } else {
      print("Fehler beim Abrufen der Meilensteine von Github: ${githubResponse.statusCode}");
    }
    return null;
  }
}
