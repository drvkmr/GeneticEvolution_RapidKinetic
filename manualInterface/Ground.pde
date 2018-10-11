class BoxConstraint implements ParticleConstraint3D {

  protected AABB box;
  protected Ray3D intersectRay;
  protected float restitution = 1;

  BoxConstraint(AABB box) {
    this.box = box.copy();
    this.intersectRay = new Ray3D(box, new Vec3D());
  }

  void apply(VerletParticle3D p) {
    if (p.isInAABB(box)) {
      Vec3D dir = p.getVelocity();
      Vec3D prev = p.getPreviousPosition();
      intersectRay.set(prev);
      intersectRay.setDirection(dir);
      Vec3D isec = box.intersectsRay(intersectRay, 0, Float.MAX_VALUE);
      if (isec != null) {
        isec.addSelf(box.getNormalForPoint(isec).scaleSelf(0.01f));
        p.setPreviousPosition(isec);
        p.set(isec.sub(dir.scaleSelf(restitution)));
      }
    }
  }

  AABB getBox() {
    return box.copy();
  }

  float getRestitution() {
    return restitution;
  }

  void setBox(AABB box) {
    this.box = box.copy();
    intersectRay.set(box);
  }

  void setRestitution(float restitution) {
    this.restitution = restitution;
  }
}

void tex() {
  int gridNum = 20;
  int gridSize = baseSize/gridNum;

  noStroke();
  pushMatrix();
  translate(0, 0, 0);
  rotateX(PI/2);
  translate(-baseSize/2, -baseSize/2, 0);
  for (int i=0; i<gridNum; i++) {
    for (int j=0; j<gridNum; j++) {
      if (abs(j-i)%2 == 0) 
        fill(255,10);
      else fill(255,80);
      rectMode(CORNER);
      rect(i*gridSize, j*gridSize, gridSize, gridSize);
    }
  }
  popMatrix();
}
