import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.math.*;
import toxi.physics3d.*;
import toxi.physics3d.behaviors.*;
import toxi.physics3d.constraints.*;
import toxi.processing.*;
import peasy.*;
import processing.serial.*;
import cc.arduino.*;
import java.util.Iterator;

PeasyCam cam;

VerletPhysics3D physics;
ToxiclibsSupport gfx;
BoxConstraint ground;

Grid g;
int gridX = 4;
int gridY = 3;
int gridZ = 4;
int spacing = 20;

int cycles = 150;

int cR = 90;
int cM1 = 5;
int cM2 = 5;

Creature c;

DNA[] population;
float[] displacement;
int rounds = 20;
PVector start;
int startId;


long timer = 1000;
long lastReset= timer;

int currentCreature = 0;
long loop = 0;

int baseSize = 1000;
int baseHeight = 10;
boolean simulate = true;

void setup() {
  size(900, 600, P3D);
  //fullScreen(P3D, 2);
  cam = new PeasyCam (this, 30, -50, 0, 200);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2000);
  cam.setSuppressRollRotationMode();

  population = new DNA[rounds];
  displacement = new float[rounds];
  resetPhysics();
  for (int i=0; i<rounds; i++) {
    g = new Grid();
    c = new Creature();
    c.born();
    c.cookRandom(cycles);
    population[i] = new DNA();
    population[i].copyDNA(c.dna);
  }
  
  start = new PVector(int(gridX/2), -int(gridY/2), int(gridZ/2));
  start.mult(spacing);
  startId = pos2id(start);
  
  c = new Creature();
  c.born();
  c.cookFromDNA(population[0]);
  
}

void resetPhysics() {
  gfx = new ToxiclibsSupport(this);
  ground=new BoxConstraint(new AABB(new Vec3D(0, baseHeight, 0), new Vec3D(baseSize, 10, baseSize)));
  ground.setRestitution(0);
  physics=new VerletPhysics3D();
  physics.addBehavior(new GravityBehavior3D(new Vec3D(0, 0.1, 0)));
}

void draw() {
  basicRoutine();
  
  c.update();
  c.display();
  

  if (millis() - lastReset > timer) {
    lastReset = millis();
    PVector travel = c.nodes.get(0).pos;
    PVector difference = PVector.sub(travel, start);
    displacement[currentCreature] = difference.mag();
    if(displacement[currentCreature]>200) displacement[currentCreature] = 0;
    population[currentCreature] = new DNA();
    population[currentCreature].copyDNA(c.dna);
    println("Distance Travelled = " +displacement[currentCreature]);
    currentCreature++;
    
    if(currentCreature >= rounds) {
      population = reproduction(population, displacement);
      currentCreature = 0;
      println("NEW GENERATION");
    }
    
    resetPhysics();
    c = new Creature();
    c.cookFromDNA(population[currentCreature]);
    println("Creature = " + currentCreature);
  }
}

DNA[] reproduction(DNA[] pop, float[] dis) {
  //SCALE FITNESS TO 100
  int totalDisplacement = 0;
  float[] fitness;
  fitness = new float[rounds];
  for(int i=0; i<rounds; i++) {
    totalDisplacement += dis[i];
  }
  for(int i=0; i<rounds; i++) {
    fitness[i] = 100*dis[i]/totalDisplacement;
  }
  ArrayList<DNA> matingPool = new ArrayList<DNA>();
  for(int i=0; i<rounds; i++) {
    for(int j=0; j<int(fitness[i]*10); j++) {
      matingPool.add(pop[i]);
    }
  }
  
  DNA[] children = new DNA[rounds];
  for(int i=0; i<rounds; i++) {
    DNA parent1 = matingPool.get(int(random(matingPool.size())));
    DNA parent2 = matingPool.get(int(random(matingPool.size())));
    children[i] = crossOver(parent1, parent2);
  }
  return children;
}


void basicRoutine() {
  noStroke();
  background(255);
  noStroke();
  fill(255, 100);
  if (simulate)
    physics.update();
  lights();
  tex();
  VerletPhysics3D.addConstraintToAll(ground, physics.particles);
}

void keyPressed() {
  if (key == 'p') {
    simulate = !simulate;
    println("Simulation = " + simulate);
  }
  if (key == 'r') {
    //reset();
  }
  if(key == 's') {
    c.dna.saveDNA();
  }
}
