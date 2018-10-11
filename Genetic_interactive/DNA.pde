class DNA {
  byte[] smallDNA;
  byte pat = repeat;
  byte[] dna;
  int num;
  float displacement;
  byte user_like;
  float fitness;

  //JOINT TYPES = 0(none), 1(rod), 2(sine), 3(cos)
  DNA() {
    //num = gridX*gridY*gridZ*gridX*gridY*gridZ;
    num = gridX*gridY*gridZ*neighbors;
    dna = new byte[num];
    for (int i=0; i<num; i++)
      dna[i] = 0;
    smallDNA = new byte[pat*neighbors];
    for (int i=0; i<pat*neighbors; i++)
      smallDNA[i] = 0;
    displacement = 0;
    user_like = 0;
    fitness = 0;
  }
  
  void copy(DNA source) {
    
  }
  
  void printDNA() {
    for (int i=0; i<num; i++) {
      print(dna[i]);
    }
    println("");
  }

  void randomCreate() {
    for (int i=0; i<num; i++) {
      dna[i] = randomJoint();
    } 
  }
  
  void patternCreate () {
    for (int i=0; i<pat*neighbors; i++) {
      smallDNA[i] = randomJoint();
    }
    pattern2DNA();
  }
  
  void pattern2DNA () {
    for (int i=0; i<num; i++) {
      dna[i] = smallDNA[i%(pat*neighbors)];
    }
  }
  
  void perlinCreate() {
    float xOff = random(10);
    for (int i=0; i<num; i++) {
      float r = noise(xOff);
      if(r>0.4)
        dna[i] = randomJoint();
      xOff+= .005;
    }
  }

  byte randomJoint() {
    float r = random(10000)/100;
    if (r < percentMcos) {
      return(3);
    }
    else if (r<percentMsine+percentMcos)
      return(2);
    else if (r<percentMsine+percentMcos+percentRod)
      return(1);
    else
      return(0);
  }
  
  void calculateFitness(float total) {
     //fitness = displacement/total;
     if(user_like == 1) fitness = 10;
     else if(user_like == 2) fitness = 0;
     else fitness = 1;
  }
  
  void mutate() {
    for (int i=0; i<num; i++) {
      if (random(100)<mutationRate) {
        dna[i] = randomJoint();
      }
    }
  }
  
  void mutatePattern() {
    for (int i=0; i<pat*neighbors; i++) {
      if (random(100)<mutationRate) {
        smallDNA[i] = randomJoint();
      }
    }
    pattern2DNA();
  }
  
  void reduce() {
    for (int i=0; i<num; i++) {
      if (random(100)<reductionRate) {
        dna[i] = 0;
      }
    }
  }
}

DNA crossover_random(DNA parent1, DNA parent2) {
  DNA child = new DNA();
  for (int i=0; i<child.num; i++) {
    if (random(100)<50) 
      child.dna[i] = parent1.dna[i];
    else
      child.dna[i] = parent2.dna[i];
  }
  return child;
}

DNA crossover_pattern(DNA parent1, DNA parent2) {
  DNA child = new DNA();
  for (int i=0; i<child.pat*neighbors; i++) {
    if (random(100)<50) 
      child.smallDNA[i] = parent1.smallDNA[i];
    else
      child.smallDNA[i] = parent2.smallDNA[i];
  }
  child.pattern2DNA();
  return child;
}

DNA crossover_set(DNA parent1, DNA parent2) {
  DNA child = new DNA();
  for (int i=0; i<child.num; i+=gridX * gridY * gridZ) {
    if (random(100)<50) 
      for(int j=i; j<i+gridX * gridY * gridZ; j++)
        child.dna[j] = parent1.dna[j];
    else
      for(int j=i; j<i+gridX * gridY * gridZ; j++)
        child.dna[j] = parent2.dna[j];
  }
  return child;
}


DNA crossover_half(DNA parent1, DNA parent2) {
  DNA child = new DNA();
  int r = int(random(2));
  int i=0;
  if(r == 0) {
    for(i=0; i<child.num/2; i++) {
      child.dna[i] = parent1.dna[i];
    }
    for(; i<child.num; i++) {
      child.dna[i] = parent2.dna[i];
    }
  }
  else {
    for(i=0; i<child.num/2; i++) {
      child.dna[i] = parent2.dna[i];
    }
    for(; i<child.num; i++) {
      child.dna[i] = parent1.dna[i];
    }
  }
  return child;
}
