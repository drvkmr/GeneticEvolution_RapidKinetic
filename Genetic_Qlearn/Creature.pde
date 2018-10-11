class Creature {
  ArrayList<Node> nodes;
  ArrayList<Rod> rods;
  ArrayList<Muscle> muscles;
  PVector origin;
  PVector start;
  PVector travel;
  int displacement;

  Creature(PVector o) {
    nodes = new ArrayList();
    rods = new ArrayList();
    muscles = new ArrayList();
    origin = o.copy();
    start = new PVector(0,0,0);
    travel = new PVector(0,0,0);
    displacement = 0;
  }
  
  Creature() {
    nodes = new ArrayList();
    rods = new ArrayList();
    muscles = new ArrayList();
    origin = new PVector(0,0,0);
    start = new PVector(0,0,0);
    travel = new PVector(0,0,0);
    displacement = 0;
  }
  
  PVector getCenter() {
    PVector center = new PVector(0,0,0);
    for(int i=0; i<nodes.size(); i++) {
      center.add(nodes.get(i).pos);
    }
    center.div(nodes.size());
    return center;
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
  }
  
  void cookFromDNAN(DNA d) {
    int t = 0;
    for (int i=0; i<gridX; i++) {
      for (int j=0; j<gridY; j++) {
        for (int k=0; k<gridZ; k++) {
          int sourceId = i + j*100 + k*10000;
          //println(sourceId);
          IntList n = getNeighbors(sourceId);
          for (int m=0; m<n.size(); m++) {
            int linkType = d.dna[t];
            if(n.get(m) != -1) {
              makeLink(sourceId, n.get(m), linkType);
            }
            t++;
          }
        }
      }
    }
    start = getCenter().copy();
  }
  
  void cookFromDNA(DNA d) {
    int t = 0;
    for (int i=0; i<gridX; i++) {
      for (int j=0; j<gridY; j++) {
        for (int k=0; k<gridZ; k++) {
          int sourceId = i + j*100 + k*10000;
          //println(sourceId);
          IntList n = g.points;
          for (int m=0; m<n.size(); m++) {
            int linkType = d.dna[t];
            if(n.get(m) != -1) {
              if(sourceId != n.get(m))
                makeLink(sourceId, n.get(m), linkType);
            }
            t++;
          }
        }
      }
    }
    start = getCenter().copy();
  }
  
  boolean checkFall() {
    if(abs(getCenter().y)<spacing*gridY/5)
      return true;
    else
      return false;
  }

  boolean makeLink(int sourceId, int targetId, int type) {
    // first, check if the source and target nodes exist already
    boolean newSource = true;
    boolean newTarget = true;
    Node source = new Node(sourceId);
    Node target = new Node(targetId);
    for (int i=0; i<nodes.size(); i++) {
      if (nodes.get(i).id == sourceId) {
        source = nodes.get(i);
        newSource = false;
      }
      if (nodes.get(i).id == targetId) {
        target = nodes.get(i);
        newTarget = false;
      }
    }
    
    // if both exists, check if any link exists already
    if (newSource == false && newTarget == false) {
      for (Rod r : rods) {
        if ((r.sourceId == sourceId && r.targetId == targetId) || (r.sourceId == targetId && r.targetId == sourceId)) {
          return false;
        }
      }
      for (Muscle m : muscles) {
        if ((m.sourceId == sourceId && m.targetId == targetId) || (m.sourceId == targetId && m.targetId == sourceId)) {
          return false;
        }
      }
    }
    
    //make the nodes(if they don't exist already)
    if(newSource == true) nodes.add(source);
    if(newTarget == true) nodes.add(target);
    
    //finally, make the link
    if(type == 0){}
    else if (type == 1) {
      Rod r = new Rod(source, target);
      rods.add(r);
    } else {
      Muscle m = new Muscle(source, target, type);
      muscles.add(m);
    }
    return true;
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
    travel = getCenter().copy();
  }
  
  int getDisplacement() {
    int dis = int(travel.sub(start).x);
    if(dis<0) dis = 0;
    return(dis);
  }
  void display() {
    pushMatrix();
    translate(origin.x, origin.y, origin.z);
    for (Node n : nodes) {
      n.display();
    }
    for (Rod r : rods) {
      r.display();
    }
    for (Muscle m : muscles) {
      m.display();
    }
    popMatrix();
  }
}
