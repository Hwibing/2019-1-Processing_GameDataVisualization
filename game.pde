ArrayList<game> games;
game last_game;
String[] elements={"gametitle", "orgname", "entname", "hoperate", "givenrate", "rateno", "rateddate"}; // length: 7

class game {
  // game class
  // contains data of a game
  String attributes[]=new String[7]; // same order as elements above

  game(String[] input) {
    attributes=input;
  }

  String toString() {
    String res="";
    for (int i=0; i<7; i+=1) {
      res+=elements[i]+": "+attributes[i];
      if (i<7-1) res+="\n";
    }
    return res;
  }

  String getAttribute(int k) {
    return attributes[k];
  }
}
