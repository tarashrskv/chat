import 'package:chat/network/socket_builder.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketApi {
  final Socket socket;

  SocketApi(String path) : socket = buildSocket(path);

  void connect() {
    socket.connect();
  }

  void on(String eventName, void Function(dynamic) onEvent) {
    socket.on(eventName, onEvent);
  }

  void onError(void Function(dynamic) onError) {
    socket.onError(onError);
  }

  dispose() {
    socket.dispose();
  }
}