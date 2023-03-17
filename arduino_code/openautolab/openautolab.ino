#include <LiquidCrystal_I2C.h>
#include <Servo.h>
#include <HX711.h>

//pin numbers
const byte motorplus =5; //positive pole of pump motor
const byte motorminus=6; //negative pole of pump motor
const byte valve1=11; //pins
const byte valve2=12; //of
const byte valve3=10; //valves
const byte valve4=9;
const byte valve5=7;
const byte valve6=8;
const byte servo=4; //servo pin
const byte scaleclk=2; //pins of
const byte scaledat=3; //scale
const byte buzzer=13; //buzzer pin
const byte displayclk=A4; //pins of
const byte displaydio=A5; //display
const byte button1=A0; //buttons
const byte button2=A1;
const byte button3=A2;

//global variables, which store settings
byte bw_dev_time=0;
byte bw_fix_time=0;
byte bw_film_count=0;
byte c41_film_count=0;
byte washes_count=0;
byte washes_duration=0;
byte fotoflo=0;
byte init_agit=0;
byte agit_period=0;
byte agit_duration=0;
byte tank_cap=0;
byte oneshot=0;


//global variables, which store values during work
byte k=0; //state machine state index
volatile unsigned long int t0; // here time of start will is stored
volatile unsigned long int tk; // here time of key press is stored
bool update_display=true;

unsigned long int secs; // here number of seconds on display will be stored
byte dvlpr=0; //developer index
byte container; //pin corresponding to current valve
unsigned long int airpump=10000UL; //number of milliseconds pumping without liquid tolerated
bool error=false; //if something went wrong machine beeps
Servo mixer;
HX711 scale;
LiquidCrystal_I2C lcd(0x27,20,4);
bool keypressed=false;
byte testbyte=0;
void agitation(float a, float b, float c, float d) {
  unsigned long int init=1000.0 * a; //duration of one unit of first agitation, 1sec
  unsigned long int intvl=1000.0 * b; //agitation every unit of time, 1sec
  unsigned long int agit=1000.0 * c; //substequent agitations duration unit, 1sec
  unsigned long int devt=60000.0 * d; //overall development time unit, 1min
  t0=millis();
  while ((millis()-t0)<devt) {
    if (((millis()-t0)%intvl)<agit || (millis()-t0)<init) {
      if (((millis()-t0)%2000UL)<1000UL) mixer.write(180);
      else mixer.write(0);
    }
    secs=(t0+devt-millis())/1000UL;
    //display.showNumberDecEx((secs/60UL)*100UL+(secs%60UL), 0b01000000, false);
  }
}
void keydelay() {
  if(millis()-tk>100) delay (200);
  else delay (50);
  tk=millis();
}
void beep() {
  t0=millis();
  while (1) {
    if((millis()-t0)%1000UL<500UL) digitalWrite(buzzer,HIGH);
    else digitalWrite(buzzer,LOW);
    if(millis()-t0>5000) {digitalWrite(buzzer,LOW); break;} //here be time of beepeng on error
    if(digitalRead(button3)==LOW) {digitalWrite(buzzer,LOW); break;} //here be interrupt beeping and continuing
  }
}

void bip() {
  t0=millis();
  while (1) {
    if((millis()-t0)%500UL<250UL) digitalWrite(buzzer,HIGH);
    else digitalWrite(buzzer,LOW);
    if(millis()-t0>5000) {digitalWrite(buzzer,LOW); break;} //here be time of beepeng on error
    if(digitalRead(button3)==LOW) {digitalWrite(buzzer,LOW); break;} //here be interrupt beeping and continuing
  }
}

void intank(int tank) {
  switch(tank) {
    case 1:
    container=valve1;
    break;
    case 2:
    container=valve2;
    break;
    case 3:
    container=valve3;
    break;
    case 4:
    container=valve4;
    break;
    case 5:
    container=valve5;
    break;
  }
  //display.clear();
  int i=0;
  float measurements[10];
  scale.tare();
  digitalWrite(container,LOW);
  digitalWrite(motorminus,LOW);
  t0=millis();
  while (1) {
    delay(100);
    measurements[i]=scale.get_units();
    //display.showNumberDecEx((int) measurements[i], 0b00000000, false);
    if(measurements[i]>300) {error=false; break;}
    i=(i+1)%10;
    float maximum=measurements[0];
    float minimum=measurements[0];
    for(int j=0;j<10;j++) {
      if(measurements[j]<minimum) minimum=measurements[j];
      if(measurements[j]>maximum) maximum=measurements[j];
    }
    if(maximum-minimum<3.0 && millis()-t0>airpump) {error=true; break;}
  }
  digitalWrite(motorminus,HIGH);
  //  delay(500);
  digitalWrite(container,HIGH);
  //  delay(500);
}

void outtank(int tank) {
  switch(tank) {
    case 1:
    container=valve1;
    break;
    case 2:
    container=valve2;
    break;
    case 3:
    container=valve3;
    break;
    case 4:
    container=valve4;
    break;
    case 5:
    container=valve5;
    break;
  }
  //display.clear();
  int i=0;
  float measurements[10];
  scale.tare();
  digitalWrite(container,LOW);
  digitalWrite(motorplus,LOW);
  t0=millis();
  while (1) {
    delay(100);
    measurements[i]=scale.get_units();
    //display.showNumberDecEx((int) measurements[i], 0b00000000, false);
    i=(i+1)%10;
    float maximum=measurements[0];
    float minimum=measurements[0];
    for(int j=0;j<10;j++) {
      if(measurements[j]<minimum) minimum=measurements[j];
      if(measurements[j]>maximum) maximum=measurements[j];
    }
    if(maximum-minimum<3.0 && millis()-t0>airpump) break;
  }
  digitalWrite(motorplus,HIGH);
  //  delay(500);
  digitalWrite(container,HIGH);
  //  delay(500);
}

void stage(int in, int out, float a, float b, float c, float d) {
  intank(in);
  if(error) beep();
  agitation(a,b,c,d);
  outtank(out);
}
void develop() {
  switch (dvlpr){
    case 0: //r09 + foma 400
    //              init int- agit devel
    //              agit erv  durat time
    stage(1,5, 60,  30,  5,   11); //develop in rodinal 1+50
    stage(4,5, 30,  60,  10,   1); //in-between wash
    stage(2,2, 30,  30,  5,    6);  //fix
    stage(4,5,  5,  30,  5,    5);   //wash1
    stage(4,5,  5,  30,  5,    5);   //wash2
    stage(4,5,  5,  30,  5,    5);   //wash3
    break;
    case 1: //lqn
    //              init int- agit devel
    //              agit erv  durat time
    stage(1,1, 30,  60,  10,  9);   //develop in lqn
    stage(4,5, 30,  60,  10,  1);   //in-between wash
    stage(2,2, 30,  30,   5,  6);   //fix
    stage(4,5,  5,  30,   5,  5);   //wash1
    stage(4,5,  5,  30,   5,  5);   //wash2
    stage(4,5,  5,  30,   5,  5);   //wash3
    break;
    case 2: //tetenal 30
    //              init int- agit devel
    //              agit erv  durat time
    stage(4,5, 15,  15,   5,  5);   //pre-heat
    stage(1,1, 15,  15,   5,  9);   //colour developer
    stage(2,2, 15,  15,   5,  8);   //bleach fix
    stage(4,5, 15,  15,   5,  2);   //rinse
    stage(4,5, 15,  15,   5,  2);   //rinse
    stage(4,5, 15,  15,   5,  2);   //rinse
    stage(3,3, 15,  15,   5,  1);   //stab
    break;
    case 3: //tetenal 38
    //              init int- agit devel
    //              agit erv  durat time
    stage(4,5, 15,  15,   5,  5);   //pre-heat
    stage(1,1, 15,  15,   5,  3.5); //colour developer
    stage(2,2, 15,  15,   5,  6);   //bleach fix
    stage(4,5, 15,  15,   5,  1.5); //rinse
    stage(4,5, 15,  15,   5,  1.5); //rinse
    stage(3,3, 15,  15,   5,  1);   //stab
    break;
    case 4: //rollei+fuji super hr

    //              init int- agit devel
    //              agit erv  durat time
    stage(1,1, 10,  60,  5,   7);   //develop
    stage(4,5, 30,  60,  10,  1);   //in-between wash
    stage(2,2, 30,  30,   5,  6);   //fix
    stage(4,5,  5,  30,   5,  5);   //wash1
    stage(4,5,  5,  30,   5,  5);   //wash2
    bip();                          //add wetting agent
    stage(4,5,  5,  30,   5,  5);   //wash3
    break;

    case 5: //r09+foma100

    //              init int- agit devel
    //              agit erv  durat time
    stage(1,5, 10,  60,  5,   9);   //develop
    stage(4,5, 30,  60,  10,  1);   //in-between wash
    stage(2,2, 30,  30,   5,  6);   //fix
    stage(4,5,  5,  30,   5,  5);   //wash1
    stage(4,5,  5,  30,   5,  5);   //wash2
    bip();                          //add wetting agent
    stage(4,5,  5,  30,   5,  5);   //wash3
    break;

    case 6: //r09+fuji

    //              init int- agit devel
    //              agit erv  durat time
    stage(1,5, 10,  60,  5,   8);   //develop
    stage(4,5, 30,  60,  10,  1);   //in-between wash
    stage(2,2, 30,  30,   5,  6);   //fix
    stage(4,5,  5,  30,   5,  5);   //wash1
    stage(4,5,  5,  30,   5,  5);   //wash2
    bip();                          //add wetting agent
    stage(4,5,  5,  30,   5,  5);   //wash3
    break;
  }
}
void wait(float waittime) {
  unsigned long int devt=(int) (60000.0*waittime);
  t0=millis();
  while ((millis()-t0)<devt) {
    secs=(t0+devt-millis())/1000UL;
    //display.showNumberDecEx((secs/60UL)*100UL+(secs%60UL), 0b01000000, false);
  }
}
char* const threechars(unsigned long int s)
{
  static char tc[4];
  tc[0] = '\0';
  if (s>99999999) { strcat(tc,"Inf"); return tc;}
  char h[2]=" ";
  char m[2]=" ";
  char c[2]=" ";
  unsigned long int seconds=s%60;
  unsigned long int minutestotal=(unsigned long int)((s-seconds)/60ul);
  unsigned long int minutes=minutestotal%60ul;
  unsigned long int hours=(unsigned long int)((minutestotal-minutes)/60ul);
  if (hours==0) {
    if (minutes==0) {
      itoa(seconds,c,10);
      strcat(tc, c);
      strcat(tc, "s");
    }
    else if (minutes<10) {
      itoa(minutes,m,10);
      strcat(tc, m);
      strcat(tc, "m");
      if (seconds>9) {
        itoa(seconds/10ul,c,10);
        strcat(tc, c);
      }
    }
    else {
      itoa(minutes,m,10);
      strcat(tc, m);
      strcat(tc, "m");
    }
  }
  else if (hours<10) {
    itoa(hours,h,10);
    strcat(tc, h);
    strcat(tc, "h");
    if (minutes>10) {
      itoa(minutes/10ul,m,10);
      strcat(tc, m);
    }
  }
  else {
    itoa(hours,h,10);
    strcat(tc, h);
    strcat(tc, "h");
  }
  return tc;
}
unsigned long int toseconds(byte t)
{
  if (t<=120) return 5UL*t;
  else if (t<=140) return 30ul*(unsigned long int)(t)-3000ul;
  else if (t<=160) return 60ul*(unsigned long int)(t)-7200ul;
  else if (t<=170) return 300ul*(unsigned long int)(t)-45600ul;
  else if (t<=233) return 600ul*(unsigned long int)(t)-96600ul;
  else if (t<=245) return 3600ul*(unsigned long int)(t)-795600ul;
  else if (t<=254) return 7200ul*(unsigned long int)(t)-1677600ul;
  else return 999999999;
}
char* const tohms(unsigned long int s)
{
  static char hms[20];
  hms[0] = '\0';
  if (s>99999999) { strcat(hms,"Infinity"); return hms;}
  char h[3]=" ";
  char m[3]=" ";
  char c[3]=" ";
  unsigned long int seconds=s%60;
  unsigned long int minutestotal=(unsigned long int)((s-seconds)/60ul);
  unsigned long int minutes=minutestotal%60ul;
  unsigned long int hours=(unsigned long int)((minutestotal-minutes)/60ul);
  itoa(hours,h,10);
  itoa(minutes,m,10);
  itoa(seconds,c,10);
  if (hours>0) {
    strcat(hms,h);
    strcat(hms,":");
    if (minutes<10) strcat(hms,"0");
  }
  strcat(hms,m);
  strcat(hms,":");
  if (seconds<10) strcat(hms,"0");
  strcat(hms,c);
  return hms;
}

void setup() {
  analogReference(INTERNAL);
  pinMode(motorplus,OUTPUT);
  pinMode(motorminus,OUTPUT);
  pinMode(valve1,OUTPUT);
  pinMode(valve2,OUTPUT);
  pinMode(valve3,OUTPUT);
  pinMode(valve4,OUTPUT);
  pinMode(valve5,OUTPUT);
  pinMode(valve6,OUTPUT);
  pinMode(buzzer,OUTPUT);
  pinMode(button1,INPUT_PULLUP);
  pinMode(button2,INPUT_PULLUP);
  pinMode(button3,INPUT_PULLUP);
  digitalWrite(valve1,LOW);
  digitalWrite(valve2,LOW);
  digitalWrite(valve3,LOW);
  digitalWrite(valve4,LOW);
  digitalWrite(valve5,LOW);
  digitalWrite(valve6,LOW);
  digitalWrite(motorplus,LOW);
  digitalWrite(motorminus,LOW);
  digitalWrite(buzzer,LOW);
  mixer.attach(servo);
  //display.setBrightness(7);
  //display.clear();
  scale.begin(scaledat,scaleclk);
  scale.set_scale(1850);
  lcd.init();
  lcd.backlight();
}
void loop() {
  switch(k){
    case 0: //main menu
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("A:");
    lcd.print(threechars(toseconds(init_agit)));
    lcd.print("/");
    lcd.print(threechars(toseconds(agit_period)));
    lcd.print("/");
    lcd.print(threechars(toseconds(agit_duration)));
    lcd.setCursor(0,1);
    lcd.print("Wash:");
    lcd.print(washes_count);
    lcd.print(" x ");
    lcd.print(threechars(toseconds(washes_duration)));
    if (fotoflo!=0) lcd.print(" + WA");
    lcd.setCursor(0,2);
    lcd.print("B&W:       C41: #");
    lcd.setCursor(0,3);
    lcd.print("B&W   C41   Settings");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {if (oneshot==0) k=1; else k=2; keypressed=true; delay(300);}
      if(digitalRead(button2)==LOW) {k=4; keypressed=true; delay(300);}
      if(digitalRead(button3)==LOW) {k=5; keypressed=true; delay(300);}
    }
    keypressed=false;
    break;
    case 1:
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("B&W developing");
    lcd.setCursor(0,1);
    lcd.print("Film count: ");
    lcd.print(bw_film_count);
    lcd.setCursor(0,3);
    lcd.print("Reset    +    Next >");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {bw_film_count=1; keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {bw_film_count++; keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=2; keypressed=true;delay(300);}
    }
    keypressed=false;
    break;

    case 2:
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Developing time:");
    lcd.setCursor(0,1);
    lcd.print(tohms(toseconds(bw_dev_time)));
    lcd.setCursor(0,3);
    lcd.print("-      +      Next >");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {bw_dev_time--;keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {bw_dev_time++;keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=3; keypressed=true;delay(300);}
    }
    keypressed=false;
    break;

    case 3:
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Fixing time:");
    lcd.setCursor(0,1);
    lcd.print("tohms(toseconds(bw_fix_time))");
    lcd.setCursor(0,3);
    lcd.print("-      +       Start");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {bw_fix_time--;keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {bw_fix_time++;keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=16; keypressed=true;delay(300);}
    }
    keypressed=false;
    break;

    case 4:
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("C41 color developing");
    lcd.setCursor(0,1);
    lcd.print("Film count: ");
    lcd.print(c41_film_count);
    lcd.setCursor(0,3);
    lcd.print("Reset    +     Start");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {c41_film_count=1;keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {c41_film_count++;keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=17; keypressed=true;delay(300);}
    }
    keypressed=false;
    break;

    case 5:
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Settings         1/8");
    lcd.setCursor(0,1);
    lcd.print("Final wash duration:");
    lcd.setCursor(0,2);
    lcd.print(tohms(toseconds(washes_duration)));
    lcd.setCursor(0,3);
    lcd.print("-      +      Next >");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {washes_duration--;keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {washes_duration++;keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=6; keypressed=true;delay(300);}
    }
    keypressed=false;
    break;

    case 6:
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Settings         2/8");
    lcd.setCursor(0,1);
    lcd.print("Final washes number:");
    lcd.setCursor(0,2);
    lcd.print(washes_count);
    lcd.setCursor(0,3);
    lcd.print("-      +      Next >");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {washes_count--;keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {washes_count++;keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=7;keypressed=true;delay(300);}
    }
    keypressed=false;
    break;

    case 7:
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Settings         3/8");
    lcd.setCursor(0,1);
    lcd.print("Apply wetting agent?");
    lcd.setCursor(0,2);
    if(fotoflo==0) lcd.print("                  No");
    else lcd.print("                 Yes");
    lcd.setCursor(0,3);
    lcd.print("No     Yes    Next >");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {fotoflo=0;keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {fotoflo=1;keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=8;keypressed=true;delay(300);}
    }
    keypressed=false;
    break;

    case 8:
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Settings         4/8");
    lcd.setCursor(0,1);
    lcd.print("Initial agitation:");
    lcd.setCursor(0,2);
    lcd.print(tohms(toseconds(init_agit)));
    lcd.setCursor(0,3);
    lcd.print("-      +      Next >");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {init_agit--;keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {init_agit++;keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=9;keypressed=true;delay(300);}
    }
    keypressed=false;
    break;

    case 9:
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Settings         5/8");
    lcd.setCursor(0,1);
    lcd.print("Agitations period: ");
    lcd.setCursor(0,2);
    lcd.print(tohms(toseconds(agit_period)));
    lcd.setCursor(0,3);
    lcd.print("-      +      Next >");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {agit_period--;keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {agit_period++;keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=10;keypressed=true;delay(300);}
    }
    keypressed=false;
    break;

    case 10:

    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Settings         6/8");
    lcd.setCursor(0,1);
    lcd.print("Agitation duration:");
    lcd.setCursor(0,2);
    lcd.print(tohms(toseconds(agit_duration)));
    lcd.setCursor(0,3);
    lcd.print("-      +      Next >");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {agit_duration--;keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {agit_duration++;keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=11;keypressed=true;delay(300);}
    }
    keypressed=false;
    break;

    case 11:

    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Settings         7/8");
    lcd.setCursor(0,1);
    lcd.print("Tank capacity:");
    lcd.setCursor(0,2);
    lcd.print("300g");
    lcd.setCursor(0,3);
    lcd.print("-      +      Next >");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=12;keypressed=true;delay(300);}
    }
    keypressed=false;
    break;

    case 12:

    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Settings         8/8");
    lcd.setCursor(0,1);
    lcd.print("Press two buttons to");
    lcd.setCursor(0,2);
    lcd.print("enter advanced opts");
    lcd.setCursor(0,3);
    lcd.print("Yes     Yes       No");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW && digitalRead(button2)==LOW) {k=13;keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=0;keypressed=true;delay(300);}
    }
    keypressed=false;
    break;
    case 13:

    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Advanced         1/2");
    lcd.setCursor(0,1);
    lcd.print("Weight sensor tuning");
    lcd.setCursor(0,2);
    lcd.print("Current: 297g");
    lcd.setCursor(0,3);
    lcd.print("Set:0  Set:300g    >");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=14;keypressed=true;delay(300);}
    }
    keypressed=false;
    break;

    case 14:

    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Advanced         2/2");
    lcd.setCursor(0,1);
    lcd.print("Discard B&W dev");
    lcd.setCursor(0,2);
    lcd.print("after use?       ");
    if(oneshot==0) lcd.print(" No");
    else lcd.print("Yes");
    lcd.setCursor(0,3);
    lcd.print("Yes     No      Done");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {oneshot=1;keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {oneshot=0;keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {k=0;keypressed=true;delay(300);}
    }
    keypressed=false;
    break;
    case 16:

    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("B&W develop     1/7");
    lcd.setCursor(0,1);
    lcd.print("Developer pump in");
    lcd.setCursor(0,2);
    lcd.print("276g      1:23:59:59");
    lcd.setCursor(0,3);
    lcd.print("1:23:53:15      left");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {keypressed=true;delay(300);}
    }
    keypressed=false;
    break;

    case 17:

    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("C41 develop     1/7");
    lcd.setCursor(0,1);
    lcd.print("Developer pump in");
    lcd.setCursor(0,2);
    lcd.print("276g      1:23:59:59");
    lcd.setCursor(0,3);
    lcd.print("1:23:53:15      left");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {keypressed=true;delay(300);}
      if(digitalRead(button2)==LOW) {keypressed=true;delay(300);}
      if(digitalRead(button3)==LOW) {keypressed=true;delay(300);}
    }
    keypressed=false;


  }
}
