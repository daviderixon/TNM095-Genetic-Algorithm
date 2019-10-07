class DNA{
  float fitness;
  float MutationRate;
  
  float Size;
  float Speed;
  float FieldOfView;
  float ViewDistance;
  float MaxTurnRate;
  float Evilness;
  DNA(float _mutateRate){
    MutationRate = _mutateRate;
    Size = random(20,40);
    Speed = random(80,120);
    FieldOfView = random(PI/100, PI);
    ViewDistance = random(20, 150);
    MaxTurnRate = random(PI/12, PI);
    if(random(1) < 0.01){
      Evilness = 1.0; 
    }
    else{
      Evilness = 0.0;
    }
  }
  void Mutate(){
    if(random(1) < MutationRate){
      Size = random(20,40);
      NUMBER_OF_MUTATION++;
    }
    if(random(1) < MutationRate){
      Speed = random(80,120);
      NUMBER_OF_MUTATION++;
    }
    if(random(1) < MutationRate){
      FieldOfView = random(PI/100, PI);
      NUMBER_OF_MUTATION++;
    }
    if(random(1) < MutationRate){
      ViewDistance = random(20, 150);
      NUMBER_OF_MUTATION++;
    }
    if(random(1) < MutationRate){
      MaxTurnRate = random(PI/12, PI);
      NUMBER_OF_MUTATION++;
    }
    if(random(1) < MutationRate){
      if(random(1) < 0.01){
        Evilness = 1.0; 
      }
      else{
        Evilness = 0.0;
      }
      NUMBER_OF_MUTATION++;
    }
  }
  DNA CrossOver(DNA Partner){
    DNA Child = new DNA(MutationRate);
    if(random(1) < 0.5){
      Child.Size = Size;
    }
    else{
      Child.Size = Partner.Size;
    }
    if(random(1) < 0.5){
      Child.Speed = Speed;
    }
    else{
      Child.Speed = Partner.Speed;
    }
    if(random(1) < 0.5){
      Child.FieldOfView = FieldOfView;
    }
    else{
      Child.FieldOfView = Partner.FieldOfView;
    }
    if(random(1) < 0.5){
      Child.ViewDistance = ViewDistance;
    }
    else{
      Child.ViewDistance = Partner.ViewDistance;
    }
    if(random(1) < 0.5){
      Child.MaxTurnRate = MaxTurnRate;
    }
    else{
      Child.MaxTurnRate = Partner.MaxTurnRate;
    }
    if(random(1) < 0.5){
      Child.Evilness = Evilness;
    }
    else{
      Child.Evilness = Partner.Evilness;
    }
    Child.Mutate();
    
    return Child;
  }
  void Fitness(int f){
    fitness = f;
  }
  
  
}
