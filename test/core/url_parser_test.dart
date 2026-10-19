import 'package:flutter_test/flutter_test.dart';
import 'package:zynth_browser/core/constants/app_constants.dart';
import 'package:zynth_browser/core/utils/url_parser.dart';

void main() {
  group('UrlParser Tests', () {
    test('Empty or whitespace input returns UrlType.empty', () {
      expect(UrlParser.parse('').type, equals(UrlType.empty));
      expect(UrlParser.parse('   ').type, equals(UrlType.empty));
      expect(UrlParser.parse('\t\n').type, equals(UrlType.empty));
    });

    test('Full HTTPS and HTTP URLs are recognized as directUrl', () {
      final resHttps = UrlParser.parse('https://example.com');
      expect(resHttps.type, equals(UrlType.directUrl));
      expect(resHttps.targetUrl, equals('https://example.com'));
      expect(resHttps.isSecure, isTrue);

      final resHttp = UrlParser.parse('http://example.com/page?id=42');
      expect(resHttp.type, equals(UrlType.directUrl));
      expect(resHttp.targetUrl, equals('http://example.com/page?id=42'));
      expect(resHttp.isSecure, isFalse);

      final resWhitespace = UrlParser.parse('   https://docs.flutter.dev   ');
      expect(resWhitespace.type, equals(UrlType.directUrl));
      expect(resWhitespace.targetUrl, equals('https://docs.flutter.dev'));
    });

    test('Bare domains are recognized and upgraded to HTTPS', () {
      final res1 = UrlParser.parse('example.com');
      expect(res1.type, equals(UrlType.directUrl));
      expect(res1.targetUrl, equals('https://example.com'));

      final res2 = UrlParser.parse('sub.domain.org/path/index.html');
      expect(res2.type, equals(UrlType.directUrl));
      expect(res2.targetUrl, equals('https://sub.domain.org/path/index.html'));

      final res3 = UrlParser.parse('www.google.com');
      expect(res3.type, equals(UrlType.directUrl));
      expect(res3.targetUrl, equals('https://www.google.com'));

      final res4 = UrlParser.parse('flutter.dev');
      expect(res4.type, equals(UrlType.directUrl));
      expect(res4.targetUrl, equals('https://flutter.dev'));
    });

    test('Localhost and IPv4 addresses navigate directly', () {
      final resLocalhost = UrlParser.parse('localhost:8000');
      expect(resLocalhost.type, equals(UrlType.directUrl));
      expect(resLocalhost.targetUrl, equals('http://localhost:8000'));

      final resIp = UrlParser.parse('127.0.0.1:8000');
      expect(resIp.type, equals(UrlType.directUrl));
      expect(resIp.targetUrl, equals('http://127.0.0.1:8000'));

      final resLocalhostPlain = UrlParser.parse('localhost');
      expect(resLocalhostPlain.type, equals(UrlType.directUrl));
      expect(resLocalhostPlain.targetUrl, equals('http://localhost'));
    });

    test('Multi-word search queries are classified as searchQuery', () {
      final res1 = UrlParser.parse('best Python courses');
      expect(res1.type, equals(UrlType.searchQuery));
      expect(res1.searchQuery, equals('best Python courses'));
      expect(res1.explicitProvider, isNull);

      final res2 = UrlParser.parse('how to install flutter on linux');
      expect(res2.type, equals(UrlType.searchQuery));
      expect(res2.searchQuery, equals('how to install flutter on linux'));
    });

    test('Arbitrary strings with dots that are not valid domains map to searchQuery', () {
      final res1 = UrlParser.parse('..');
      expect(res1.type, equals(UrlType.searchQuery));

      final res2 = UrlParser.parse('.com');
      expect(res2.type, equals(UrlType.searchQuery));

      final res3 = UrlParser.parse('version 3.4');
      expect(res3.type, equals(UrlType.searchQuery));
    });

    test('Explicit @google shortcut routes to Google search', () {
      final res = UrlParser.parse('@google best Python courses');
      expect(res.type, equals(UrlType.searchQuery));
      expect(res.searchQuery, equals('best Python courses'));
      expect(res.explicitProvider, equals(AppConstants.engineGoogleId));
    });

    test('Explicit @zynth shortcut routes to Zynth search', () {
      final res = UrlParser.parse('@zynth best Python courses');
      expect(res.type, equals(UrlType.searchQuery));
      expect(res.searchQuery, equals('best Python courses'));
      expect(res.explicitProvider, equals(AppConstants.engineZynthId));
    });

    test('Shortcut alone without query is parsed safely', () {
      final resGoogle = UrlParser.parse('@google');
      expect(resGoogle.type, equals(UrlType.searchQuery));
      expect(resGoogle.explicitProvider, equals(AppConstants.engineGoogleId));

      final resZynth = UrlParser.parse('@zynth');
      expect(resZynth.type, equals(UrlType.searchQuery));
      expect(resZynth.explicitProvider, equals(AppConstants.engineZynthId));
    });

    test('Dangerous schemes (javascript, file, data) are blocked', () {
      final resJs = UrlParser.parse('javascript:alert(1)');
      expect(resJs.type, equals(UrlType.blocked));
      expect(resJs.isBlocked, isTrue);

      final resFile = UrlParser.parse('file:///etc/passwd');
      expect(resFile.type, equals(UrlType.blocked));
      expect(resFile.isBlocked, isTrue);

      final resData = UrlParser.parse('data:text/html,<h1>Hello</h1>');
      expect(resData.type, equals(UrlType.blocked));
      expect(resData.isBlocked, isTrue);
    });

    test('Internal schemes (about:blank, about:home) are accepted', () {
      final resHome = UrlParser.parse('about:home');
      expect(resHome.type, equals(UrlType.internal));
      expect(resHome.targetUrl, equals('about:home'));

      final resBlank = UrlParser.parse('about:blank');
      expect(resBlank.type, equals(UrlType.internal));
      expect(resBlank.targetUrl, equals('about:blank'));
    });
  });
}
