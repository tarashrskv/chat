import 'package:socket_io_client/socket_io_client.dart';

const String _liveApi = 'https://chat.ziznannya.org';

Socket buildSocket(String path) {
  return io(
    '$_liveApi/$path',
    OptionBuilder()
        .setPath('/socket/')
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
  );

}