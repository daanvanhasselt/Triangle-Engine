Triangle baseTriangle;    // this triangle is always present in the center of the screen
ArrayList triangles;      // this arraylist contains the rest of the triangles
Person person;            // in this prototype, only one person can exist
StopWatch stopWatch;      // this is the timer used to determine when a triangle 'freezes'
boolean personActive = false;  // is there a person walking in our screen?
int criticalDistance = 200;    // new triangles are only formed when a person is within this many pixels of the existing points

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
  for(int i = 0; i < triangles.size(); i++){
    Triangle tri = (Triangle)triangles.get(i);
    tri.draw();
  }
  
  if(personActive){    // is someone in the room?
    person.draw();     // if so, draw him/her
    person.criticalDistance = criticalDistance;
    person.checkForNewTriangle(triangles);  // check if he/she has to be connected and with which points
    float fraction = stopWatch.update();                      // how long has he/she been standing still? (normalized value)
    person.fillColor = color(100, 100, 100, fraction * 255.0);  // set the color according to the timer
    if(fraction == 1){    // it's time to freeze the triangle!
        if(person.hasTriangle){
          triangles.add(person.currentTriangle());
        }
        stopWatch.stop();
    }
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
