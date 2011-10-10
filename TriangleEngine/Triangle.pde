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
        
    fill(0);
    ellipse(A.x, A.y, 10, 10);
    ellipse(B.x, B.y, 10, 10);
    ellipse(C.x, C.y, 10, 10);
    
    ellipse(center.x, center.y, 5, 5);    
  }
};
