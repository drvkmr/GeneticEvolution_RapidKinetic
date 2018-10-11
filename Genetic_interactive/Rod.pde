class Rod {
  VerletSpring3D rod;
  float strength = 1;
  int sourceId, targetId;

  Rod() {
  }
  Rod(Node source, Node target) {
    sourceId = source.id;
    targetId = target.id;
    PVector difference = PVector.sub(source.pos, target.pos);
    int len = int(difference.mag());
    rod = new VerletSpring3D(source.particle, target.particle, len, strength);
    physics.addSpring(rod);
  }

  void update() {
  }

  void display() {
    stroke(0, 150);
    strokeWeight(1);
    line(rod.a.x, rod.a.y, rod.a.z, rod.b.x, rod.b.y, rod.b.z);
  }
}
