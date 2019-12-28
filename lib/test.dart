library dart_force_mvc_unittest_lib;

import 'package:mockito/mockito.dart';
import 'package:forcemvc2/forcemvc2.dart';
import 'dart:async';
import 'dart:mirrors';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:collection';
import 'dart:typed_data';

class MockHttpRequest extends Mock implements HttpRequest {}

class MockForceRequest implements ForceRequest {

   var postData;
   Map<String, String> postParams = new Map<String, String>();
   List<Cookie> mockCookies = new List<Cookie>();

   HttpRequest request;
   Map<String, String> path_variables;
   Completer _asyncCallCompleter;
   Intl locale;

   MockForceRequest({this.postData = "test"}) {
     path_variables = new Map<String, String>();
     _asyncCallCompleter = new Completer();
     request = new MockHttpRequest();
   }

   List<String> header(String name) => new List();

   bool accepts(String type) => true;

   bool isMime(String type) => true;

   bool get isForwarded => false;

   List<Cookie> get cookies => mockCookies;

   void statusCode(int statusCode) {}

   // HTTPInputMessage
   Stream getBody() {
     return this.request.transform(StreamTransformer<Uint8List,String>.fromHandlers(
         handleData: (str, sink) {
           sink.add(ascii.decode(str));
         }
     ));
   }

   IOSink getOutputBody() {
     return request.response;
   }

   HttpHeadersWrapper getResponseHeaders() {
     return new HttpHeadersWrapper(this.request.response.headers);
   }

   HttpHeadersWrapper getRequestHeaders() {
     return new HttpHeadersWrapper(this.request.headers);
   }

   Future<dynamic> getPostData({ bool usejson = true }) {
     Completer<dynamic> completer = new Completer<dynamic>();
     completer.complete(postData);

     return completer.future;
   }

   Future<Map<String, String>> getPostRawData() {
       Completer c = new Completer();
       c.complete(postParams);
       return c.future;
     }

   Future<Map<String, String>> getPostParams({ Encoding enc = utf8 }) {
     Completer c = new Completer();
     c.complete(postParams);
     return c.future;
   }

   void async(value) {
     this._asyncCallCompleter.complete(value);
   }

   Future get asyncFuture => _asyncCallCompleter.future;

}
