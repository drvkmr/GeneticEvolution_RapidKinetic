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
int population = 600;
DNA[] d;
int flock = 30;
int flockX = 6;
int flockY = 5;
int gapX = 300;
int gapZ = 150;

int timer = 10000;
long lastReset = timer;
int currentFlock;
int generation = 0;

Creature[] c;
int[] displacement;
int gridX = 8;
int gridY = 2;
int gridZ = 2;
int spacing = 20;
int neighbors = 18;

float percentRod = 35;
float percentMsine = 5;
float percentMcos = percentMsine;
byte mutationRate = 5;

int muscleFactor = 5;
boolean keyFall = false;

IntList roundDist;
IntList totalDist;
IntList maxDist;
IntList minDist;
Table data;

void setup() {
  size(1900, 1060, P3D);
  cam = new PeasyCam (this, 30, -50, 0, 200);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2000);
  cam.setSuppressRollRotationMode();
  resetPhysics();

  maxDist = new IntList();
  minDist = new IntList();
  roundDist = new IntList();
  data = new Table();
  data.addColumn("Generation");
  data.addColumn("Max Distance");
  data.addColumn("Min Distance");
  data.addColumn("Total Distance");

  g = new Grid();
  displacement = new int[population];
  d = new DNA[population];
  for (int i=0; i<population; i++) {
    d[i] = new DNA();
    d[i].randomCreate();
  }
  c = new Creature[flock];
  for (int i=0; i<flock; i++) {
    c[i] = new Creature();
    c[i].cookFromDNAN(d[i]);
  }
  currentFlock = 0;
}


void draw() {
  if (millis() - lastReset > timer) {
    int currentBase = currentFlock*flock;
    println(currentBase);
    lastReset = millis();
    for (int i=0; i<flock; i++) {
      displacement[currentBase + i] = c[i].getDisplacement();
      print("Creature = ");
      println(currentBase + i);
      print("Distance Travelled = ");
      println(displacement[currentBase + i]);
      roundDist.append(int(displacement[currentBase + i]));
    }

    currentFlock++;
    currentBase = currentFlock*flock;
    
    if (currentBase >= population) {
      updateData();
      generation++;
      println("Generation = " + generation);
      float totalDistance = 0;
      for (int i=0; i<population; i++) {
        totalDistance += displacement[i];
      }
      float[] fitness = new float[population];
      for (int i=0; i<population; i++) {
        fitness[i] = 100*displacement[i]/totalDistance;
      }
      ArrayList<DNA> matingPool = new ArrayList<DNA>();
      for (int i=0; i<population; i++) {
        for (int j=0; j<fitness[i]*10; j++) {
          matingPool.add(d[i]);
        }
      }

      for (int i=0; i<population; i++) {
        DNA parent1 = matingPool.get(int(random(matingPool.size())));
        DNA parent2 = matingPool.get(int(random(matingPool.size())));
        d[i] = crossover_random(parent1, parent2);
        d[i].mutate();
      }
      currentFlock = 0;
      currentBase = 0;
    }

    resetPhysics();
    for (int i=0; i<flock; i++) {
      c[i] = new Creature();
      c[i].cookFromDNAN(d[currentBase+i]);
    }
  }

  basicRoutine();
  int k=0;
  for (int i=0; i<flockX; i++) {
    for (int j=0; j<flockY; j++) {
      c[k].update();
      pushMatrix();
      translate((j*-gapX + 500), 0, (i*-gapZ + 300));
      c[k].display();
      popMatrix();
      k++;
    }
  }
}

void basicRoutine() {
  noStroke();
  background(255);
  noStroke();
  fill(255, 100);
  physics.update();
  lights();
  tex();
  VerletPhysics3D.addConstraintToAll(ground, physics.particles);
}

void resetPhysics() {
  gfx = new ToxiclibsSupport(this);
  ground=new BoxConstraint(new AABB(new Vec3D(0, baseHeight, 0), new Vec3D(baseSize, 10, baseSize)));
  ground.setRestitution(0);
  physics=new VerletPhysics3D();
  physics.addBehavior(new GravityBehavior3D(new Vec3D(0, 0.1, 0)));
}

void updateData() {
  int totalDistance = 0;
  int maxDistance = 0;
  int minDistance = 10000;
  for (int i=0; i<roundDist.size(); i++) {
    int d = roundDist.get(i);
    totalDistance += d;
    if (d > maxDistance) maxDistance = d;
    if (d < minDistance) minDistance = d;
  }
  TableRow newRow = data.addRow();
  newRow.setInt("Generation", generation);
  newRow.setInt("Max Distance", maxDistance);
  newRow.setInt("Min Distance", minDistance);
  newRow.setInt("Total Distance", totalDistance);
  saveTable(data, "data.csv");
}
void keyPressed() {
  if (key == 'x')
    keyFall = true;
}
