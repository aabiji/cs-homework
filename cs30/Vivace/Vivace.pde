
// TODO:
// - Fix general bugs and implement features
// - Implement a main menu and a game screen
// - Open file using OS file dialog
// - Save state to json
// - Create the user survey

App app;

void setup() {
  size(1000, 650);

  String piece = "clair_de_lune.mid";
  String path = String.format("%s/music/%s", sketchPath(), piece);
  app = new App();
  String error = app.init(path); // TODO: handle possible error
}

void mouseClicked() {
  app.handleClick();
}

void draw() {
  app.draw();
}
