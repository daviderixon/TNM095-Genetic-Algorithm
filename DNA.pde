class DNA{
  
  /*
    Dna class illustrated with an array of genes
    fieldName, minValue, maxValue, Value
  */
  float fitness;
  float MutationRate;
  
  
  ArrayList<Gene> Genes = new ArrayList<Gene>();
  DNA(float _mutateRate){
    MutationRate = _mutateRate;
    Genes.add(new Gene("Size", 20,40));
    Genes.add(new Gene("Speed", 80,120));
    Genes.add(new Gene("FieldOfView", PI/100,PI));
    Genes.add(new Gene("ViewDistance", 20,150));
    Genes.add(new Gene("MaxTurnRate", PI/12,PI));
    Genes.add(new Gene("Evilness", 0.5));
  }
  void Add(Gene g){
    Genes.add(g);
  }
  void Empty(){
    Genes.clear();
  }
  Float get(String term){
    for(Gene g : Genes){
      if(g.fieldName == term){
        return g.Value;  
      }
    }
    return null;
  }
  void Mutate(){
    for(Gene g : Genes){
      if(random(1) < MutationRate){
        g.Mutate();
        NUMBER_OF_MUTATION++;
        
      }
    }
  }
  DNA CrossOver(DNA Partner){
    DNA Child = new DNA(MutationRate);
    Child.Empty();
    for(int i = 0; i < Genes.size(); i++){
      for(int j = 0; j < Partner.Genes.size(); j++){
        if(Genes.get(i).fieldName == Partner.Genes.get(j).fieldName){
          Child.Add(Genes.get(i).CrossOver(Partner.Genes.get(j)));
        }
      }
    }
    Child.Mutate();
    return Child;
  }
  void Fitness(int f){
    fitness = f;
  }
  
  
}
