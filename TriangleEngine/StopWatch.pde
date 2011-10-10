class StopWatch{
  int totalTime = 1000;
  float fraction;
  float startTime;
  
  void start(){
    fraction = 0;
    startTime = millis();
  }
  
  float update(){  // returns normalized number
    fraction = millis() - startTime / totalTime;
    return fraction;
  }
};
