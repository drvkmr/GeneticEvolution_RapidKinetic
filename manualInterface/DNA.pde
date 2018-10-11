int queue = 0;
class DNA {
  IntList dna;

  DNA() {
    dna = new IntList();
  }

  void saveDNA() {
    Table table = new Table();
    table.addColumn("linkType");
    table.addColumn("origin");
    table.addColumn("target");
    for (int i=0; i<dna.size()-2; i+=3) {
      TableRow newRow = table.addRow();
      newRow.setInt("linkType", dna.get(i));
      newRow.setInt("origin", dna.get(i+1));
      newRow.setInt("target", dna.get(i+2));
    }
    saveTable(table, "dna"+queue+".csv");
    queue++;
  }

  void loadDNA() {
    dna.clear();
    Table table = new Table();
    table = loadTable("dna.csv", "header");
    if (table != null) {
      for (TableRow row : table.rows()) {
        dna.append(row.getInt("linkType"));
        dna.append(row.getInt("origin"));
        dna.append(row.getInt("target"));
      }
    }
  }

  void showDNA() {
    for (int i=0; i<dna.size(); i++) {
      print(dna.get(i));
      print(" ");
      if ((i+1)%3 == 0) println("");
    }
    println("");
  }

  void copyDNA(DNA source) {
    dna.clear();
    for (int i=0; i<source.dna.size(); i++) {
      dna.append(source.dna.get(i));
    }
  }

  void add(int type, int origin, int target) {
    dna.append(type);
    dna.append(origin);
    dna.append(target);
  }

  void deleteLast() {
    dna.remove(dna.size()-1);
    dna.remove(dna.size()-1);
    dna.remove(dna.size()-1);
  }
}

DNA crossOver(DNA partner1, DNA partner2) {
  DNA child;
  child = new DNA();
  boolean linkMade = false;
  for (int i=0; i<cycles*3; i+=3) {/*
    for (int j=0; j<child.dna.size(); j+=3) {
      if ((child.dna.get(j+1) == partner1.dna.get(i+1) && child.dna.get(j+2) == partner1.dna.get(i+2)) || (child.dna.get(j+1) == partner1.dna.get(i+2) && child.dna.get(j+2) == partner1.dna.get(i+1))) {
        linkMade = true;
        child.add(partner2.dna.get(i), partner2.dna.get(i+1), partner2.dna.get(i+2));
      } else if ((child.dna.get(j+1) == partner2.dna.get(i+1) && child.dna.get(j+2) == partner2.dna.get(i+2)) || (child.dna.get(j+1) == partner2.dna.get(i+2) && child.dna.get(j+2) == partner2.dna.get(i+1))) {
        linkMade = true;
        child.add(partner1.dna.get(i), partner1.dna.get(i+1), partner1.dna.get(i+2));
      }
    }*/
    
    
    if (linkMade == false) {
      int r = int(random(100));
      if (r<50) {
        child.add(partner1.dna.get(i), partner1.dna.get(i+1), partner1.dna.get(i+2));
      } else {
        child.add(partner2.dna.get(i), partner2.dna.get(i+1), partner2.dna.get(i+2));
      }
    }
  }
  
  for(int i=0; i<child.dna.size(); i+=3) {
    for(int j=0; j<i; j+=3) {
      if(child.dna.get(i+1) == child.dna.get(j+1) && child.dna.get(i+2) == child.dna.get(j+2)) {
        if(child.dna.get(i+1) == partner1.dna.get(i+1) && child.dna.get(i+2) == partner1.dna.get(i+2)) {
          child.dna.set(i, partner2.dna.get(i));
          child.dna.set(i+1, partner2.dna.get(i+1));
          child.dna.set(i+2, partner2.dna.get(i+2));
        }
        else {
          child.dna.set(i, partner1.dna.get(i));
          child.dna.set(i+1, partner1.dna.get(i+1));
          child.dna.set(i+2, partner1.dna.get(i+2));
        }
        break;
      }
    }
  }
  return child;
}
