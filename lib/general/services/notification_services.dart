import 'dart:convert';
import 'dart:developer';
import 'package:hinvex/general/app_details/app_details.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class NotificationServices {
  static Future<void> sendFcmMessage({
    String? token,
    required String body,
    required String title,
    String? userId,
    String? image,
  }) async {
    final result = await _obtainAuthenticatedClient();
    const url =
        'https://fcm.googleapis.com/v1/projects/${AppDetails.projectId}/messages:send';

    // Replace with your notification details
    final notification = <String, dynamic>{
      'title': title,
      'body': body,
      'image': image,
    };

    // Replace with your custom data
    // final data = <String, dynamic>{
    //   'key': 'value1',
    //   'key2': 'value2',
    // };

    // Construct the FCM message
    final message = <String, dynamic>{
      'message': {
        'topic': 'allUsers',
        'notification': notification,
        // 'data': data,
      },
    };

    // Convert the message to JSON
    final jsonMessage = jsonEncode(message);

    // Make the POST request to send the FCM message
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${result.credentials.accessToken.data}',
      },
      body: jsonMessage,
    );

    // Check the response
    if (response.statusCode == 200) {
      log('FCM message sent successfully😍😍😍😍');
    } else {
      log('Failed to send FCM message. Status code😒😒: ${response.statusCode}');
      log('Response body: ${response.body}');
    }
  }

  static Future<AuthClient> _obtainAuthenticatedClient() async {
    final accountCredentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "hinvex-29819",
      "private_key_id": "e5074d605bc5d92037db9923b1ab9412aee1c762",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCgDVFMJlznXwSZ\nKcMAapNRNz/4kpZu5s9a5mVflRFIf97FHenJmVtO34XXNp9lBsBk+IcRkI5vlNys\ncyX7foXGuo0SaTvT7Y91joqldWGSXP4H0Yy/VAB/vIMhE2IxvPy1EyBS/YGn5maX\nPaM3WxgXo+of5iGDNh5Y5Xw1r0no4bJZHu4hhZ/wGrnwg6x4RHAP13oOypBMmAbQ\nlL4dJ5nc1pDlNPx/rirYAxszqY5gsQbIq1W/yehlb5JwXv4p1ShkP99QAaIbzol0\nvFzwiSvn1/YfBhH4VR7bZZt/wIXoRV2clZZue1E1rxwDEZYvJ7fuuJiiPlhS3tCx\nIMlmGOUvAgMBAAECggEAOllwlI792roIzp/rgBjamUbHsyMZ5deOq+iH96c8VE6N\n1BYaN82JfME/pZy70pR6CrWSZGRrkSFXrCUUqVHQiolTSe2Eirg2T1jGkhivmDD/\nybDrG4uP3QHIWoQbDeAEzyzoYWkbXi9Aoo2tlc5Hg8LV5Yg8Gn5d5PHQ7S95BgXC\nnk6zPvUF0T6NKWTnu9E55lRNC2KDHhXaXo8jkjJXS8Y+UemdU37LYCbX0SHydMft\nW0jxE4gnrsCsSrW6kFR5IrPDIk2Czs7hR5gEXsm1X+TbPXYiOEnwOSZbRivawQJz\nv1qzxfLLVUmmDHG2L64QlWukpPKVy3Vext/AjZ8vtQKBgQDQCkbvL0UiW247wZat\nw5CwkdY2HcGqx8hIlA46DXjh2z0tPgdXQm1lw2rHTBjC/4quKn3sYCV4x66yzfPk\nIcVJIBFZjvw9a8E9YJjXr/0fof0Hvpih8fHh04e5lNYU8n8kBFe7lehg9D67wrJj\n/MzZjWWlSbe6ieu3Eaiz6qLo9QKBgQDE8vesVwaYp2IMZ6i/HgnTx6JJYfH6Vhnr\n0qi/cDTZrmIjW6l+YEMJkbJx8CEPn8McYhYdNBA2Y+VTCbZ7U0irwPR8/9mrw+z1\nmzW9ve3dnWLZvKDkjvR7GC3PLslSsq1KCdVoMTG3TQxqUn4v1HWvRJnX6lFYh8Em\ns/HJguZPEwKBgQC1XNA8AfyGGCkARSMDtuKzW1/ga46DQIlU5GWGrGn+k69AervR\nkWJnfbXfqnJHxJj0fqyqXaMtKP8ed7cv4VTpC+C0L5esP/0Fcems1oqXghNhJgJP\n4+lXUp4W5i6/siuujW6iZOxhYWwzKWd1DVTUL5U2RA68uzHXtbhZqKp+5QKBgQCg\nGxim/JQ7Mw9tIDO5MlUw2gCfAUWyiZ5G7JkMD86XC8FyFwkB2IWG2O+k2l42El2N\nzFtH4FQxsyHxUFsNhJX2MkVO/LrafMs8mrGkjys41sJOWZ6+T0yGaRCMde9qECD5\nqGbZbeyJo9Qs9uToQyJsmisqsKzyeGHX8b7kX0qVCwKBgFtYtftjR5uJrDb/HA0A\nzpUzrNiYnBT41MWr/xAdDTbRSEIS/wncZWjw/VwTntrGyHNqIyi//hH+uY4UFJ3+\n7vw4V3mGfMpZ5BLjqWbKl+7y+DQhsnmvhS5MFCzINyCWQ7smOxJ6PkO+tv6xKLky\n6fVPt+/+CA+Oxf6TS12nJ2t3\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-dl7as@hinvex-29819.iam.gserviceaccount.com",
      "client_id": "102616508326976929923",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-dl7as%40hinvex-29819.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });
    const messagingScope = 'https://www.googleapis.com/auth/firebase.messaging';
    final scopes = [messagingScope];

    final AuthClient client =
        await clientViaServiceAccount(accountCredentials, scopes);

    return client;
  }
}
