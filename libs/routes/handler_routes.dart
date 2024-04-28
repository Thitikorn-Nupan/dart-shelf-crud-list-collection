import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../entities/address.dart';
import '../entities/student.dart';
import '../log/logging.dart';

// Remember any libraries must be import on your library 'this is library'
// So any part '<your services path>' can use libraries in this file
part './services/student_route.dart';
part './services/address_route.dart';

class HandlerRoutes {
  var logger;
  Router route;

  HandlerRoutes(this.route) {
    logger = getLogger();
  }

  getLogger() {
    Logging()
      ..setLogName("libs/routes/handler_routes.dart");
    return Logging.logger;
  }

  Handler handlerRoutes() {
    route.get('/ttknpde-v', (Request request) => Response.notFound(jsonEncode({'ok': 200, 'data': 'hello world!'}), headers: {'Content-type': 'application/json'}));
    /**
       You can also embed other routes, in this case it will help organizer your routes
       Note: This needs be before the catch 'route.all()' that follows
    */
    route.mount('/student',_StudentRoute(Router()).studentRoute);
    route.mount('/address',_AddressRoute(Router()).addressRouter);

    /**
      A catch all of the non implemented routing, useful for showing like 404 page
      As cases http://localhost:8080/5,/sasa, whatever will go this path
    */
    route.all('/<*>', (Request request) => Response.notFound(jsonEncode({'ok': 200, 'data': 'no content'}), headers: {'Content-type': 'application/json'}));
    return route;
  }

}

