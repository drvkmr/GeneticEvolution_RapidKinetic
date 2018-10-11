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
int population = 120;
DNA[] d;
int flock = 60;
int flockX = 6;
int flockY = 10;
int gap = 100;
float[][] qTable;
boolean explore = true;

int timer = 10000;
long lastReset = timer;
int currentFlock;
int generation = 0;

Creature[] c;
int[] displacement;
int gridX = 2;
int gridY = 3;
int gridZ = 2;
int spacing = 20;
int neighbors = 18;

float percentRod = 40;
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
  size(1800, 1000, P3D);
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
  
  qTable = new float[gridX*gridY*gridZ*neighbors][4];
  for(int i=0; i<gridX*gridY*gridZ*neighbors; i++)
    for(int j=0; j<4; j++)
      qTable[i][j] = 0;
  
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
      if(c[i].checkFall() == true)
        displacement[currentBase+i] = 0;
      else
        displacement[currentBase+i] += 1;
        println("Fallen");
      print("Creature = ");
      println(currentBase + i);
      print("Distance Travelled = ");
      if(displacement[currentBase+i] == 0)
        println("Fallen");
      else
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
        for(int j=0; j<d[i].num; j++) {
          qTable[j][d[i].dna[j]] += fitness[i];
        }
      }
      
      for(int i=0; i<gridX*gridY*gridZ*neighbors; i++) {
        for(int j=0; j<4; j++) {
          print(qTable[i][j]);
          print("  ");
        }
        println("");
      }
      
      if(explore) {
        for (int i=0; i<population; i++) {
          d[i] = new DNA();
          d[i].randomCreate();
        }
      }
      else {
        for (int i=0; i<population; i++) {
          d[i] = new DNA();
          for(int j=0; j<d[i].num; j++) {
            d[i].dna[j] = 0;
            float high = 0;
            for(byte k=0; k<4; k++){
              if(qTable[j][k] > high) {
                d[i].dna[j] = k;
                high = qTable[j][k];
              }
            }
          }
        }
      }
      currentFlock = 0;
    }

    resetPhysics();
    for (int i=0; i<flock; i++) {
      c[i] = new Creature();
      c[i].cookFromDNAN(d[i]);
    }
  }

  basicRoutine();
  int k=0;
  for (int i=0; i<flockX; i++) {
    for (int j=0; j<flockY; j++) {
      c[k].update();
      pushMatrix();
      translate((j*-gap + 400), 0, (i*-gap + 300));
      c[k].display();
      popMatrix();
      k++;
    }
  }
}

void basicRoutine() {
  noStroke();
  if(explore == true)
    background(255);
  else
    background(220,220,220);
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
  if (key == 'q')
    explore = !explore;
}
