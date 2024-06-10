import 'dart:io';

//The function's purpose is to load the contents of a string fixture file located within your test directory.
String fixture(String name) =>
    File('test/stub_responses/$name').readAsStringSync();
