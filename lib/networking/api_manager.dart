import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:lyrics_app/constant/strings.dart';
import 'dart:convert';

class ApiManager {
  Future<dynamic> get(String url) async {
    var jsonResponse;
    try {
      final response = await http.get(Uri.parse(Strings.baseUrl + url));
      jsonResponse = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return jsonResponse;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

class Exceptions implements Exception {
  final _message;
  final _prefix;

  Exceptions([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends Exceptions {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends Exceptions {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends Exceptions {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends Exceptions {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}