import java.util.Iterator;
import java.util.Comparator;

HashMap<String, Integer> age=new HashMap<String, Integer>(); // age and # of corresponding result 
HashMap<String, Integer> years=new HashMap<String, Integer>(); // year and # of corresponding result
ArrayList<String> age_sort_result=new ArrayList<String>(); // (only) age list
ArrayList<String> year_list=new ArrayList<String>(); // (only) year list
int[] year_arrange_result=new int[10]; // histogram data
int minYear, maxYear; // min year, max year (in year list)
float year_gap; // histogram gap

void getStatistic() {
  if (!isLoading) return; // thread killed
  if (total_num<=0) return;

  // counts the appropriate data and provide statistics.
  age.clear();
  for (game G : games) {
    // Getting age data
    String ageTemp=G.getAttribute(4);
    if (age.containsKey(ageTemp)) {
      // value update
      age.put(ageTemp, age.get(ageTemp)+1);
    } else {
      // new
      age.put(ageTemp, 1);
    }
  }
  if (age.containsKey("")) {
    age.put("N/A", age.remove(""));
  }

  // age list sort
  Iterator temp;
  temp=sortHashMapByValue(age);
  age_sort_result.clear();
  while (temp.hasNext()) {
    String k = (String) temp.next();
    age_sort_result.add(k);
  }

  // year data processing
  years.clear();
  year_list.clear();
  // counts the appropriate data and provide statistics.
  for (game G : games) {
    // Getting years data
    String yearTemp="";
    try {
      // get year part of string
      yearTemp=G.getAttribute(6).substring(0, 4);
    } 
    catch(StringIndexOutOfBoundsException e) {
      yearTemp="";
    } 
    finally {
      if (years.containsKey(yearTemp)) {
        // value update
        years.put(yearTemp, years.get(yearTemp)+1);
      } else {
        // new
        years.put(yearTemp, 1);
      }
      if (!year_list.contains(yearTemp)) {
        year_list.add(yearTemp);
      }
    }
  }
  years.remove("");
  year_list.remove("");
  Collections.sort(year_list);

  // cutting data
  minYear=int(year_list.get(0));
  maxYear=int(year_list.get(year_list.size()-1));
  year_gap=(float)(maxYear-minYear)/10;

  // data arrange
  for (int i=0; i<10; i+=1) {
    year_arrange_result[i]=0;
  }
  for (String i : year_list) {
    int index=int((int(i)-minYear)/year_gap);
    try {
      year_arrange_result[index]+=years.get(i);
    } 
    catch(ArrayIndexOutOfBoundsException e) {
      // out of bound
      year_arrange_result[9]+=years.get(i);
    }
  }
}

Iterator sortHashMapByValue(final HashMap map) {
  ArrayList<String> list = new ArrayList();
  list.addAll(map.keySet());
  Collections.sort(list, new Comparator() {
    public int compare(Object o1, Object o2) {
      Object v1 = map.get(o1);
      Object v2 = map.get(o2);
      return ((Comparable) v1).compareTo(v2);
    }
  }
  );
  Collections.reverse(list);
  return list.iterator();
}
