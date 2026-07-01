class Hill {
  float x, y;
  float alpha;

  int fadeDirection = 0;
  int dry;

  color lGreen;
  color lmGreen;
  color dGreen;
  color dlGreen;

  boolean dead;

  Hill(int dry, float startAlpha) {
    this.dry = dry;
    alpha = startAlpha;
    x = width/2;
    y = height/2;
    dead = false;
  }

  void updateAlpha() {
    alpha += fadeDirection * 0.9;
    alpha = constrain(alpha, 0, 255);

    if (alpha == 0 || alpha == 255) {
      fadeDirection = 0;
    }
    if (alpha >= 200) {
      dead = true;
    } else {
      dead = false;
    }
  }

  void updateColors() {
    if (dry == 0) {
      lGreen  = color(54, 232, 82, alpha);
      lmGreen = color(103, 203, 127, alpha);
      dGreen  = color(18, 100, 38, alpha);
      dlGreen = color(42, 129, 63, alpha);
    } else if (dry == 1) {
      lGreen  = color(232, 197, 56, alpha);
      lmGreen = color(201, 174, 103, alpha);
      dGreen  = color(98, 73, 18, alpha);
      dlGreen = color(129, 82, 43, alpha);
    } else if (dry == 2) {
      lGreen  = color(255);
      lmGreen = color(225);
      dGreen  = color(255);
      dlGreen = color(255);
    }
  }

  void update () {
    noStroke();
    fill (lGreen);
    beginShape();//rigth hill
    //river side
    vertex (x+width/2, y+395);
    vertex (x+500, y+330);
    vertex (x+270, y+280);
    vertex (x+160, y+240);

    vertex (x+130, y+210);
    vertex (x+128, y+200);
    vertex (x+127, y+185);

    vertex (x+130, y+170);
    vertex (x+120, y+140);
    vertex (x+100, y+120);
    vertex (x+60, y+80);
    vertex (x, y+50);
    vertex (x-70, y+20);
    vertex (x-200, y-10);
    vertex (x-365, y-38);
    //top part
    vertex (x-410, y-75);
    vertex (x, y-140);
    vertex (x+100, y-130);
    vertex (x+150, y-110);
    vertex (x+280, y-70);
    vertex (x+300, y-80);
    vertex (x+340, y-85);
    vertex (x+400, y-95);
    vertex (x+500, y-100);
    vertex (x+550, y-102);
    vertex (x+570, y-110);
    vertex (x+600, y-130);
    vertex (x+630, y-145);
    vertex (x+660, y-155);
    vertex (x+750, y-153);
    vertex (x+820, y-150);
    vertex (x+895, y-155);
    vertex (x+width/2, y-160);
    endShape();


    fill(dlGreen, 180);
    beginShape();//shadow rigth hill leftest part
    //top part
    vertex (x-410, y-75);
    vertex (x-300, y-90);
    vertex (x, y-140);
    vertex (x+100, y-130);
    vertex (x+150, y-110);
    //connection darker shadow
    vertex (x+258, y-75);
    vertex (x+170, y-70);
    vertex (x+23, y-20);
    //connection to mud
    vertex (x-36, y+5);
    vertex (x-70, y-5);
    vertex (x-200, y-24);
    vertex (x-359, y-40);
    endShape();

    fill(lmGreen);
    beginShape();//top part second hill
    //connection to top
    vertex (x+300, y-80);
    vertex (x+340, y-85);
    vertex (x+400, y-95);
    vertex (x+500, y-100);
    vertex (x+550, y-102);
    //connection to shadow
    vertex (x+372, y+8);
    vertex (x+370, y-10);
    vertex (x+340, y-65);
    endShape();

    fill(dlGreen);
    beginShape();//shadow right side hill two
    //top part
    vertex (x+20, y-20);
    vertex (x+170, y-70);
    vertex (x+300, y-80);
    //middle
    vertex (x+340, y-65);
    vertex (x+370, y-10);
    vertex (x+375, y+3);
    //connection to mud
    vertex (x+300.5, y+50);
    vertex (x+127.5, y+200);
    vertex (x+127, y+185);
    vertex (x+130, y+170);
    vertex (x+120, y+140);
    vertex (x+100, y+120);
    vertex (x+60, y+80);
    vertex (x, y+50);
    vertex (x-70, y+20);
    endShape();


    fill(dlGreen);
    beginShape();//rigth side, right most hill
    //hill top
    vertex (x+150, y+180);
    vertex (x+300, y+50);
    vertex (x+490, y-70);
    vertex (x+520, y-90);
    vertex (x+550, y-100);
    vertex (x+570, y-110);
    vertex (x+600, y-130);
    vertex (x+630, y-145);
    vertex (x+660, y-155);
    vertex (x+750, y-125);
    //edges
    vertex (x+width/2, y+30);
    vertex (x+width/2, y+390);
    vertex (x+800, y+415);
    vertex (x+700, y+395);
    vertex (x+500, y+350);
    vertex (x+400, y+325);
    vertex (x+270, y+280);
    vertex (x+160, y+240);
    endShape();


    beginShape(); //shadow by mud border
    //connection to mud
    vertex (x-342, y-31);
    vertex (x-200, y-14);
    vertex (x-65, y+18);
    //connection to grass
    vertex (x-36, y+5);
    vertex (x-70, y-5);
    vertex (x-200, y-24);
    vertex (x-359, y-40);
    endShape();


    fill (lGreen);
    beginShape(); //left hill
    //top part
    vertex (x-width/2, y-155);
    vertex (x-900, y-165);
    vertex (x-850, y-170);
    vertex (x-800, y-160);
    vertex (x-750, y-150);
    vertex (x-700, y-140);
    vertex (x-650, y-120);
    vertex (x-580, y-110);
    vertex (x-500, y-105);
    vertex (x-470, y-95);
    vertex (x-430, y-85);
    vertex (x-400, y-70);
    vertex (x-360, y-40);
    vertex (x-330, y-25);

    //start river part
    vertex (x-300, y-10);
    vertex (x-200, y+10);
    vertex (x-170, y+30);
    vertex (x-150, y+50);
    vertex (x-80, y+100);
    vertex (x-60, y+140);

    vertex (x-70, y+160);
    vertex (x-80, y+175);
    vertex (x-120, y+210);
    vertex (x-140, y+250);
    vertex (x-130, y+300);
    vertex (x-100, y+350);

    vertex (x-30, y+400);
    vertex (x+40, y+450);
    vertex (x+270, y+550);
    vertex (x+450, y+height/2);
    vertex (x-width/2, y+height/2);
    endShape();

    fill(dlGreen);
    beginShape(); //drak shadow left side middle peak
    //top part
    vertex (x-580, y-110);
    vertex (x-540, y-108);
    //right side
    vertex (x-550, y-90);
    vertex (x-580, y-30);
    vertex (x-590, y+10);
    vertex (x-600, y+60);
    //bootom part
    vertex (x-500, y+286);
    vertex (x-595, y+223);
    //left side
    vertex (x-750.5, y+152);
    vertex (x-667, y+90);
    vertex (x-650, y-30);
    endShape();


    beginShape();//dark shadow left hill leftest peak
    //top part
    vertex (x-width/2, y-155);
    vertex (x-900, y-165);
    vertex (x-850, y-170);
    //right side
    vertex (x-820, y-100);
    vertex (x-810, y-40);
    vertex (x-790, y);
    vertex (x-740, y+60);
    //connection to bottom
    vertex (x-670, y+92);
    vertex (x-750, y+152);
    vertex (x-600, y+220);
    vertex (x-width/2, y+200);
    endShape();


    fill(dGreen);
    beginShape(); //dark block foreground left side
    vertex (x-width/2, y+height/2);
    vertex (x-60, y+height/2);
    vertex (x-250, y+450);
    vertex (x-600, y+220);
    vertex (x-width/2, y+200);
    endShape();


    fill (#92986F);
    beginShape(); //mud left water side
    //river side
    vertex (x-75, y+110);
    vertex (x-60, y+120);

    vertex (x-45, y+134);
    vertex (x-50, y+160);
    vertex (x-70, y+190);
    vertex (x-115, y+220);
    vertex (x-135, y+250);
    vertex (x-130, y+300);
    vertex (x-100, y+350);

    vertex (x-30, y+400);
    vertex (x+40, y+450);
    vertex (x+270, y+550);
    vertex (x+450, y+height/2);
    //outer part
    vertex (x+410, y+height/2);
    vertex (x+230, y+550);
    vertex (x+20, y+450);
    vertex (x-50, y+400);

    vertex (x-120, y+350);
    vertex (x-150, y+300);
    vertex (x-160, y+230);
    vertex (x-130, y+180);
    vertex (x-90, y+135);
    endShape();

    fill (#92986F);
    beginShape(); //mud rigth water side
    //river side
    vertex (x+width/2, y+440);
    vertex (x+800, y+415);
    vertex (x+680, y+395);
    vertex (x+500, y+350);
    vertex (x+380, y+325);
    vertex (x+225, y+280);
    vertex (x+140, y+240);

    vertex (x+120, y+230);
    vertex (x+108, y+220);
    vertex (x+105, y+195);

    vertex (x+108, y+170);
    vertex (x+95, y+140);
    vertex (x+90, y+120);
    vertex (x+55, y+80);
    vertex (x, y+50);
    vertex (x-70, y+20);
    vertex (x-200, y-10);
    vertex (x-337, y-28);

    //outer part
    vertex (x-342, y-31);
    vertex (x-200, y-14);
    vertex (x-70, y+15);
    vertex (x, y+40);
    vertex (x+60, y+70);
    vertex (x+100, y+100);
    vertex (x+120, y+120);
    vertex (x+142, y+150);
    vertex (x+148, y+160);
    vertex (x+150, y+170);
    vertex (x+152, y+180);
    vertex (x+180, y+210);
    vertex (x+270, y+240);
    vertex (x+500, y+305);
    vertex (x+600, y+330);
    vertex (x+800, y+370);
    vertex (x+width/2, y+390);
    endShape();


    fill(dlGreen);
    beginShape(); //shadow by water left side
    vertex (x+410, y+height/2);
    vertex (x+230, y+550);
    vertex (x+20, y+450);
    vertex (x-50, y+400);

    vertex (x-120, y+350);
    vertex (x-150, y+300);
    vertex (x-160, y+230);
    vertex (x-130, y+180);
    vertex (x-90, y+135);

    vertex (x-75, y+110);
    vertex (x-60, y+140);
    vertex (x-80, y+100);
    //top part
    vertex (x-150, y+50);

    vertex (x-180, y+135);
    vertex (x-210, y+180);
    vertex (x-250, y+300);

    vertex (x-240, y+350);
    vertex (x-210, y+400);
    vertex (x-150, y+450);
    vertex (x+100, y+550);
    vertex (x+300, y+height/2);
    endShape();
  }

  void water () {
    noStroke();
    fill (#42B0F2);
    beginShape();
    vertex(0, y-50);
    vertex(width, y-50);
    vertex (width, height);
    vertex (0, height);
    endShape();
  }

  void underWater () {
    noStroke();
    fill(#958F5E);
    beginShape(); //underwater ground right side
    //connection to land
    vertex (x+width/2, y+440);
    vertex (x+800, y+415);
    vertex (x+700, y+395);
    vertex (x+500, y+350);
    vertex (x+400, y+325);
    vertex (x+270, y+280);
    vertex (x+160, y+240);

    vertex (x+130, y+210);
    vertex (x+128, y+200);
    vertex (x+127, y+185);

    vertex (x+130, y+170);
    vertex (x+120, y+140);
    vertex (x+100, y+120);
    vertex (x+60, y+80);
    vertex (x, y+50);
    vertex (x-70, y+20);
    vertex (x-200, y-10);
    vertex (x-330, y-28);

    //connection to deeper section
    //vertex (x-250, y-10);
    vertex (x-140, y+20);
    vertex (x-70, y+50);
    vertex (x-10, y+80);
    vertex (x+30, y+120);
    vertex (x+40, y+140);
    vertex (x+50, y+170);

    vertex (x+47, y+185);
    vertex (x+48, y+200);
    vertex (x+50, y+210);

    vertex (x+60, y+240);
    vertex (x+120, y+300);
    vertex (x+250, y+355);
    vertex (x+350, y+390);
    vertex (x+550, y+450);
    vertex (x+650, y+475);
    vertex (x+830, y+520);
    vertex (x+width/2, y+540);
    endShape();

    beginShape();//underwater ground left part
    //connection to dirt
    vertex (x-75, y+110);
    vertex (x-60, y+140);
    vertex (x-70, y+160);
    vertex (x-80, y+175);
    vertex (x-120, y+210);
    vertex (x-140, y+250);
    vertex (x-130, y+300);
    vertex (x-100, y+350);
    vertex (x-30, y+400);
    vertex (x+40, y+450);
    vertex (x+270, y+550);
    vertex (x+450, y+height/2);
    //connection to middle
    vertex (x+width/2, y+height/2);
    vertex (x+590, y+height/2);
    vertex (x+350, y+525);
    vertex (x+135, y+450);
    vertex (x+60, y+400);
    vertex (x-10, y+350);
    vertex (x-60, y+300);
    vertex (x-70, y+250);
    vertex (x-50, y+210);
    vertex (x-35, y+175);
    vertex (x-35, y+160);
    vertex (x-40, y+140);
    vertex (x-70, y+110);
    endShape();

    fill(#897B67);
    beginShape();//underwater ground middle part
    //connection to right side
    vertex (x-250, y-10);
    vertex (x-140, y+20);
    vertex (x-70, y+50);
    vertex (x-10, y+80);
    vertex (x+30, y+120);
    vertex (x+40, y+140);
    vertex (x+50, y+170);
    vertex (x+60, y+240);
    vertex (x+120, y+300);
    vertex (x+250, y+355);
    vertex (x+350, y+390);
    vertex (x+550, y+450);
    vertex (x+650, y+475);
    vertex (x+830, y+520);
    vertex (x+width/2, y+540);
    //connection to left side
    vertex (x+width/2, y+height/2);
    vertex (x+590, y+height/2);
    vertex (x+350, y+525);
    vertex (x+135, y+450);
    vertex (x+60, y+400);
    vertex (x-10, y+350);
    vertex (x-60, y+300);
    vertex (x-70, y+250);
    vertex (x-50, y+210);
    vertex (x-35, y+175);
    vertex (x-35, y+160);
    vertex (x-40, y+140);
    vertex (x-70, y+114);
    vertex (x-78, y+107);
    vertex (x-83, y+98);
    vertex (x-147, y+55);
    vertex (x-170, y+30);
    vertex (x-200, y+12);
    vertex (x-295, y-8);
    vertex (x-350, y-35);
    endShape();
    //internet, table, power usage, chairs, power plugs
  }
}
