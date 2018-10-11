class Node {
  int id;
  PVector pos;
  int radius = 1;
  VerletParticle3D particle;
  
  Node() {
  }
  
  Node(int idNode) {
    pos = id2pos(idNode);
    particle = new VerletParticle3D(pos.x, pos.y, pos.z);
    particle.bounds = null;
    physics.addParticle(particle);
    id = idNode;
    if(pos.y<-gridY*spacing+spacing*2)
      particle.lock();
  }
  void update() {
    pos.x = particle.x;
    pos.y = particle.y;
    pos.z = particle.z;
  }
  void display() {
    stroke(0);
    strokeWeight(6);
    point(pos.x, pos.y, pos.z);
  }
}
