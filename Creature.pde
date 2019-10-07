public class Creature{
  PVector Position;
  PVector Forward;
  float size;
  float speed;
  float viewDistance;
  float fieldOfView;
  float maxTurnRate;
  float turnRate;
  float forwardRate;
  float evilness;
  int FoodsEaten;
  boolean dayTime;
  boolean isEvil;
  boolean dead = false;
  DNA dna;
  Creature(PVector initPosition, PVector initForward, DNA _dna){
    dna = _dna;
    Position = initPosition;
    Forward = initForward;
    Forward.normalize();
    size = dna.Size;
    speed = dna.Speed;
    viewDistance = dna.ViewDistance;
    fieldOfView = dna.FieldOfView;
    maxTurnRate = dna.MaxTurnRate;
    evilness = dna.Evilness;
    isEvil = dna.Evilness > 0.5;
    turnRate = 0.0;
    forwardRate = 1.0;
    FoodsEaten = 0;
  }
  void FindFood(ArrayList<Food> List){
    PVector Temp = new PVector();
    ArrayList<Food> RemovableObjects = new ArrayList<Food>();
    
    for(Food f : List){
      Temp = f.Position.copy();
      Temp.sub(Position);
      if(Temp.mag() < viewDistance){
        if(Temp.mag() < size){ // Going over a food and eating it.
          FoodsEaten++;
          RemovableObjects.add(f);
        }
        
        Temp.normalize();
        if(Temp.dot(Forward) > cos(fieldOfView/2)){
          fill(0,255,0);
          circle(f.Position.x,f.Position.y, 10);
        }
      }
    }
    for(Food rem : RemovableObjects){
     List.remove(rem); 
    }
  }
  void die(){
    dead = true;
    FoodsEaten = 0;
  }
  ArrayList<Food> AvailableFoods(ArrayList<Food> List){
    PVector Temp = new PVector();
    ArrayList<Food> Foods = new ArrayList<Food>();
    for(Food f : List){
      Temp = f.Position.copy();
      Temp.sub(Position);
      if(Temp.mag() < viewDistance){
        Temp.normalize();
        if(Temp.dot(Forward) > cos(fieldOfView/2)){
          Foods.add(f);
        }
        
      }
      
    }
    return Foods;
  }
  ArrayList<Creature> CreaturesInSight(ArrayList<Creature> pop){
    ArrayList<Creature> CInSight = new ArrayList<Creature>();
    PVector Temp = new PVector();
    for(Creature c : pop){
      Temp = c.Position.copy();
      Temp.sub(Position);
      if(Temp.mag() < viewDistance){
        if(Temp.mag() < size && isEvil && c != this && !c.dead && !c.isEvil){
            c.die();
            FoodsEaten++;
          
          
        }
        Temp.normalize();
        if(Temp.dot(Forward) > cos(fieldOfView/2) && !c.isEvil ){
         CInSight.add(c);
        }
      }
      
    }
    return CInSight;
  }
  void control(ArrayList<Food> List, ArrayList<Creature> pop){
    ArrayList<Food> Foods = AvailableFoods(List);
    ArrayList<Creature> CreaturesInSight = CreaturesInSight(pop);
    if(isEvil && CreaturesInSight.size() > 0){
      
      PVector Temp = new PVector();
      PVector Target = new PVector();
      float TempTargetMag = -1;
      for(Creature c : CreaturesInSight){
        Temp = c.Position.copy();
        Temp.sub(Position);
        if(Temp.mag() < TempTargetMag || TempTargetMag < 0 ){
          Target = c.Position;
          TempTargetMag = Temp.mag();
        }
      }
      PVector TargetForward = new PVector();
      TargetForward = Target.copy();
      TargetForward.sub(Position);
      TargetForward.normalize();
      turnRate = atan2(-1*Forward.y*TargetForward.x + Forward.x*TargetForward.y,Forward.dot(TargetForward));
    }
    else if(Foods.size() > 0){ // Food in Sight
      PVector Temp = new PVector();
      PVector Target = new PVector();
      float TempTargetMag = -1;
      for(Food f : Foods){
        Temp = f.Position.copy();
        Temp.sub(Position);
        if(Temp.mag() < TempTargetMag || TempTargetMag < 0){
          Target = f.Position;
          TempTargetMag = Temp.mag();
        }
      }
      PVector TargetForward = new PVector();
      TargetForward = Target.copy();
      TargetForward.sub(Position);
      TargetForward.normalize();
      turnRate = atan2(-1*Forward.y*TargetForward.x + Forward.x*TargetForward.y,Forward.dot(TargetForward));
    }
    else{
      if(Position.x < 40.0 && Position.y < 40.0){
        PVector TargetForward = new PVector(1,1);
        turnRate = atan2(-1*Forward.y*TargetForward.x + Forward.x*TargetForward.y,Forward.dot(TargetForward));
      }
      else if(Position.x > width - 40.0 && Position.y < 40.0){
        PVector TargetForward = new PVector(-1,1);
        turnRate = atan2(-1*Forward.y*TargetForward.x + Forward.x*TargetForward.y,Forward.dot(TargetForward));
      }
      else if(Position.x < 40.0 && Position.y > width - 40.0){
        PVector TargetForward = new PVector(1,-1);
        turnRate = atan2(-1*Forward.y*TargetForward.x + Forward.x*TargetForward.y,Forward.dot(TargetForward));
      }
      else if(Position.x > width - 40.0 && Position.y > width - 40.0){
        PVector TargetForward = new PVector(-1,-1);
        turnRate = atan2(-1*Forward.y*TargetForward.x + Forward.x*TargetForward.y,Forward.dot(TargetForward));
      }
      else if(Position.x < 40.0){
        PVector TargetForward = new PVector(1,0);
        turnRate = atan2(-1*Forward.y*TargetForward.x + Forward.x*TargetForward.y,Forward.dot(TargetForward));
      }
      else if(Position.x > width - 40.0){
        PVector TargetForward = new PVector(-1,0);
        turnRate = atan2(-1*Forward.y*TargetForward.x + Forward.x*TargetForward.y,Forward.dot(TargetForward));
      }
      else if(Position.y < 40.0){
        PVector TargetForward = new PVector(0,1);
        turnRate = atan2(-1*Forward.y*TargetForward.x + Forward.x*TargetForward.y,Forward.dot(TargetForward));
      }
      else if(Position.y > height - 40.0){
        PVector TargetForward = new PVector(0,-1);
        turnRate = atan2(-1*Forward.y*TargetForward.x + Forward.x*TargetForward.y,Forward.dot(TargetForward));
      }else{
        
       turnRate = 1.0 - noise(Position.x/width*50,Position.y/height*50)*2;
      }
     
    }
    
  }
  void draw(float dt, ArrayList<Food> List, ArrayList<Creature> pop){
    if(!dead){
      FindFood(List);
      control(List, pop);
      
      //control();
      Forward.rotate(maxTurnRate * turnRate * dt);
      PVector Direction = new PVector(Forward.x,Forward.y).mult(speed * forwardRate * dt);
      if(Position.x + Direction.x > 0 && Position.x + Direction.x < width && Position.y +Direction.y > 0 && Position.y + Direction.y < height){
        Position.add(Direction);
      }
      fill(0,255,0,100);
      arc(Position.x,Position.y,viewDistance*2,viewDistance*2,Forward.heading()-fieldOfView/2, Forward.heading()+fieldOfView/2);
    
      PVector side = new PVector(Forward.y,Forward.x*-1);
      if(isEvil){
        fill(126,0,0);
      }
      else{
        fill(255); // Draw the triangle;
      }
      triangle(Position.x+Forward.x*size/2, Position.y+Forward.y*size/2, Position.x+side.x*size/2*-1-Forward.x*size/2 ,Position.y+side.y*size/2*-1-Forward.y*size/2,Position.x+side.x*size/2-Forward.x*size/2,Position.y+side.y*size/2-Forward.y*size/2 );
    }
    else{
      fill(0);
      circle(Position.x, Position.y, size);
    }  
  }

   
}
