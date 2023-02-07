import 'dart:convert';

import 'package:http/http.dart' as http;

class API {
  static const String _baseUrl =
      'https://j04uk56kh9.execute-api.us-east-1.amazonaws.com/v1';
  static const String _apiKey = '1234';
  static const String _clientId = 'fuse_client_1234';

  static Future<http.Response> post(
    String url, {
    required Map<String, dynamic> body,
  }) async {
    final Map<String, String> headers = {
      'Fuse-Client-Id': _clientId,
      'Fuse-Api-Key': _apiKey,
      'Content-Type': 'application/json; charset=UTF-8',
      "Plaid-Client-Id": "5cb0b915f9c7ee0012d5ab50",
      "Plaid-Secret": "f26308df652218baacfce747ac04a9",
      "Teller-Application-Id": "app_oadgehoph93lcmo18c000",
      "Teller-Certificate":
          "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUV4akNDQXE2Z0F3SUJBZ0lJRnprTThsK2h1V293RFFZSktvWklodmNOQVFFTEJRQXdZVEVMTUFrR0ExVUUKQmhNQ1IwSXhFREFPQmdOVkJBZ01CMFZ1WjJ4aGJtUXhEekFOQmdOVkJBY01Ca3h2Ym1SdmJqRVBNQTBHQTFVRQpDZ3dHVkdWc2JHVnlNUjR3SEFZRFZRUUxEQlZVWld4c1pYSWdRWEJ3YkdsallYUnBiMjRnUTBFd0hoY05Nak13Ck1URXdNakF6TmpFeFdoY05Nall3TVRFd01qQXpOakV4V2pBa01TSXdJQVlEVlFRRERCbGhjSEJmYjJGa1oyVm8KYjNCb09UTnNZMjF2TVRoak1EQXdNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQQp3Q1hJQkR1NTRPMWdvc3dXZXhsR2x5ZzMrWnFJaitzd3JaZVFtbXdRMSs3RndPRzFHWm40bEk1RWZxdkhqaU5sCnJPLzlpV2E4d3p2YlhFREtiZXhlNlYxWll1WFlia3NRQVpoMThXVmoyNjlHQ3l2Rk5BVUpDYzdtT0JoazA0cGQKQk11bWpldElaT2E1cEF6eFpDbm1rMmErL1l2Qkx3L2ROYWZLcHptSFhFUTAycGU2Vmd0UTc0M1h1SGw1V2VRaQp6L1dDOWNxNGNQc3hEYWJYOWo3dmUwdTJQSlV2RVJEOVNqS0JBajRqOHJzdnp3ektSSGliQk8xOWswZDNSZkQ4CmwzY2tNa1N4T1h1WlJ6QTUyeW1lazRMV2dpYUcrN0MrYUM3dGdZTzBmVzdYZHM4OVZDTFh0RHpTeDYwNWIydXkKcUlBZXlrRjNEWHBUbndPYm1wbERvd0lEQVFBQm80RytNSUc3TUE0R0ExVWREd0VCL3dRRUF3SUY0REFUQmdOVgpIU1VFRERBS0JnZ3JCZ0VGQlFjREFqQ0Jrd1lEVlIwakJJR0xNSUdJZ0JTRXErK3NpbVNMeFhrdU5TVUtqZWw2CnBtaHhtcUZscEdNd1lURUxNQWtHQTFVRUJoTUNSMEl4RURBT0JnTlZCQWdNQjBWdVoyeGhibVF4RHpBTkJnTlYKQkFjTUJreHZibVJ2YmpFUE1BMEdBMVVFQ2d3R1ZHVnNiR1Z5TVI0d0hBWURWUVFMREJWVVpXeHNaWElnUVhCdwpiR2xqWVhScGIyNGdRMEdDQ1FEaU5XRy92bTg1Q1RBTkJna3Foa2lHOXcwQkFRc0ZBQU9DQWdFQVZXRFR4T25GCjY2MHNiS1ExK1JDcUFEbndvc1ByUUtnMjBsSHdkNUI0cTNsVVlkL09BQ2hEdHhRK2hFaERPQVB2dmk2bEkwNlMKT3BUZXBrZDVsWk1XZXo3OGVZTGRwSkoraGc5Nnh5ZENSR3lUYlZyMmtPcHlSTG5QMCs5QnZpRlhyb1JmUEJsago3K3lZdFdDc2JMNDgzZjYza3ZoWWdZaWhxRlQ3RDNxRXZ2WnZFL3Jlemo3MTZkVmlBWjcrOUpucTZFWSsreGZNClFQNUozMVRJa2ZkdW1sY2xLNkNEUDRVS0ZLT29FdFpSZkE1OFh5Wm8vOWxZNWk1VWdlQlh4TmdqOG81cldpRmMKbnRlRUJHeEcrWXVCYlI3UXF6Y21ZbytDZUE3RzBPcFZSc0N0amNISExDS3paOGM1eG85V29aSno5K3c4Nmk4RAplYXY1d3dxSVFYellGUHlpMzhGSzJtVlhaSnIzZEx0R0NkUjNaZnVlanJubkkyR04xaS91UGFDaldJYzFIWmdyCmNVY2I1RlpNaitCQUU0WDlaSzBiS3RkTjRPbEMrYjh3RHZTQzJhaDAyTms4N2EzSVRSdW1BL25kQkRXQmtTT3oKVnErTTlMa1BCSjRxckw0V1BpV1E3VnpMc2xrTXJxUFE3MGc2Z3FvZUdyck0zKzRFbVFlQUNXMDZyVDVYUkp1VwowempJSE9zWjZkbGZyTWJmajd1cjlKckN2dkROcGxlMWUwSUZzT0RxVmw2QlBrWXhUQlZzRWhwQUk1Z015L3ZWCnRLVHlyUHY3UGI3aWxsVlc4SXViR1BEUkIzT2drc05DcElmUjVEOXVTQUppdW54YlIrYm1CTm1LWkQrM3ZLdVYKaS9tQTlSckxXb0tYR1dJQ3JNZXhyZVJ0NEhlc1FTSjNaZzg9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K",
      "Teller-Private-Key":
          "LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2Z0lCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktnd2dnU2tBZ0VBQW9JQkFRREFKY2dFTzduZzdXQ2kKekJaN0dVYVhLRGY1bW9pUDZ6Q3RsNUNhYkJEWDdzWEE0YlVabWZpVWprUitxOGVPSTJXczcvMkpacnpETzl0YwpRTXB0N0Y3cFhWbGk1ZGh1U3hBQm1IWHhaV1BicjBZTEs4VTBCUWtKenVZNEdHVFRpbDBFeTZhTjYwaGs1cm1rCkRQRmtLZWFUWnI3OWk4RXZEOTAxcDhxbk9ZZGNSRFRhbDdwV0MxRHZqZGU0ZVhsWjVDTFA5WUwxeXJodyt6RU4KcHRmMlB1OTdTN1k4bFM4UkVQMUtNb0VDUGlQeXV5L1BETXBFZUpzRTdYMlRSM2RGOFB5WGR5UXlSTEU1ZTVsSApNRG5iS1o2VGd0YUNKb2I3c0w1b0x1MkJnN1I5YnRkMnp6MVVJdGUwUE5MSHJUbHZhN0tvZ0I3S1FYY05lbE9mCkE1dWFtVU9qQWdNQkFBRUNnZ0VBRnp1YVBkVExsVm1aQzlEUEk3bVFmUG9QeHBPUSsrSFgrVzFhNlNrSmpQKzMKRTlXQlZHUDNHQWlacnoxQy9Ebmx5SUxJdzZKOStXeVZOSjJLNXhQNC9UdUhIQ1pSYnpNNVJMckpWcWp5bERTbwpWMHB4Wmoyam52YlFMd0V0YVJ5UTdHR3V0UGlPd05DRnFzTW1pWHk5ZjBqTVFyNUdzS2pqajR6SEVVV0FvSlJUCkI1azIvd0ZLUjdJRWJBTnJ5MTZhcFVnd21idU9yZjQ1RGFtL1BLNGFYTk5GdmsvcVFuK3VUNEZNMXJPWkFrdG0KRGZFK0FrVDNCRGIxb0Fhc3VOd08zU3RRNWlaMitDU056UEt3Z3A4UmxiN2dYVDJsN2NZZjB5YVYzVnEvZi9rRwpmTmZKV1B4ZnVreFl5Mjc2M1VhaUVra3VDRW83aFVUV1ZkV0hFOS9yQ1FLQmdRRGdubHNqUllNcmJoOExXVFJIClhDSnUzM211amlONzl3TXhsdE9vdkVFenhBanA1MUVuV1BnbzBFY3g4ZGdNWkRTNEhjUU1xbjhEVDc3MHZqUHUKTzRKVTJFRHRlQVdwVWxqR2lHL0Jrc0dESWh5TjRBekhtOTRWWGlwWk5Rc1lRNzhZd1pqQzI2NGNNdGtVd1hNQwp3QUVhZDlWZjRsejljdmNsVmUyaWU4dmR1UUtCZ1FEYS9oTzBHR3ZrRUh4cFg4UHRsdXg5OURjSzhob1gxdXdjCjgrSXBZYWIzMWE4RU52azVCVzlGZjczU1FuYjUyc21Bb3IzOHB1K2Q3U0JOcTFmV3ZkU2JSUFdMbGhtVmhrbGMKYXdmUnpIdVhpdWdVektpRG5EdmN4TWg3Mndqd0RDa3JVZjh6bi9zYjFPamJiTG5wR1ZKYWhTYUM2MlVBTDVnWgo0a3EwaEF0Nk93S0JnREZzSm5sNFRnZzhUckJjakZnM09ZeFR0NTVrd0FJQ3M3MHhocGpWOHpMRXE0RnIyRHRrCkpCWTIzYk5ybHpJQ3ltYkloZDZUbFNiUllSN1F5dlJjTzYwWGVCSElHdGJLdTZYVFYyT3NPcy96clh5NkU1WEkKQWZHSnFwKytRQmF5c1ZWdEk0T2NlbzdSMFZuenhxNlFPSzN1T0JERTZka0tkcjdNVFdFM0JBQmhBb0dCQU1LTgpmUlcvcUlKWi94MWlmZDhpK1FGQktIRnArcko1TnhUVnVuUUhGRjRUa2NRTnpzWFF4VFVhTXBxTWY4U2prZWJkCkxpbzZhS0NHSE8vRHJHclVCUURZZDhqRjFmN1g2VzdZaTM3Z3ltQXNnTmlScFpnZkFiTzFnMk05aWFneE5aWU4KNThxR2M0RWJXckF0M05Cd3RaQkR3SjRJNEpjVXNXMDFkQ2NCTkcwbkFvR0JBSXExRmhCeGtOaFRQaFUyT3NaMwpBdVBTU1pFNWg3TTUrZGprRjZsb0RoKzlrZnIxdnowM1ZHTGp2OW1IdTBtRXVHNHVrbkxrd0UyNnphbVNvVzhmCjJVMDExYk5tRXhabU1WVWRtcE9uaW5kci9yd2VQbVArc1ptVjVVNU5IQXNCTHJRSDRHMXhvNmtZcVF1Zml0OGcKRHJNb1VVcVdSbllGVkwrUWJndW9SYUR2Ci0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0=",
      "Teller-Token-Signing-Key":
          "cXLqnm451Bi1sMtKTPWOwdFz3gMtNYPn2hVkgXxy9gc=",
      "Mx-Api-Key": "3c3d7243-c6f6-4f68-880a-158552da3e37",
      "Mx-Client-Id": "8ee5ad78-ec05-418f-9698-1b2a2ab33e6f"
    };
    return http.post(
      Uri.parse('$_baseUrl$url'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static createSession({
    required String phone,
    required String template,
  }) async {
    final Map<String, dynamic> body = {
      'phone_number': phone,
      'template_id': template,
      'supported_financial_institution_aggregators': ["PLAID", "TELLER", "MX"],
      'plaid': {
        'products': ["identity"]
      },
    };

    final http.Response response = await API.post(
      '/session',
      body: body,
    );

    final Map<String, dynamic> json = jsonDecode(response.body);

    return json['client_secret'];
  }

  static createLinkToken({
    required String institutionId,
    required String userId,
    required String clientSecret,
  }) async {
    final Map<String, dynamic> body = {
      "institution_id": institutionId,
      "user_id": userId,
      "session_client_secret": clientSecret,
      "webhook_url": "www.plaid.com",
      "plaid": {
        "config": {"client_name": "Atmos"}
      },
    };

    print(body);

    final http.Response response = await API.post(
      '/link/token',
      body: body,
    );

    final Map<String, dynamic> json = jsonDecode(response.body);

    print(json);

    return json['link_token'];
  }

  static exchangePublicToken({
    required String publicToken,
  }) async {
    final Map<String, dynamic> body = {"public_token": publicToken};

    final http.Response response = await API.post(
      '/financial_connections/public_token/exchange',
      body: body,
    );

    final Map<String, dynamic> json = jsonDecode(response.body);

    print(json);

    return json['access_token'];
  }
}
