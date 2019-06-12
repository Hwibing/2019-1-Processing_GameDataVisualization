// TODO: showStatistic
import java.util.Iterator;
import java.util.Comparator;

HashMap<String, Integer> age=new HashMap<String, Integer>();
HashMap<String, Integer> years=new HashMap<String, Integer>();
ArrayList<String> age_sort_result=new ArrayList<String>();
ArrayList<String> year_sort_result=new ArrayList<String>();

void getStatistic() {
  // counts the appropriate data andprovide statistics.
  age.clear();
  for (game G : games) {
    // Getting age data
    String ageTemp=G.getAttribute(4);
    if (age.containsKey(ageTemp)) {
      age.put(ageTemp, age.get(ageTemp)+1);
    } else {
      age.put(ageTemp, 1);
    }
  }
  if (age.containsKey("")) {
    age.put("N/A", age.remove(""));
  }

  years.clear();
  // counts the appropriate data andprovide statistics.
  for (game G : games) {
    // Getting years data
    String yearTemp="";
    try {
      yearTemp=G.getAttribute(6).substring(0, 4);
    } 
    catch(StringIndexOutOfBoundsException e) {
      yearTemp="";
    } 
    finally {
      if (years.containsKey(yearTemp)) {
        years.put(yearTemp, years.get(yearTemp)+1);
      } else {
        years.put(yearTemp, 1);
      }
    }
  }
  if (years.containsKey("")) {
    years.put("N/A", years.remove(""));
  }
  println(years);

  // sorting
  Iterator temp;
  temp=sortHashMapByValue(age);
  age_sort_result.clear();
  while (temp.hasNext()) {
    String k = (String) temp.next();
    age_sort_result.add(k);
  }
  temp=sortHashMapByValue(years);
  year_sort_result.clear();
  while (temp.hasNext()) {
    String k = (String) temp.next();
    year_sort_result.add(k);
  }
}

void showStatistic() {
}

Iterator sortHashMapByValue(final HashMap map) {
  ArrayList<String> list = new ArrayList();
  list.addAll(map.keySet());
  Collections.sort(list, new Comparator() {
    int compare(Object o1, Object o2) {
      Object v1 = map.get(o1);
      Object v2 = map.get(o2);
      return ((Comparable) v1).compareTo(v2);
    }
  }
  );
  Collections.reverse(list);
  return list.iterator();
}
