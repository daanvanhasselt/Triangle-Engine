import java.util.Set;

class Person{
  PVector pos;
  ArrayList personalTriangles;
  HashMap trianglePoints;
  
  /* About the modes:
   * Because this is a tool meant for prototyping, we have to be flexible. With this system the user is able to select a mode and try it out, 
   * and the developer is able to easily add new modes based on user feedback.
   * 
   * mode 0 connects to the 2 closest points, it doesn't matter if those points are part of the same triangle. Both points have to be within a critical range.
   * mode 1 connects to the 2 closest points part of the same triangle. Both points have to be within a critical range.
   */
  int mode = 0;
  
  public Person(PVector _pos){
    personalTriangles = new ArrayList();
    trianglePoints = new HashMap();
    pos = _pos;
  }
  
  void draw(){
    fill(0);
    ellipse(pos.x, pos.y, 20, 20); 
  }
  
  void checkForNewTriangle(ArrayList triangles, int criticalDistance){
    // put all the points of all the triangles into a hashmap so we can sort them, based on distance to our own position
    for(int i = 0; i < triangles.size(); i++) {
      Triangle tri = (Triangle) triangles.get(i);
      trianglePoints.put(i * 3, dist(pos.x, pos.y, tri.A.x, tri.A.y));
      trianglePoints.put(i * 3+1, dist(pos.x, pos.y, tri.B.x, tri.B.y));
      trianglePoints.put(i * 3+2, dist(pos.x, pos.y, tri.C.x, tri.C.y));
    }
    trianglePoints = sortHashMap(trianglePoints);    // sort the points
    Set keyset = trianglePoints.keySet();            // get a keyset
    Object[] sortedArray = keyset.toArray();         // and convert that to an array
  
    // now, let's draw 2 lines to the closest points
    // but only if they're both within the critical distance (if the second one is in range, then the first one is too)
    float distance = ((Number)trianglePoints.get(sortedArray[1])).floatValue();
    if(distance < criticalDistance){
      for(int i = 0; i < 2; i++){
        int index = ((Number)sortedArray[i]).intValue();              // get the index of the point
        Triangle tri = (Triangle) triangles.get(floor(index / 3));    // floor(index / 3) is the triangle index
        stroke(255, 0, 0);
        if(index % 3 == 0){    // check with % if it's point A, B or C
          line(pos.x, pos.y, tri.A.x, tri.A.y);
        }
        if(index % 3 == 1){
          line(pos.x, pos.y, tri.B.x, tri.B.y);
        }
        if(index % 3 == 2){
          line(pos.x, pos.y, tri.C.x, tri.C.y);
        }
      }
    }
    

//    for(int i = 0; i < triangles.size(); i++){
//      Triangle tri = (Triangle) triangles.get(i);
//      float distanceToCenter = dist(pos.x, pos.y, tri.center.x, tri.center.y);
//      if(distanceToCenter < criticalDistance){        // let's find the two closest points
//        float distanceToA =  dist(pos.x, pos.y, tri.A.x, tri.A.y);
//        float distanceToB = dist(pos.x, pos.y, tri.B.x, tri.B.y);
//        float distanceToC = dist(pos.x, pos.y, tri.C.x, tri.C.y);
//        
//        if(distanceToA < distanceToB && distanceToA < distanceToC){
//          line(pos.x, pos.y, tri.A.x, tri.A.y);
//        }
//        if(distanceToB < distanceToA && distanceToB < distanceToC){
//          line(pos.x, pos.y, tri.B.x, tri.B.y);
//        }
//        if(distanceToC < distanceToA && distanceToC < distanceToB){
//          line(pos.x, pos.y, tri.C.x, tri.C.y);
//        }
//      }
//    }
    
  }
  
  private HashMap<Integer, Float> sortHashMap(HashMap<Integer, Float> input){
    Map<Integer, Float> tempMap = new HashMap<Integer, Float>();    // copy map
    for (int wsState : input.keySet()){
        tempMap.put(wsState,input.get(wsState));          // fill it
    }
    List<Integer> mapKeys = new ArrayList<Integer>(tempMap.keySet());
    List<Float> mapValues = new ArrayList<Float>(tempMap.values());
    List<Float> sortedMapValues = new ArrayList<Float>(tempMap.values());

    Collections.sort(sortedMapValues);                    // sort the values
    Object[] sortedArray = sortedMapValues.toArray();
    
    ArrayList takenIndices = new ArrayList();  // for detecting duplicates
    HashMap<Integer, Float> sortedMap = new LinkedHashMap<Integer, Float>();  // for the sorted results
    for(int i = 0; i < sortedArray.length; i++){
      int index = mapValues.indexOf(sortedArray[i]);  // what is the index of this value in the sortedArray?
      if(takenIndices.contains(index)){               // if it's already there
        index++;                                      // prevent duplicates
      }
      takenIndices.add(index);
      
      sortedMap.put(mapKeys.get(index),               // fill map with sorted values
                      (Float)sortedArray[i]);
    }
    return sortedMap;
  }
  
};
