import 'dart:async';
import 'dart:convert';

import 'package:grpc/grpc.dart';

import 'package:covidata/generated/helloworld.pb.dart';
import 'package:covidata/generated/helloworld.pbgrpc.dart';
import 'package:covidata/models/index.dart';

class TimeoutException implements Exception {
  final String message = 'Server timeout';
  TimeoutException();
  String toString() => message;
}

class ServerException implements Exception {
  final String message = 'Server busy';
  ServerException();
  String toString() => message;
}

const kTimeoutDuration = Duration(seconds: 25);

class CoronaService {
  CoronaService._privateConstructor();
  static final CoronaService instance = CoronaService._privateConstructor();
  ClientChannel channel;
  GreeterClient stub;

  Future<Covid19> fetchCovidData() async {
    channel = ClientChannel(
      '18.196.232.59',
      port: 8080,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    stub = GreeterClient(channel);
    try {
      final response = await stub.sayHello(HelloRequest(),
          options: CallOptions(timeout: kTimeoutDuration));
      final covidData = Covid19.fromJson(json.decode(response.message));

      if (covidData == null) throw ServerException();

      return Covid19(countryData: covidData.countryData);
    } on GrpcError catch (_) {
      throw TimeoutException();
    } finally {
      await channel.shutdown();
    }
  }


  //JSONDA HIZLI CALIŞAN KISIM

  /*Future<Covid19> fetchCovidData() async {
    try {
      final url = "http://10.0.2.2:8080";
      final json = await _fetchJSON(url);
      Stopwatch stopwatch = Stopwatch()..start();
      var t1 = DateTime.now().millisecondsSinceEpoch;
      final covidData = Covid19.fromJson(json);
      var t2 = DateTime.now().millisecondsSinceEpoch;
      print((t2 - t1).toString());
      print('Task executed in ${stopwatch.elapsed}');

      if (covidData == null) throw ServerException();

      return Covid19(countryData: covidData.countryData);
    } on PlatformException catch (_) {
      throw ServerException();
    } on Exception catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> _fetchJSON(String url) async {
    final response =
        await http.get(url).timeout(Duration(seconds: 25), onTimeout: () {
      throw Error();
    });

    return json.decode(response.body);
  }*/
}
