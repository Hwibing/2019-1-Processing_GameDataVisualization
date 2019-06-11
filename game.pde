import java.util.Collections;

ArrayList<game> games;
game last_game;
String[] elements={"gametitle", "orgname", "entname", "hoperate", "givenrate", "rateno", "rateddate"}; // length: 7
String[] korean_elements={"게임명", "평가 기관", "배급사", "희망 등급", "부여 등급", "분류번호", "분류날짜"};
int yardstick=0; // index above, sort criteria
boolean isDescending=true; // descending sort

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
      res+=korean_elements[i]+": "+attributes[i];
      if (i<7-1) res+="\n";
    }
    return res;
  }

  String getAttribute(int k) {
    return attributes[k];
  }
}
