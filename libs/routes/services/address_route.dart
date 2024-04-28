part of '../handler_routes.dart';

class _AddressRoute {

  var logger;
  Router router;
  List<Address> addresses = [];

  _AddressRoute(this.router) {
    Logging().setLogName('libs/routes/services/address_route.dart');
    logger = Logging.logger;
    addresses.add(Address(1, 'TH', 'Bangkok', 10300, '310 Nakornchaisri Road'));
    addresses.add(Address(2, 'TH', 'Mueang Rayong', 21160, 'Soon Kanka 5, Pae Klang Kram Road, Mueang'));
    addresses.add(Address(3, 'TH', 'Sathorn', 10120, 'Chan Rd., Thung Wat Don, Sathorn'));
  }

  Response retrieveAllAddresses(Request request) {
    logger.info('you called /reads method GET');
    return Response.ok(
        jsonEncode({
          'ok': 200, 'data': addresses
        }),
        headers: {'Content-type': 'application/json'}
    );
  }

  Response retrieveAddress(Request request,String aid) {
    logger.info('you called /read/$aid method GET');
    int id = int.parse(aid);
    Address? address;
    if ((id-1) < addresses.length && (id-1) >= 0) {
      address = addresses.elementAt(id-1);
    }
    return Response.ok(
        jsonEncode({
          'ok': 200, 'data': address
        }),
        headers: {'Content-type': 'application/json'}
    );
  }

  Future<Response>  addAddress(Request request) async {
    logger.info('you called /create method POST');
    // await request.readAsString() returns like json body (it's String)
    // i have to map it then convert to object (for using)
    Map mapFromJsonBody = jsonDecode(await request.readAsString());
    //
    Address address = Address(
        mapFromJsonBody["aid"],
        mapFromJsonBody["country"],
        mapFromJsonBody["city"],
        mapFromJsonBody["zipcode"],
        mapFromJsonBody["detail"]
    );
    //
    addresses.add(address);
    return Response.ok(
        jsonEncode({
          'created': 201, 'data': address
        }),
        headers: {'Content-type': 'application/json'}
    );
  }

  Response removeAddress(Request request,String aid) {
    logger.info('you called /delete/$aid method DELETE');
    int id = int.parse(aid);
    bool delete = false;
    if ((id-1) < addresses.length && (id-1) >= 0) {
      addresses.removeAt(id-1);
      delete = true;
    }
    return Response.ok(
        jsonEncode({
          'accepted': 202, 'data': delete
        }),
        headers: {'Content-type': 'application/json'}
    );
  }


  Future<Response> editAddress(Request request,String aid) async {
    logger.info('you called /update/$aid method PUT');
    int id = int.parse(aid);
    bool update = false;
    // map json string to map library
    Map mapFromJsonBody = jsonDecode(await request.readAsString());
    if ((id-1) < addresses.length && (id-1) >= 0) {
      List<Address> address = [];
      address.add(Address(
          id,
          mapFromJsonBody["country"],
          mapFromJsonBody["city"],
          mapFromJsonBody["zipcode"],
          mapFromJsonBody["detail"]
      ));
      addresses.replaceRange(id-1, id, address); // nice method for replace element
      update = true;
    }
    return Response.ok(
        jsonEncode({
          'accepted': 202, 'data': update
        }),
        headers: {'Content-type': 'application/json'}
    );
  }

  Response catchHandler(Request request) => Response.notFound(jsonEncode({'ok': 200, 'data': 'not allowed content'}), headers: {'Content-type': 'application/json'});


  Router get addressRouter {
    router.add('GET','/reads',retrieveAllAddresses);
    router.add('GET','/read/<aid|[0-9]+>',retrieveAddress);
    router.add('POST','/create',addAddress);
    router.add('PUT','/update/<aid|[0-9]+>',editAddress);
    router.add('DELETE','/delete/<aid|[0-9]+>',removeAddress);
    router.all('/<ignored|.*>', catchHandler);
    return router;
  }

}