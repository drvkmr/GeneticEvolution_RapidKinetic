class Creature {
  int proportionRod = 50;
  ArrayList<Node> nodes;
  ArrayList<Rod> rods;
  ArrayList<Muscle> muscles;
  DNA dna;
  
  Creature() {
    nodes = new ArrayList();
    rods = new ArrayList();
    muscles = new ArrayList();
    dna = new DNA();
  }
  
  void clear() {
    for (int i = nodes.size() - 1; i >= 0; i--) {
      nodes.remove(i);
    }
    for (int i = rods.size() - 1; i >= 0; i--) {
      rods.remove(i);
    }
    for (int i = nodes.size() - 1; i >= 0; i--) {
      muscles.remove(i);
    }
    dna.dna.clear();
  }
  
  //picks a random node and a random neighbor, builds a link between them
  void born() {
    clear();
    
    
    
    
    PVector source = new PVector(int(gridX/2), -int(gridY/2), int(gridZ/2));
    source.mult(spacing);
    int sourceId = pos2id(source);
    IntList neighbors = getNeighbors(sourceId);
    int luckyNeighbor = neighbors.get(int(random(neighbors.size())));
    Node s = new Node(sourceId);
    Node t = new Node(luckyNeighbor);
    nodes.add(s);
    nodes.add(t);
    Rod r = new Rod(s, t);
    rods.add(r);

    neighbors = getNeighbors(sourceId);
    luckyNeighbor = neighbors.get(int(random(neighbors.size())));
    s = new Node(sourceId);
    t = new Node(luckyNeighbor);
    nodes.add(s);
    nodes.add(t);
    r = new Rod(s, t);
    rods.add(r);
    dna.add(0, sourceId, luckyNeighbor);
  }
  void cookRandom(int steps) {
    for (int i=1; i<steps; i++) {
      boolean linkMade = false;
      while(linkMade == false) {
        int sourceNode = int(random(nodes.size()));
        int s = nodes.get(sourceNode).id;
        IntList neighbors = getNeighbors(s);
        int luckyNeighbor = neighbors.get(int(random(neighbors.size())));
        int per = int(random(100));
        int linkType = 0;
        if(per < cR)
          linkType = 0;
        else if(per < cR+cM1)
          linkType = 1;
        else
          linkType = 2;
        linkMade = makeLink(s, luckyNeighbor, linkType);
        if(linkMade == true) {
          dna.add(linkType, s, luckyNeighbor);
        }
      }
    }
  }
  void cookFromDNA(DNA d) {
    clear();
    dna.copyDNA(d);
    for(int i=0; i<dna.dna.size()-2; i+=3) {
      int linkType = dna.dna.get(i);
      int sourceId = dna.dna.get(i+1);
      int targetId = dna.dna.get(i+2);
      IntList n = getNeighbors(sourceId);
      makeLink(sourceId, targetId, linkType);
    }
  }
  //EVERY NODE MUST BE CONNECTED TO ATLEAST 3 NEIGHBORS
  void taster() {
    
  }

  void update() {
    for (Node n : nodes) {
      n.update();
    }
    for (Rod r : rods) {
      r.update();
    }
    for (Muscle m : muscles) {
      m.update();
    }
  }

  void display() {
    for (Node n : nodes) {
      n.display();
    }
    for (Rod r : rods) {
      r.display();
    }
    for (Muscle m : muscles) {
      m.display();
    }
  }
  
  boolean makeLink(int sourceId, int targetId, int type) {
    //first of all, check for duplication links
    for(Rod r: rods) {
      if((r.sourceId == sourceId && r.targetId == targetId) || (r.sourceId == targetId && r.targetId == sourceId)) {
        return false;
      }
    }
    for(Muscle m: muscles) {
      if((m.sourceId == sourceId && m.targetId == targetId) || (m.sourceId == targetId && m.targetId == sourceId)) {
        return false;
      }
    }
    //second, track the number of source node
    int sourceNum = 0;
    for(int i=0; i<nodes.size(); i++) {
      if(nodes.get(i).id == sourceId) {
        sourceNum = i;
        break;
      }
    }
    //so how does this work?
    //a check needs to be done, for both existing nodes at source and target locations
    //declare the two nodes
    //check for existing nodes at given ids, one by one
    //if a node already exists, initialise them as the declared nodes
    //otherwise make new nodes at the location, and initialise them as such
    //then make the link
    
    Node source = new Node(sourceId);
    Node target = new Node(targetId);
    boolean makeNewSource = true;
    boolean makeNewTarget = true;
    for(int i=0; i<nodes.size(); i++) {
      if(sourceId == nodes.get(i).id) {
        source = nodes.get(i);
        makeNewSource = false;
      }
      else if(targetId == nodes.get(i).id) {
        target = nodes. get(i);
        makeNewTarget = false;
      }
    }
    if(makeNewSource == true) nodes.add(source);
    if(makeNewTarget == true) nodes.add(target);
    
    if(type == 0) {
        Rod r = new Rod(source, target);
        rods.add(r);
    }
    else {
        Muscle m = new Muscle(source, target, type);
        muscles.add(m);
    }
    
    /*
    //after that, check weather a node at target already exists or not
    boolean alreadyExistingTarget = false;
    int targetNum = 0;
    for(int j=0; j<nodes.size(); j++) {
      if(targetId == nodes.get(j).id) {
        alreadyExistingTarget = true;
        targetNum = j;
        break;
      }
    }
    
    
    
    
    //then make the link
    if(alreadyExistingTarget == false) {
      Node target = new Node(targetId);
      nodes.add(target);
      if(type == 0) {
        Rod r = new Rod(nodes.get(sourceNum), target);
        rods.add(r);
      }
      else {
        Muscle m = new Muscle(nodes.get(sourceNum), target, type);
        muscles.add(m);
      }
    }
    else {
      if(type == 0) {
        Rod r = new Rod(nodes.get(sourceNum), nodes.get(targetNum));
        rods.add(r);
      }
      else {
        Muscle m = new Muscle(nodes.get(sourceNum), nodes.get(targetNum), type);
        muscles.add(m);
      }
    }*/
    return true;
  }

  boolean checkExisting(Node n1, Node n2) {
    boolean b = false;
    int id1 = n1.id;
    int id2 = n2.id;
    for (Rod r : rods) {
      if ((r.sourceId == id1 && r.targetId == id2) || (r.sourceId == id2 && r.sourceId == id1)) {
        b = true;
        break;
      }
    }
    return b;
  }
}
