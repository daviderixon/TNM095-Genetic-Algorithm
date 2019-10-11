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
    size = dna.get("Size");
    speed = dna.get("Speed");
    viewDistance = dna.get("ViewDistance");
    fieldOfView = dna.get("FieldOfView");
    maxTurnRate = dna.get("MaxTurnRate");
    evilness = dna.get("Evilness");
    isEvil = evilness > 0.5;
    turnRate = 0.0;
    forwardRate = 1.0;
    FoodsEaten = 0;
  }
  void die(){
    dead = true;
    FoodsEaten = 0;
  }
  ArrayList<Food> AvailableFoods(ArrayList<Food> List){
    PVector Temp = new PVector();
    ArrayList<Food> Foods = new ArrayList<Food>();
    ArrayList<Food> RemovableObjects = new ArrayList<Food>();
    for(Food f : List){
      Temp = f.Position.copy();
      Temp.sub(Position);
      if(Temp.mag() < viewDistance){
        if(Temp.mag() < size){ // Going over a food and eating it.
          if(isEvil && EVIL_CAN_EAT_FOOD){
            FoodsEaten++;
            RemovableObjects.add(f);
          }
          else if(isEvil){}
          else{
            FoodsEaten++;
            RemovableObjects.add(f);
          }
          
        }
        Temp.normalize();
        if(Temp.dot(Forward) > cos(fieldOfView/2)){
          Foods.add(f);
        }
        
      }
      
    }
    for(Food rem : RemovableObjects){
     List.remove(rem); 
    }
    return Foods;
  }
  void draw(float dt, ArrayList<Food> List, Population p){
    if(!dead){
      if(SHOW_HELPERS){
        MarkVisibleFoods(List);
      }
      control(List, p);
      
      Forward.rotate(maxTurnRate * turnRate * dt);
      PVector Direction = new PVector(Forward.x,Forward.y).mult(speed * forwardRate * dt);
      if(Position.x + Direction.x > 0 && Position.x + Direction.x < width && Position.y +Direction.y > 0 && Position.y + Direction.y < height){
        Position.add(Direction);
      }
      if(SHOW_HELPERS){
        fill(0,255,0,100);
        arc(Position.x,Position.y,viewDistance*2,viewDistance*2,Forward.heading()-fieldOfView/2, Forward.heading()+fieldOfView/2);
      }
      
      PVector side = new PVector(Forward.y,Forward.x*-1);
      if(isEvil){
        fill(126,0,0);
      }
      else{
        fill(0,126 + FoodsEaten*20,0); // Draw the triangle;
      }
      triangle(Position.x+Forward.x*size/2, Position.y+Forward.y*size/2, Position.x+side.x*size/2*-1-Forward.x*size/2 ,Position.y+side.y*size/2*-1-Forward.y*size/2,Position.x+side.x*size/2-Forward.x*size/2,Position.y+side.y*size/2-Forward.y*size/2 );
    }
    else{
      fill(0);
      circle(Position.x, Position.y, size);
    }  
  }
  
  // Controling the Creature.
  void control(ArrayList<Food> List, Population pop){
    ArrayList<Food> Foods = AvailableFoods(List);
    ArrayList<Creature> CreaturesInSight = pop.creaturesInSight(this);
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
    else if((isEvil && Foods.size() > 0 && EVIL_CAN_EAT_FOOD) || (!isEvil && Foods.size() > 0)){ // Food in Sight
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
  void MarkVisibleFoods(ArrayList<Food> List){
    PVector Temp = new PVector();
    ArrayList<Food> RemovableObjects = new ArrayList<Food>();
    
    for(Food f : List){
      Temp = f.Position.copy();
      Temp.sub(Position);
      if(Temp.mag() < viewDistance){
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

   
}
public class CreatureComparator implements Comparator<Creature> {
    @Override
    public int compare(Creature o1, Creature o2) {
        Integer fitness1 = (int)o1.dna.fitness;
        Integer fitness2 = (int)o2.dna.fitness;
        return fitness1.compareTo(fitness2);
    }
}
