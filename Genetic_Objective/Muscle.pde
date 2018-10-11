class Muscle {
  VerletSpring3D muscle;
  float strength = .0001;
  int sourceId, targetId;
  float restFactor = 1.2;
  float maxStrength = .1;
  float  minStrength = .0001;
  boolean sinPhase;
  float k;
  
  Muscle() {
  }
  
  Muscle(Node source, Node target, int type) {
    sourceId = source.id;
    targetId = target.id;
    PVector difference = PVector.sub(source.pos, target.pos);
    int len = int(difference.mag()/restFactor);
    muscle = new VerletSpring3D(source.particle, target.particle, len, strength);
    physics.addSpring(muscle);
    if(type == 2)
      sinPhase = true;
    else
      sinPhase = false;
  }
  
  void update() {
    if(sinPhase == true)
      k = 10000*sin(radians(millis()/muscleFactor-90));
    else
      k = 10000*cos(radians(millis()/muscleFactor));
      
    k = map(k, -10000, 10000, minStrength, maxStrength);
    muscle.setStrength(k);
  }
  
  void display() {
    int c = int(map(k,minStrength, maxStrength, 0.1, 5));
    stroke(0);
    strokeWeight(c);
    line(muscle.a.x, muscle.a.y, muscle.a.z, muscle.b.x, muscle.b.y, muscle.b.z);
  }
}


//  Implements a string which will only enforce its rest length if the current
//  distance is more than its rest length.
 
public class VerletMaxDistanceSpring3D extends VerletSpring3D {

    public VerletMaxDistanceSpring3D(VerletParticle3D a, VerletParticle3D b,
            float len, float str) {
        super(a, b, len, str);
    }

    public void update(boolean applyConstraints) {
        if (b.distanceToSquared(a) > restLengthSquared) {
            super.update(applyConstraints);
        }
    }
}
