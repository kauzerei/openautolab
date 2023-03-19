int ess=0; //EEPROM starting address, change to ess+12 if settings saving becomes unstable

#include <LiquidCrystal_I2C.h>
#include <Servo.h>
#include <HX711.h>
#include <EEPROM.h>

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

//global variables and EEPROM adresses, which store settings
byte bw_dev_time=EEPROM.read(ess+0);
byte bw_fix_time=EEPROM.read(ess+1);
byte bw_film_count=EEPROM.read(ess+2);
byte c41_film_count=EEPROM.read(ess+3);
byte washes_count=EEPROM.read(ess+4);
byte washes_duration=EEPROM.read(ess+5);
byte fotoflo=EEPROM.read(ess+6);
byte init_agit=EEPROM.read(ess+7);
byte agit_period=EEPROM.read(ess+8);
byte agit_duration=EEPROM.read(ess+9);
byte tank_cap=EEPROM.read(ess+10);
byte oneshot=EEPROM.read(ess+11);


//global variables, which store values during work
byte k=0; //main menu state machine state index
volatile unsigned long int tstart; // start of development time
volatile unsigned long int t0; // start of intermediate process
volatile unsigned long int tk; // last key press time
bool keypressed=false;
bool button1_released=true;
bool button2_released=true;
bool button3_released=true;
unsigned long ignore_until;
bool released;
Servo mixer;
HX711 scale;
LiquidCrystal_I2C lcd(0x27,20,4);

void keydelay() {
  if(millis()-tk>200) delay (200);
  //  else delay (50);
  tk=millis();
}

void beep() {
  t0=millis();
  while (1) {
    if((millis()-t0)%500UL<250UL) digitalWrite(buzzer,HIGH);
    else digitalWrite(buzzer,LOW);
    if(millis()-t0>5000) {digitalWrite(buzzer,LOW); break;} //here be time of beepeng on error
    if(digitalRead(button3)==LOW) {digitalWrite(buzzer,LOW); break;} //here be interrupt beeping and continuing
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

byte waitkey() {

  while (true) {
    if(digitalRead(button1)==LOW) {
      if (released or millis()> ignore_until) {ignore_until=released?millis()+500:ignore_until+50; released=false; return 1;}
      released=false;
      }
    else if(digitalRead(button2)==LOW) {
      if (released or millis()> ignore_until) {ignore_until=released?millis()+500:ignore_until+50; released=false; return 2;}
      released=false;
      }
    else if(digitalRead(button3)==LOW) {
      if (released or millis()> ignore_until) {ignore_until=released?millis()+500:ignore_until+50; released=false; return 3;}
      released=false;
      }
    else released=true;
  }
}

void pump(boolean direction, byte vessel) {
  lcd.setCursor(12,1);
  lcd.print("pump ");
  if (direction) lcd.print("in ");
  else lcd.print("out");
  delay(1000);
}

void agitate(unsigned long stage_duration, unsigned long init_agit, unsigned long agit_period, unsigned long agit_duration) {
  lcd.setCursor(12,1);
  lcd.print("process ");
  delay(1000);
}

struct Stage {
  const char display_name[12];
  unsigned long duration;
  unsigned long init_agit;
  unsigned long agit_period;
  unsigned long agit_duration;
  byte fromvessel;
  byte tovessel;
  byte repeat;
};


void do_stage(struct Stage stage) {
  pump(true,stage.fromvessel);
  agitate(stage.duration, stage.init_agit, stage.agit_period, stage.agit_duration);
  pump(false,stage.tovessel);
}

struct Process {
  const char display_name[16];
  struct Stage stages[8];
};

void do_process (struct Process process) {
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("               "); //clear that part of display
  lcd.setCursor(0,0);
  lcd.print(process.display_name);
  byte stages_count=sizeof(process.stages)/sizeof(process.stages[0]);
  byte substages_count=0;
  byte substage=1;
  for (byte i=0;i<stages_count;i++) substages_count+=process.stages[i].repeat;
  for (byte i=0;i<stages_count;i++) {
    for (byte j=0;j<process.stages[i].repeat;j++) {
      lcd.setCursor(0,1);
      lcd.print("           "); //clear that part of display
      lcd.setCursor(0,1);
      lcd.print(process.stages[i].display_name);
      if (process.stages[i].repeat>1) lcd.print(j+1);
      lcd.setCursor(15,0);
      lcd.print("     "); // new values should never be shorter than older, but just in case clear part of display
      lcd.setCursor(15,0);
      lcd.print(substage);
      lcd.print("/");
      lcd.print(substages_count);
      do_stage(process.stages[i]);
      substage++;
    }
  }
  lcd.setCursor(0,1);
  lcd.print("        Done.       "); //clear that part of display

}

void d76() {
  do_process((Process){"B&W develop", {
    (Stage){"Developer",toseconds(bw_dev_time),init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Rinse dev",30ul,init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Fixer",toseconds(bw_fix_time),init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Wash ",toseconds(washes_duration),init_agit,agit_period,agit_duration,1,2,washes_count},
    (Stage){"Wet agent",toseconds(washes_duration),init_agit,agit_period,agit_duration,1,2,fotoflo}
  }});
}

void c41() {
  do_process((Process){"C41 develop", {
    (Stage){"Prewash",30ul,init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Developer",100ul,init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Rinse dev",30ul,init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Bleach",100ul,init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Rinse bl",30ul,init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Fixer",100ul,init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Wash ",toseconds(washes_duration),init_agit,agit_period,agit_duration,1,2,washes_count},
    (Stage){"Wet agent",toseconds(washes_duration),init_agit,agit_period,agit_duration,1,2,fotoflo}
  }});
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
    lcd.print("B&W: ");
    if (oneshot) lcd.print("1shot");
    else lcd.print(bw_film_count);
    lcd.setCursor(11,2);
    lcd.print("C41: #");
    lcd.print(bw_film_count);
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
      if(digitalRead(button2)==LOW) {bw_film_count++; keypressed=true;keydelay();}
      if(digitalRead(button3)==LOW) {k=2; EEPROM.update(ess+2,bw_film_count); keypressed=true;delay(300);}
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

    /*keypressed=false;
    while (not keypressed) {
      
      if(digitalRead(button1)==LOW) {bw_dev_time--;keypressed=true;keydelay();}
      if(digitalRead(button2)==LOW) {bw_dev_time++;keypressed=true;keydelay();}
      if(digitalRead(button3)==LOW) {k=3; EEPROM.update(ess+0,bw_dev_time); keypressed=true;delay(300);}
      */
      switch(waitkey()){
        case 1: bw_dev_time--; break;
        case 2: bw_dev_time++; break;
        case 3: k=3; EEPROM.update(ess+0,bw_dev_time);
        }
 // }
    keypressed=false;
    break;

    case 3:
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Fixing time:");
    lcd.setCursor(0,1);
    lcd.print(tohms(toseconds(bw_fix_time)));
    lcd.setCursor(0,3);
    lcd.print("-      +       Start");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {bw_fix_time--;keypressed=true;keydelay();}
      if(digitalRead(button2)==LOW) {bw_fix_time++;keypressed=true;keydelay();}
      if(digitalRead(button3)==LOW) {k=16; EEPROM.update(ess+1,bw_fix_time); keypressed=true;delay(300);}
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
      if(digitalRead(button2)==LOW) {c41_film_count++;keypressed=true;keydelay();}
      if(digitalRead(button3)==LOW) {k=17; EEPROM.update(ess+3,c41_film_count); keypressed=true; delay(300);}
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
      if(digitalRead(button1)==LOW) {washes_duration--; keypressed=true; keydelay();}
      if(digitalRead(button2)==LOW) {washes_duration++; keypressed=true; keydelay();}
      if(digitalRead(button3)==LOW) {k=6; EEPROM.update(ess+5,washes_duration); keypressed=true; delay(300);}
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
      if(digitalRead(button1)==LOW) {washes_count--; keypressed=true; keydelay();}
      if(digitalRead(button2)==LOW) {washes_count++; keypressed=true; keydelay();}
      if(digitalRead(button3)==LOW) {k=7; EEPROM.update(ess+4,washes_count); keypressed=true; delay(300);}
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
      if(digitalRead(button1)==LOW) {fotoflo=0; keypressed=true; delay(300);}
      if(digitalRead(button2)==LOW) {fotoflo=1; keypressed=true; delay(300);}
      if(digitalRead(button3)==LOW) {k=8; EEPROM.update(ess+6,fotoflo); keypressed=true; delay(300);}
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
      if(digitalRead(button1)==LOW) {init_agit--; keypressed=true; keydelay();}
      if(digitalRead(button2)==LOW) {init_agit++; keypressed=true; keydelay();}
      if(digitalRead(button3)==LOW) {k=9; EEPROM.update(ess+7,init_agit); keypressed=true; delay(300);}
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
      if(digitalRead(button1)==LOW) {agit_period--; keypressed=true; keydelay();}
      if(digitalRead(button2)==LOW) {agit_period++; keypressed=true; keydelay();}
      if(digitalRead(button3)==LOW) {k=10; EEPROM.update(ess+8,agit_period); keypressed=true; delay(300);}
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
      if(digitalRead(button1)==LOW) {agit_duration--; keypressed=true; keydelay();}
      if(digitalRead(button2)==LOW) {agit_duration++; keypressed=true; keydelay();}
      if(digitalRead(button3)==LOW) {k=11; EEPROM.update(ess+9,agit_duration); keypressed=true; delay(300);}
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
    lcd.print(tank_cap*10);
    lcd.print("g");
    lcd.setCursor(0,3);
    lcd.print("-      +      Next >");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {tank_cap--; keypressed=true; keydelay();}
      if(digitalRead(button2)==LOW) {tank_cap++; keypressed=true; keydelay();}
      if(digitalRead(button3)==LOW) {k=12; EEPROM.update(ess+10,tank_cap); keypressed=true; delay(300);}
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
      if(digitalRead(button1)==LOW && digitalRead(button2)==LOW) {k=13; keypressed=true; delay(300);}
      if(digitalRead(button3)==LOW) {k=0; keypressed=true; delay(300);}
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
    lcd.print("Set:0  Set:");
    lcd.print(tank_cap*10);
    lcd.print("g    >");

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {keypressed=true; delay(300);}
      if(digitalRead(button2)==LOW) {keypressed=true; delay(300);}
      if(digitalRead(button3)==LOW) {k=14; keypressed=true; delay(300);}
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
      if(digitalRead(button1)==LOW) {oneshot=1; keypressed=true; delay(300);}
      if(digitalRead(button2)==LOW) {oneshot=0; keypressed=true; delay(300);}
      if(digitalRead(button3)==LOW) {k=0; EEPROM.update(ess+11,oneshot); keypressed=true; delay(300);}
    }
    keypressed=false;
    break;
    case 16:
    d76();

    keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW) {k=0; keypressed=true; delay(300);}
      if(digitalRead(button2)==LOW) {k=0; keypressed=true; delay(300);}
      if(digitalRead(button3)==LOW) {k=0; keypressed=true; delay(300);}
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
