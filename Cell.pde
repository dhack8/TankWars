class Cell {
  PImage bombImg;
  int x, y; //Position based on index
  int xIndex, yIndex; //Index
  int widthC;
  Wall left, right, top, bottom;
  Cell leftC, rightC, topC, bottomC;
  Weapon crate;
  Cell(int ix, int iy, int left, int top, int cellWidth) {
    widthC = cellWidth;
    xIndex = ix;
    yIndex = iy;
    x = left+(widthC*ix);
    y = top+(widthC*iy);
  }
  
  int getCenterX(){
    return x + widthC/2;
  } 
  int getCenterY(){
    return y + widthC/2;
  }

  void drawCell() { //Draws cell, mainly walls
    if (left!=null)left.drawWall();
    if (right!=null)right.drawWall();
    if (top!=null)top.drawWall();
    if (bottom!=null)bottom.drawWall();
    if(crate != null) crate.drawCrate(x + widthC/4, y + widthC/4, widthC); //and a crate
  }

  void setWalls(boolean l, boolean r, boolean t, boolean b) { //can give cell any new walls
    if (l) left = new Wall(true, x-2, y-2);
    if (r) right = new Wall(true, x+widthC-2, y-2);
    if (t) top = new Wall(false, x-2, y-2);
    if (b) bottom = new Wall(false, x-2, y+widthC-2);
  }

  void setRight(Cell c) { //More robust way of adding cells to avoid duplicates used by the maze
    if (c.left == null) {
      Wall insert = new Wall(true, x+widthC-2, y-2);
      right = insert;
      c.left = insert;
    } else {
      right = c.left;
    }
  }

  void setBottom(Cell c) { //More robust way of adding cells to avoid duplicates used by the maze
    if (c.top == null) {
      Wall insert = new Wall(false, x-2, y+widthC-2);
      bottom = insert;
      c.top = insert;
    } else {
      bottom = c.top;
    }
  }

  void deleteTop(Cell c) { //Deletes the horizontal wall between two cells
    top = null;
    c.bottom = null;
  }

  void deleteLeft(Cell c) { //Deletes the vertical wall between two cells
    left = null;
    c.right = null;
  }

  HashSet<Wall> getWalls() { //Returns a set of all the walls this cell has
    HashSet<Wall> returned = new HashSet<Wall>();
    if (left!=null) returned.add(left);
    if (right!=null) returned.add(right);
    if (top!=null) returned.add(top);
    if (bottom!=null) returned.add(bottom);
    return returned;
  }
  
  HashSet<Wall> getAllWalls() { //Returns a set of all the walls this cell has and its neighbours
    HashSet<Wall> returned = new HashSet<Wall>();
    if (leftC!=null) returned.addAll(leftC.getWalls());
    if (rightC!=null) returned.addAll(rightC.getWalls());
    if (topC!=null) returned.addAll(topC.getWalls());
    if (bottomC!=null) returned.addAll(bottomC.getWalls());
    returned.addAll(this.getWalls());
    return returned;
  }
}