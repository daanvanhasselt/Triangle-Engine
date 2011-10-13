import java.util.Set;

class Person{
  PVector pos;
  ArrayList personalTriangles;
  HashMap trianglePoints;
  color fillColor;
  PVector[] points = new PVector[3];
  
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
     /*--------------------------------*/
     /*------------ MODE 1 ------------*/
     /*--------------------------------*/
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
   
   // first, get the first point
      int i = 0;
      int index = ((Number)sortedArray[i]).intValue();              // get the index of the point    
      Triangle tri = (Triangle) triangles.get(floor(index / 3));    // floor(index / 3) is the triangle index
      stroke(0);
      if(index % 3 == 0){    // check with % if it's point A, B or C
        points[0] = tri.A;
      }
      if(index % 3 == 1){
        points[0] = tri.B;
      }
      if(index % 3 == 2){
        points[0] = tri.C;
      }
      
      while(isThisLineIntersectingWithAnotherLine(pos.x, pos.y, points[0].x, points[0].y, triangles)){
        if(i >= sortedArray.length){
          return;
        }
          
        pushStyle();
        strokeWeight(2);
        stroke(255, 0, 0);
        line(pos.x, pos.y, points[0].x, points[0].y);
        popStyle();
        index = ((Number)sortedArray[i]).intValue();              // get the index of the point    
        tri = (Triangle) triangles.get(floor(index / 3));    // floor(index / 3) is the triangle index
        stroke(0);
        if(index % 3 == 0){    // check with % if it's point A, B or C
          points[0] = tri.A;
        }
        if(index % 3 == 1){
          points[0] = tri.B;
        }
        if(index % 3 == 2){
          points[0] = tri.C;
        }
        i++;
      }
      
      // now get the second point
      // iterate through the sortedArray until we find a new point
      points[1] = points[0];
      while((points[1].x == points[0].x && points[1].y == points[0].y) || isThisLineIntersectingWithAnotherLine(pos.x, pos.y, points[1].x, points[1].y, triangles)){
        if(i >= sortedArray.length){
          return;
        }
        index = ((Number)sortedArray[i]).intValue();              // get the index of the point
        tri = (Triangle) triangles.get(floor(index / 3));    // floor(index / 3) is the triangle index
        stroke(0);
        if(index % 3 == 0){    // check with % if it's point A, B or C
          points[1] = tri.A;
        }
        if(index % 3 == 1){
          points[1] = tri.B;
        }
        if(index % 3 == 2){
          points[1] = tri.C;
        }
        i++;
      }
      if(dist(pos.x, pos.y, points[1].x, points[1].y) > criticalDistance){
        return;
      }
      points[2] = pos;
      fill(fillColor);
      stroke(0);
      triangle(points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y);
//    stroke(255, 0, 0);
//    line(pos.x, pos.y, points[0].x, points[0].y);
//    stroke(0, 255, 0);
//    line(pos.x, pos.y, points[1].x, points[1].y);      
    
    
     /*--------------------------------*/
     /*------------ MODE 2 ------------*/
     /*--------------------------------*/
/*
    for(int i = 0; i < triangles.size(); i++){
      Triangle tri = (Triangle) triangles.get(i);
      float distanceToCenter = dist(pos.x, pos.y, tri.center.x, tri.center.y);
      if(distanceToCenter < criticalDistance){        // let's find the two closest points
        float distanceToA =  dist(pos.x, pos.y, tri.A.x, tri.A.y);
        float distanceToB = dist(pos.x, pos.y, tri.B.x, tri.B.y);
        float distanceToC = dist(pos.x, pos.y, tri.C.x, tri.C.y);
        
        if(distanceToA < distanceToB && distanceToA < distanceToC){
          line(pos.x, pos.y, tri.A.x, tri.A.y);
        }
        if(distanceToB < distanceToA && distanceToB < distanceToC){
          line(pos.x, pos.y, tri.B.x, tri.B.y);
        }
        if(distanceToC < distanceToA && distanceToC < distanceToB){
          line(pos.x, pos.y, tri.C.x, tri.C.y);
        }
      }
    }
 */ 
  }
  
  Triangle currentTriangle(){
    return new Triangle(points[0], points[1], points[2]);
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
    
  boolean isThisLineIntersectingWithAnotherLine(float x1, float y1, float x2, float y2, ArrayList triangles){
    for(int i = 0; i < triangles.size(); i++) {
      Triangle tri = (Triangle) triangles.get(i);
      PVector intersectingWithA = segIntersection(x1, y1, x2, y2, tri.A.x, tri.A.y, tri.B.x, tri.B.y);
      PVector intersectingWithB = segIntersection(x1, y1, x2, y2, tri.B.x, tri.B.y, tri.C.x, tri.C.y);
      PVector intersectingWithC = segIntersection(x1, y1, x2, y2, tri.C.x, tri.C.y, tri.A.x, tri.A.y);
      if(intersectingWithA != null || intersectingWithB != null || intersectingWithC != null){
        return true;
      }
    }
    return false;
  }
  
  PVector segIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) 
  { 
    float bx = x2 - x1; 
    float by = y2 - y1; 
    float dx = x4 - x3; 
    float dy = y4 - y3;
    float b_dot_d_perp = bx * dy - by * dx;
    if(b_dot_d_perp == 0) {
      return null;
    }
    float cx = x3 - x1;
    float cy = y3 - y1;
    float t = (cx * dy - cy * dx) / b_dot_d_perp;
    if(t <= 0 || t >= 1) {
      return null;
    }
    float u = (cx * by - cy * bx) / b_dot_d_perp;
    if(u <= 0 || u >= 1) { 
      return null;
    }
    return new PVector(x1+t*bx, y1+t*by);
  }
  
};
