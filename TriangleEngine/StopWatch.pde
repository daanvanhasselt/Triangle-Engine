class StopWatch{
  int totalTime = 2000;
  float fraction;
  float startTime;
  boolean running;
  
  void start(){
    running = true;
    fraction = 0;
    startTime = millis();
  }
  
  void stop(){
    running = false;
    fraction = 0;
  }
  
  float update(){  // returns normalized number
    if(running)
      fraction = (millis() - startTime) / totalTime;

    if(fraction > 1)
        fraction = 1;
    return fraction;
  }
};
