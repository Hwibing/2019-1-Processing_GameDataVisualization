String[] elements={"gametitle", "orgname", "entname", "hoperate", "givenrate", "rateno", "rateddate"}; // length: 7

class game {
  String attributes[]=new String[7]; // same order as elements above

  game(String[] input) {
    attributes=input;
  }

  String toString() {
    String res="";
    for (int i=0; i<7; i+=1) {
      res+=elements[i]+": "+attributes[i];
      if(i<7-1) res+="\n";
    }
    return res;
  }

  String getAttribute(int k) {
    return attributes[k];
  }
}

class gameRow extends clickButton {
  game game_info;
  gameRow(int tx, int ty, int tw, int th, game G) {
    // rectangle
    super(tx, ty, tw, th);
    game_info=G;
  }

  @Override
    void fillAndStroke() {
    // set Button design(stroke, fill), depends on the mouse location
    if (mouseHere(this)) {
      stroke(0);
      fill(gray_color*7/8);
    } else {
      noStroke();
      fill(gray_color);
    }
  }

  @Override
    void locate() {
    super.locate();
    textFont(fontR);
    textAlign(CENTER, CENTER);
    fill(0);
    text(game_info.getAttribute(0), x, y, w, h);
  }

  @Override
    void click() {
    last_game=game_info;
  }
}
