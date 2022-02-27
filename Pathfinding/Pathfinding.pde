Game game = new Game();
//Klik på 's' for at gå et skridt i algoritmen
//Klik på 't' for at placere vægge, og 't' for at slå det fra
void setup() {
  textAlign(CENTER, CENTER);
  rectMode(CENTER);

  size(1600, 800);
  game.setup();
}

void draw() {
  game.draw();
  fill(0);
}

void mousePressed() {
  game.mousePressed();
}

void keyPressed() {
  game.keyPressed();
}
