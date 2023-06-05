import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/io.dart';

final providerOfMessages = StreamProvider.autoDispose<String>((ref) async* {
  // Open the connection
  final channel = IOWebSocketChannel.connect('ws://10.0.2.2:8080');

  // Close the connection when the stream is destroyed
  ref.onDispose(() => channel.sink.close());

  channel.sink.add('send_something');

  // Parse the value received and emit a Message instance
  await for (final value in channel.stream) {
    yield value.toString();
  }
});
