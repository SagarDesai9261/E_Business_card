import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../globals.dart' as globals;

class DataApiClient {
  final String url;
  // final http.Client httpClient;
  final data;
  final avtarImage;
  final coverImage;
  final List<dynamic> serviceImageList;
  final List<dynamic> testimonialsImageList;

  DataApiClient(
      {@required this.url,
      this.data,
      this.avtarImage,
      this.coverImage,
       this.serviceImageList,
       this.testimonialsImageList});
  Future<List<Object>> fetchData() async {
    // final data = {"email":email};
    // final _uri = Uri(path: url);
    print("service image list data:$serviceImageList");
    print("api url:$url");
    print("api data:$data");
 //   print("'x-ey-dato': 'IVO\$#Tumhx@Rio6Cg\$bDb\$sCRFLlcY8'");

    List<Object> fetchData = [];
    var headers = {
      // 'Content-Type': 'application/json',
      // "Access-Control-Allow-Origin": "*",
      // 'Accept':'*/*',
      // 'Accept-Encoding':'gzip, deflate, br',
      'Connection': 'keep-alive',
      'Authorization': "${globals.USER_TOKEN}",
      //'x-ey-dato': 'IVO\$#Tumhx@Rio6Cg\$bDb\$sCRFLlcY8',
      'X-DBC-Key': 'si5O\$si8OaXw!HTu',
      'X-DBC-Secret':'Bvgw#1FAjH!50tUD5hzG62Qb95QbXh#9'
    };
    if (avtarImage != null ||
        coverImage != null ||
        serviceImageList != null ||
        testimonialsImageList != null) {
      Uri uri = Uri.parse(url);

      var request = new http.MultipartRequest("POST", uri);
      request.fields.addAll(data);
      request.headers.addAll(headers);

      if (serviceImageList != null) {
        for (int i = 0; i < serviceImageList.length; i++) {
          if (serviceImageList[i]['file'].path.toString().isNotEmpty)
            request.files.add(await http.MultipartFile.fromPath(
                serviceImageList[i]['key'], serviceImageList[i]['file'].path));
        }
      }
      if (testimonialsImageList != null) {
        for (int i = 0; i < testimonialsImageList.length; i++) {
          if (testimonialsImageList[i]['file'].path.toString().isNotEmpty)
            request.files.add(await http.MultipartFile.fromPath(
                testimonialsImageList[i]['key'],
                testimonialsImageList[i]['file'].path));
        }
      }
      if (avtarImage != null) {
        var fileStream =
            new http.ByteStream(DelegatingStream.typed(avtarImage.openRead()));
        var length = await avtarImage.length();
        var multipartFile = new http.MultipartFile('logo', fileStream, length,
            filename: "avtarImage.jpg");
        request.files.add(multipartFile);
      }
      if (coverImage != null) {
        var fileStream =
            new http.ByteStream(DelegatingStream.typed(coverImage.openRead()));
        var length = await coverImage.length();
        print(fileStream);
        var multipartFile = new http.MultipartFile('banner', fileStream, length,
            filename: "coverImage.jpg");
        request.files.add(multipartFile);
      }
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      // var responseData = json.decode(response);
      print("show Response Data(avatar):${respStr}");
      var responseData = json.decode(respStr);

      fetchData.add(responseData);

      return fetchData;
    } else {
      http.Response response =
          await http.post(url, body: data, headers: headers);
      var responseData = json.decode(response.body);
      print("Data Api Client Response :$responseData");

      // responseData.forEach((singleAgent) {
      fetchData.add(responseData);
      // });

      return fetchData;
    }
  }
}
