import 'dart:io';
 
String fixture(String name) => File('test/stub_responses/$name').readAsStringSync();