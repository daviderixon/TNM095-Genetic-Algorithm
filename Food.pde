class Food{
  PVector Position;
  float energy;
  Food(PVector _Position){
    Position = _Position;
    energy = 50;
  }
  float eat(){
     return energy; 
  }
  void draw(){
    fill(255,0,0);
    circle(Position.x,Position.y,10);
  }

}
