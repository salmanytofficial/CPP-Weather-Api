#include <crow.h>

using namespace crow;
int main() {
  crow::SimpleApp app;

  CROW_ROUTE(app, "/")([]() { return "Hello World!"; });

  app.port(8080).run();
  return 0;
}
