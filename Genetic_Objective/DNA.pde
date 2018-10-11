class DNA {
  byte[] dna;
  int num;

  //JOINT TYPES = 0(none), 1(rod), 2(sine), 3(cos)
  DNA() {
    //num = gridX*gridY*gridZ*gridX*gridY*gridZ;
    num = gridX*gridY*gridZ*neighbors;
    dna = new byte[num];
    for (int i=0; i<num; i++)
      dna[i] = 0;
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

  void mutate() {
    for (int i=0; i<num; i++) {
      if (random(100)<mutationRate) {
        dna[i] = randomJoint();
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

DNA crossover_set(DNA parent1, DNA parent2) {
  DNA child = new DNA();
  for (int i=0; i<child.num; i += neighbors) {
    if (random(100)<50) 
      for(int j=i; j<i+neighbors; j++)
        child.dna[j] = parent1.dna[j];
    else
      for(int j=i; j<i+neighbors; j++)
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
