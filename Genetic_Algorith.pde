import java.util.*;
Creature c;
int MAX_FOODS = 200;
int INITIAL_CREATURES = 15;
int NUMBER_OF_MUTATION = 0;
float homeHeight = 70;
float homeWidth = 70;
float millisInDay = 10000;
float ActualTime;
float time;
float coolDown = 0.0;
int halfDay;
boolean Daytime = true;
float[] house = new float[4];
float dt;
ArrayList<Food> FoodList = new ArrayList<Food>();
ArrayList<Creature> population = new ArrayList<Creature>();
ArrayList<Creature> matingPool = new ArrayList<Creature>();
float AverageSize;
float AverageSpeed;
float AverageViewDistance;
float AverageMaxTurnRate;
float AverageFieldOfView;
float AverageEvilness;
boolean drawingGraphs = false;
OpenGraph popGraph;
OpenGraph sizeGraph;
OpenGraph speedGraph;
OpenGraph viewDistGraph;
OpenGraph FoVGraph;
OpenGraph trnRateGraph;
OpenGraph evilGraph;
void setup(){
  size(1920,1080);
  time = 0;
  ActualTime = 0;
  dt = 1/60;
  halfDay = 1;
  for(int i = 0; i < INITIAL_CREATURES; i++){
    population.add(new Creature(new PVector(random(0,width),random(0,height)),new PVector(1,1), new DNA(0.05)));
  }
  addFoods(MAX_FOODS);
  calculateAverages();
  popGraph = new OpenGraph("Population",new PVector(0,0), width/3, height/2,0, 160,color(0,0,0), color(255,255,255,126));
  popGraph.add(population.size());
  sizeGraph = new OpenGraph("AverageSize",new PVector(0,height/2), width/3,height/2, 20, 40,color(0,0,0), color(255,255,255,126));
  sizeGraph.add(AverageSize);
  speedGraph = new OpenGraph("AverageSpeed",new PVector(width/3,0), width/3, height/2,80, 120,color(0,0,0), color(255,255,255,126));
  speedGraph.add(AverageSpeed);
  viewDistGraph = new OpenGraph("AverageViewDistance",new PVector(width/3,height/2), width/3, height/2,20, 150,color(0,0,0), color(255,255,255,126));
  viewDistGraph.add(AverageViewDistance);
  FoVGraph = new OpenGraph("AverageFieldOfView",new PVector(width*2/3,0), width/3, height/2, PI/100, PI,color(0,0,0), color(255,255,255,126));
  FoVGraph.add(AverageFieldOfView);
  evilGraph = new OpenGraph("AverageEvilness",new PVector(width*2/3,height/2), width/3, height/2,0, 1,color(0,0,0), color(255,255,255,126));
  evilGraph.add(AverageEvilness);
  
}
void calculateAverages(){
  AverageSize = 0;
  AverageSpeed = 0;
  AverageViewDistance = 0;
  AverageMaxTurnRate = 0;
  AverageFieldOfView = 0;
  AverageEvilness = 0;
  
 for(Creature c : population){
   AverageSize+= c.dna.get("Size");
   AverageSpeed+= c.dna.get("Speed");
   AverageViewDistance+= c.dna.get("ViewDistance");
   AverageMaxTurnRate += c.dna.get("MaxTurnRate");
   AverageFieldOfView += c.dna.get("FieldOfView");
   AverageEvilness += c.dna.get("Evilness");
 }
   AverageSize/= population.size();
   AverageSpeed/= population.size();
   AverageViewDistance/= population.size();
   AverageMaxTurnRate /= population.size();
   AverageFieldOfView /= population.size();
   AverageEvilness /= population.size();
}
void addFoods(int Foods){
  for(int i = 0; i < Foods; i++){
    
    float randWidth = random(width);
    float randHeight = random(height);
    while(randWidth > house[0] && randWidth < house[1] && randHeight > house[2] && randHeight < house[3]){ // if the food is in the house, redo position
      randWidth = random(width);
      randHeight = random(height);
    }
    PVector foodPositon = new PVector(randWidth,randHeight);
    FoodList.add(new Food(foodPositon));
  }
}
void dayReset(){
  ArrayList<Creature> RemovableObjects = new ArrayList<Creature>();
  for( Creature c : population){
    if(c.FoodsEaten == 0){
        RemovableObjects.add(c);
    }
    c.dna.Fitness(c.FoodsEaten);
    c.FoodsEaten = 0;
  }
  for(Creature r : RemovableObjects){
     population.remove(r); 
  }
  for(Creature c : population){
    for(int i = 0; i < c.dna.fitness; i++){
      matingPool.add(c);
    }
  }
  int currentSize = population.size()/2;
  for(int i = 0; i < currentSize; i++){
    DNA d = matingPool.get(floor(random(matingPool.size()))).dna.CrossOver(matingPool.get(floor(random(matingPool.size()))).dna);
    population.add(new Creature(new PVector(random(0,width),random(0,height)),new PVector(1,1), d));
  }
  calculateAverages();
  popGraph.add(population.size());
  sizeGraph.add(AverageSize);
  speedGraph.add(AverageSpeed);
  viewDistGraph.add(AverageViewDistance);
  FoVGraph.add(AverageFieldOfView);
  evilGraph.add(AverageEvilness);
}
void draw(){
  time = millis() - (halfDay-1)*millisInDay;
  
  dt = millis() / 1000.0 - ActualTime;
  coolDown-= dt;
  ActualTime = millis() / 1000.0;
  if(time > millisInDay){
    addFoods(MAX_FOODS - FoodList.size());
    halfDay++;
    dayReset();
  }
  background(204);
  // Draw home
  fill(255,0,255, 100);
  rect(house[0],house[2],house[1],homeHeight);
  for (Food f : FoodList) {
    f.draw();
  }
  for( Creature c : population){
    c.draw(dt, FoodList, population);
  }
  if(drawingGraphs){
    popGraph.draw();
    sizeGraph.draw();
    speedGraph.draw();
    viewDistGraph.draw();
    FoVGraph.draw();
    evilGraph.draw();
  }
  else{
    textSize(24);
    fill(0, 102, 153);
    textAlign(CENTER);
    text("Day " + halfDay, width/2, 30);
    text("Population: " + population.size(), width/2, 80); 
    text("Mutations: " + NUMBER_OF_MUTATION, width/2, 120); 
    /*text("AverageSize: " + AverageSize, 10, 120); 
    text("AverageSpeed: " + AverageSpeed, 10, 170); 
    text("AverageViewDistance: " + AverageViewDistance, 10, 220);*/
  }
  
  if (keyPressed) {
    if (key == 'h' || key == 'H') {
      if(coolDown < 0.0){
        drawingGraphs = !drawingGraphs;
        coolDown = 0.5;
      }
    }
  }

  
}
