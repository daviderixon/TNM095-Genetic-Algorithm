class OpenGraph{
  ArrayList<Float> Data = new ArrayList<Float>();
  String Name;
  float GWidth;
  float GHeight;
  float HighRangeY;
  float LowRangeY;
  PVector Position;
  color MainColor;
  color BackgroundColor;
  
  float OFFSET = 40;
  OpenGraph(String _Name,PVector _Position, float _GWidth, float _GHeight,float _LowRangeY, float _HighRangeY, color c, color bg){
    Name = _Name;
    GWidth =_GWidth;
    GHeight = _GHeight;
    HighRangeY = _HighRangeY;
    LowRangeY = _LowRangeY;
    Position = _Position;
    MainColor = c;
    BackgroundColor = bg;
    
  }
  void add(float f){
    Data.add(f);
  }
  void draw(){
    fill(BackgroundColor);
    stroke(BackgroundColor);
    rect(Position.x,Position.y,GWidth,GHeight);
    fill(MainColor);
    strokeWeight(5);
    stroke(MainColor);
    textSize(16);
    textAlign(CENTER);
    if(Data.size() > 1){
      float delta = Data.get(Data.size() - 1)-Data.get(Data.size() - 2);
      text("Delta: " + delta, Position.x + GWidth/2, Position.y + OFFSET); 
    }
    
    text(Name, Position.x + GWidth/2, Position.y + OFFSET/2);
    
    line(Position.x + OFFSET, Position.y + GHeight - OFFSET, Position.x + OFFSET, Position.y + OFFSET);
    line(Position.x + OFFSET, Position.y + GHeight - OFFSET, Position.x + GWidth-OFFSET, Position.y + GHeight - OFFSET);
    float xStep = (GWidth-2*OFFSET)/(Data.size()-1);
    int step = 0;
    PVector PrevPoint = new PVector();
    PVector CurrentPoint;
    boolean FirstRun = true;
    for( float d : Data){
      float normalizedData = (d-LowRangeY)/(HighRangeY-LowRangeY);
      float val = OFFSET + (1-normalizedData)*(GHeight-2*OFFSET);
      CurrentPoint = new PVector(Position.x +OFFSET + xStep * step, Position.y + val);
      circle(CurrentPoint.x, CurrentPoint.y, 3);
      if(!FirstRun){
        line(PrevPoint.x,PrevPoint.y,CurrentPoint.x,CurrentPoint.y);
      }else{
        FirstRun = false;
      }
      PrevPoint = CurrentPoint;
      step++;
    }
    fill(0, 102, 153);
    textAlign(LEFT);
    text(HighRangeY, Position.x , Position.y + OFFSET); 
    text(LowRangeY, Position.x , Position.y + GHeight - OFFSET/2); 
    fill(MainColor);
    strokeWeight(0);
    stroke(0);
    
  }

}
