clickButton b;

void setup() {
  size(1600, 900);
  b=new clickButton(12, 12, 120, 120);
  b.setColor(0xAB, 0xCD, 0xEF);
}

void draw() {
  background(255);
  b.locate();
}

boolean mouseHere(int x, int y, int w, int h) {
  return x<=mouseX && y<=mouseY && mouseX<=x+w && mouseY<=y+h;
}
