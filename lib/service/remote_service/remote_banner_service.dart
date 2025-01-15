import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:my_grocery/const.dart';

class RemoteBannerService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/banners';

  Future<dynamic> get() async {
    log("message auth main");
    var response = await client.get(Uri.parse('$remoteUrl?populate=image'));
    return response;
  }
}
