import 'package:logging/logging.dart' show Level;
import 'package:shelf_router/shelf_router.dart';
import '../libs/log/logging.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import '../libs/routes/handler_routes.dart';


class ControlApplication {

  var logger;

  ControlApplication() {
    logger = getLogger();
  }

  getLogger() {
    Logging()
      ..setLogName("bin/main.dart")
      ..setLogConsole();
    return Logging.logger;
  }

  display() async {
    HandlerRoutes handler = HandlerRoutes(Router());
    await shelf_io
        .serve(handler.handlerRoutes(), 'localhost', 8080)
        .then((value) => {
              logger.info('Server running on localhost:${value.port}')
            })
        .catchError((onError) => {
          logger.log(Level.WARNING, onError)
        });
  }

}


main () {
  ControlApplication().display();
}