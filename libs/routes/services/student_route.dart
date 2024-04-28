// i do not have import libraries because i did on my library (it is on part of '../handler_routes.dart')
part of '../handler_routes.dart';

// _ it means private class ?
class _StudentRoute {

  var logger;
  Router router;
  List<Student> students = [];

  _StudentRoute(this.router) {
    logger = getLogger();
    students.add(Student(1, 'Kevin Owner', 21, ["Java & Spring Boot Developer", "Kotlin & Android Developer"]));
    students.add(Student(2, 'Alex Ryder', 20, ["Java & Spring Boot Developer"]));
    students.add(Student(3, 'Mark Slider', 21, ["JavaScript & Node.js Developer", "Spring Boot & Angular Developer", "Php & Laravel Developer"]));
  }

  getLogger() {
    Logging()
      ..setLogName("libs/routes/services/student_route.dart");
    return Logging.logger;
  }

  Response retrieveAllStudents(Request request) {
    logger.info('you called /reads method GET');
    return Response.ok(jsonEncode({'ok': 200, 'data': students}),
        headers: {'Content-type': 'application/json'});
  }

  Response retrieveStudent(Request request, String sid) {
    logger.info('you called /read/$sid method GET');
    int id = int.parse(sid);
    Student? student;
    if ((id - 1) < students.length && (id - 1) >= 0) {
      student = students.elementAt(id - 1);
    }
    return Response.ok(jsonEncode({'ok': 200, 'data': student}),
        headers: {'Content-type': 'application/json'});
  }


  Future<Response> addStudent(Request request) async {
    logger.info('you called /create method POST');
    bool create = false;
    try {
      /// await request.readAsString() returns like json body (it's String) i have to map it then convert to object (for using)
      Map mapFromJsonBody = jsonDecode(await request.readAsString());
      /// below i solve this error type 'List<dynamic>' is not a subtype of type 'List<String>'
      List objectSkills = mapFromJsonBody["skills"]; // can specify String type!! Why
      List<String> skills = [];
      for (int c = 0; c < objectSkills.length; c++) {
        skills.add(objectSkills.elementAtOrNull(c));
      }
      Student student = Student(
          mapFromJsonBody["sid"],
          mapFromJsonBody["fullname"],
          mapFromJsonBody["age"],
          skills);
      students.add(student);
      create = true;
    } on Exception catch (e) {
      logger.info('found error on method POST and cause was $e');
    }
    return Response.ok(jsonEncode({'created': 201, 'data': create}),
        headers: {'Content-type': 'application/json'});
  }


  Response removeStudent(Request request, String sid) {
    logger.info('you called /delete/$sid method DELETE');
    int id = int.parse(sid);
    bool delete = false;
    if ((id - 1) < students.length && (id - 1) >= 0) {
      students.removeAt(id - 1);
      delete = true;
    }
    return Response.ok(jsonEncode({'accepted': 202, 'data': delete}),
        headers: {'Content-type': 'application/json'});
  }


  Future<Response> editStudent(Request request,String sid) async {
    logger.info('you called /update/$sid method PUT');
    int id = int.parse(sid);
    bool update = false;
    try {
      // map json string to map library
      Map mapFromJsonBody = jsonDecode(await request.readAsString());
      // convert skill dynamic type to string type
      List objectSkills = mapFromJsonBody["skills"];
      List<String> skills = [];
      // get objectSkills[c] to skill.add()
      for (int c = 0; c < objectSkills.length; c++) {
        skills.add(objectSkills.elementAtOrNull(c));
      }
      // edit student
      Student studentEdit = Student(
          id,
          mapFromJsonBody["fullname"],
          mapFromJsonBody["age"],
          skills
      );
      //
      if ((id-1) < students.length && (id-1) >= 0) {
        List<Student> student = [];
        student.add(studentEdit);
        students.replaceRange(id-1, id, student); // nice method for replace element
        update = true;
      }
    } on Exception catch (e) {
      logger.info('found error on method PUT and cause was $e');
    }
    return Response.ok(
        jsonEncode({
          'accepted': 202, 'data': update
        }),
        headers: {'Content-type': 'application/json'}
    );
  }

  Response catchHandler(Request request) => Response.notFound(jsonEncode({'ok': 200, 'data': 'not allowed content'}), headers: {'Content-type': 'application/json'});

  Router get studentRoute {
    /*
      router.get('/reads',retrieveAllStudents);
      router.get('/read/<sid|[0-9]+>',retrieveStudent);
      router.post('/create',addStudent);
      router.put('/update/<sid|[0-9]+>',editStudent);
      router.delete('/delete/<sid|[0-9]+>',removeStudent);
      Or use add(...)
    */
    router.add('GET','/reads',retrieveAllStudents);
    router.add('GET','/read/<sid|[0-9]+>',retrieveStudent);
    router.add('POST','/create',addStudent);
    router.add('PUT','/update/<sid|[0-9]+>',editStudent);
    router.add('DELETE','/delete/<sid|[0-9]+>',removeStudent);
    router.all('/<ignored|.*>', catchHandler);
    return router;
  }

}