import 'package:flutter/material.dart';

void handleApiErrors(int statusCode, {required BuildContext context}) {
  String message;
  switch (statusCode) {
    case 400:
      message = "400: Bad Request";
      break;
    case 401:
      message = "401: Unauthorized Access";
      break;
    case 403:
      message = "403: Forbidden";
      break;
    case 404:
      message = "404: Not Found";
      break;
    case 408:
      message = "408: Request Timeout";
      break;
    case 429:
      message = "429: Too Many Requests";
      break;
    case 500:
      message = "500: Internal Server Error";
      break;
    case 502:
      message = "502: Bad Gateway";
      break;
    case 503:
      message = "503: Service Unavailable";
      break;
    case 504:
      message = "504: Gateway Timeout";
      break;
    default:
      message = "Error occurred, status code: $statusCode";
  }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
