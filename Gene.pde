

class Gene{
  String fieldName;
  float minValue;
  float maxValue;
  float Value;
  float Chance;
  Gene(String _Name, float _min, float _max, float _value, float _chance){
    fieldName = _Name;
    minValue = _min;
    maxValue = _max;
    Value = _value;
    Chance = _chance;
  }
  Gene(String _Name, float _min, float _max){
    fieldName = _Name;
    minValue = _min;
    maxValue = _max;
    Value = random(minValue, maxValue);
    Chance = 0;
  }
  Gene(String _Name, float _chance){
    fieldName = _Name;
    minValue = 0.0;
    maxValue = 1.0;
    Chance = _chance;
    if(random(1) < Chance ){
      Value = maxValue;
    }
    else{
      Value = minValue;
    }
    
  }
  void Mutate(){
    if(Chance > 0){
      if(random(1) < Chance ){
        Value = maxValue;
      }
      else{
        Value = minValue;
      }
    }
    else{
      Value = random(minValue, maxValue);
    }
  }
  Gene CrossOver(Gene other){
    Gene g;
    if(random(1) < 0.5){
      g = copy();
    }
    else{
      g = other.copy();
    }
    return g;
  }
  Gene copy(){
     Gene g = new Gene(fieldName, minValue, maxValue, Value, Chance); 
     return g;
  }
  
}
