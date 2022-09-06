import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EmailController extends GetxController {
  static EmailController instance = Get.find<EmailController>();

  Future<String> sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final serviceId = "service_vippicnic_event";
    final templateId = "template_event_request";
    final userId = "OGisBA4jrqRlW9TkY";

    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(
      url,
      headers: {
        "origin": "https://vippicnic.com",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "service_id": serviceId,
        "template_id": templateId,
        "user_id": userId,
        "template_params": {
          "email_subject": subject,
          "user_name": name,
          "user_email": email,
          "message": message,
        },
      }),
    );
    log("response is: ${response.body}");
    log("response is: ${response.statusCode}");
    return response.body;
  }
}
