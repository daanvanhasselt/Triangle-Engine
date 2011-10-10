Triangle baseTriangle;
ArrayList triangles;
Person person;
StopWatch stopWatch;
boolean personActive = false;
int criticalDistance = 200;

void setup(){
  size(800, 600);
  background(255);
  stopWatch = new StopWatch();
  triangles = new ArrayList(); 
  baseTriangle = new Triangle(new PVector(width/2, height/2 - 50), new PVector(width/2 + 50, height/2 + 50), new PVector(width/2 - 50, height/2 + 50));
  triangles.add(baseTriangle);
  smooth();
}

void draw(){
  background(255); 
  baseTriangle.draw();
  if(personActive){
    person.draw();
    person.checkForNewTriangle(triangles, criticalDistance);
    float fraction = stopWatch.update();
    person.fillColor = color(100, 100, 100, fraction * 255.0);
  }
}

void mousePressed(){
  person = new Person(new PVector(mouseX, mouseY));
  personActive = true;
  stopWatch.start();
}

void mouseDragged(){
  person.pos = new PVector(mouseX, mouseY);
  stopWatch.start();
}

void mouseReleased(){
  personActive = false;
}
