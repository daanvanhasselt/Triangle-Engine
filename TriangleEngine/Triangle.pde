class Triangle{
  PVector A, B, C;
  PVector center;
  
  public Triangle(PVector _A, PVector _B, PVector _C){
    A = _A;
    B = _B;
    C = _C;
    
    center = new PVector( (A.x + B.x + C.x) / 3.0, (A.y + B.y + C.y) / 3.0);
  }
  
  void draw(){
    stroke(0);
    strokeWeight(1);
    fill(100);
    triangle(A.x, A.y, B.x, B.y, C.x, C.y);
        
//    fill(0);
//    ellipse(A.x, A.y, 10, 10);
//    ellipse(B.x, B.y, 10, 10);
//    ellipse(C.x, C.y, 10, 10);
//    ellipse(center.x, center.y, 5, 5);    
  }
  
   boolean isInside(int x, int y)
  {
    float b0, b1, b2, b3;
    // check triangle
    b0 =  (B.x - A.x) * (C.y - A.y) - (C.x - A.x) * (B.y - A.y);
    b1 = ((B.x - x) * (C.y - y) - (C.x - x) * (B.y - y)) / b0;
    b2 = ((C.x - x) * (A.y - y) - (A.x - x) * (C.y - y)) / b0;
    b3 = ((A.x - x) * (B.y - y) - (B.x - x) * (A.y - y)) / b0;

    if((b1 > 0) && (b2 > 0) && (b3 > 0)) {
      return true;
      // println("b0=" + b0);
      // println(b1 + " " + b2 + " " + b3);
    }
    return false;
  }
  
};
