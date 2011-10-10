class StopWatch{
  int totalTime = 2000;
  float fraction;
  float startTime;
  
  void start(){
    fraction = 0;
    startTime = millis();
  }
  
  float update(){  // returns normalized number
    fraction = (millis() - startTime) / totalTime;

    if(fraction > 1)
        fraction = 1;
    return fraction;
  }
};
