
App app;

void setup() {
  size(1000, 650);
  app = new App();
}

void mouseClicked() {
  app.handleClick();
}

void fileSelected(File file) {
  if (file != null)
    app.init(file.getAbsolutePath());
}

void exit() {
  app.saveState();
  super.exit();
}

void draw() {
  app.draw();
}
