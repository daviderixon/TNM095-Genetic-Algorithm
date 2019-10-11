class Population{
  ArrayList<Creature> inhabitants;
  Population(){
   inhabitants = new ArrayList<Creature>();
  }
  void add(Creature c){
    inhabitants.add(c); 
  }
  int size(){
    return inhabitants.size(); 
  }
  void remove(Creature c){
    inhabitants.remove(c); 
  }
  void addRandomInhabitants(int n){
    for(int i = 0; i < n; i++){
      inhabitants.add(new Creature(new PVector(random(0,width),random(0,height)),new PVector(1,1), new DNA(0.05)));
    }
  }
  void resetDay(){
    ArrayList<Creature> RemovableObjects = new ArrayList<Creature>();
    for( Creature c : inhabitants){
      if(c.FoodsEaten == 0){
          RemovableObjects.add(c);
      }
      c.dna.Fitness(c.FoodsEaten);
      c.FoodsEaten = 0;
    }
    for(Creature r : RemovableObjects){
       inhabitants.remove(r); 
    }
    Collections.sort(inhabitants, new CreatureComparator());
    
    for(int i = 0; i < size()/2;i+=2){
      DNA d = inhabitants.get(i).dna.CrossOver(inhabitants.get(i+1).dna);
      inhabitants.add(new Creature(new PVector(random(0,width),random(0,height)),new PVector(1,1), d));
      
    }
  }
  void draw(float dt, ArrayList<Food> List){
      for( Creature c : inhabitants){
        c.draw(dt, List, this);
      }
  }
  ArrayList<Creature> creaturesInSight(Creature Viewer){
    ArrayList<Creature> creaturesInSight = new ArrayList<Creature>();
    PVector Temp = new PVector();
    for(Creature c : inhabitants){
      Temp = c.Position.copy();
      Temp.sub(Viewer.Position);
      if(Temp.mag() < Viewer.viewDistance){
        if(Temp.mag() < Viewer.size && Viewer.isEvil && c != Viewer && !c.dead && !c.isEvil && c.FoodsEaten > 0){
            Viewer.FoodsEaten += c.FoodsEaten;
            c.die();
        }
        Temp.normalize();
        if(Temp.dot(Viewer.Forward) > cos(Viewer.fieldOfView/2) && !c.isEvil ){
         creaturesInSight.add(c);
        }
      }
      
    }
    return creaturesInSight;
    
  }
}
