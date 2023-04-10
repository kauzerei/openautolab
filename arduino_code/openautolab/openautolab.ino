int ess=0; //EEPROM starting address, change to ess+20 if settings saving becomes unstable

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
float divider; //because one can't use EEPROM.get outside of a function
long offset;

//global variables, which store values during work
byte k=0; //main menu state machine state index
unsigned long st_pr; // start of development time, to display for reference
unsigned long st_st; // start of intermediate stage, to calculate when to pump out chemical
unsigned long st_ag; // start of agitation, to calculate agitation cycles
unsigned long t0; //start of pumping
unsigned long ignore_until; //ignore keypress until this time, for key repeat implementation
bool released; //true if no keys are pressed on waitkey() loop
bool scale_calibrated=false; //store values to EEPROM only on change
Servo mixer;
HX711 scale;
LiquidCrystal_I2C lcd(0x27,20,4);

void beep() {
  st_pr=millis();
  while (1) {
    if((millis()-st_pr)%500UL<250UL) digitalWrite(buzzer,HIGH);
    else digitalWrite(buzzer,LOW);
    if(millis()-st_pr>5000) {digitalWrite(buzzer,LOW); break;} //here be time of beepeng on error
    if(digitalRead(button3)==LOW) {digitalWrite(buzzer,LOW); break;} //here be interrupt beeping and continuing
  }
}

void threechars(unsigned long int s) //print time in seconds in three-character format
{
  if (s>=4000000) { lcd.print(F("Inf")); return;}
  byte seconds=s%60;
  unsigned int minutestotal=(s-seconds)/60;
  byte minutes=minutestotal%60ul;
  byte hours=(minutestotal-minutes)/60ul;
  if (hours==0) {
    if (minutes==0) {
      lcd.print(seconds);
      lcd.print("s");
    }
    else if (minutes<10) {
      lcd.print(minutes);
      lcd.print("m");
      if (seconds>9) {
        lcd.print(seconds/10);
        }
    }
    else {
      lcd.print(minutes);
      lcd.print("m");
    }
  }
  else if (hours<10) {
    lcd.print(hours);
    lcd.print("h");
    if (minutes>10) {
      lcd.print(minutes/10);
    }
  }
  else {
    lcd.print(hours);
    lcd.print("h");
  }
}
unsigned long int toseconds(byte &t) //one-byte time representation to seconds
{
  if (t<=120) return 5UL*t;
  else if (t<=140) return 30ul*(unsigned long int)(t)-3000ul;
  else if (t<=160) return 60ul*(unsigned long int)(t)-7200ul;
  else if (t<=170) return 300ul*(unsigned long int)(t)-45600ul;
  else if (t<=233) return 600ul*(unsigned long int)(t)-96600ul;
  else if (t<=245) return 3600ul*(unsigned long int)(t)-795600ul;
  else if (t<=254) return 7200ul*(unsigned long int)(t)-1677600ul;
  else return 4000000;
}
void tohms(unsigned long int s) //print time in seconds in hh:mm:ss format without leading zeros
{
  if (s>=4000000) { lcd.print(F("Infinity")); return;}
  byte seconds=s%60;
  unsigned int minutestotal=(s-seconds)/60;
  byte minutes=minutestotal%60ul;
  byte hours=(minutestotal-minutes)/60ul;
  if (hours>0) {
    lcd.print(hours);
    lcd.print(":");
    if (minutes<10) lcd.print("0");
  }
  lcd.print(minutes);
  lcd.print(":");
  if (seconds<10) lcd.print("0");
  lcd.print(seconds);
}

byte waitkey() { //waits for button press, implements delay. Function seems not to need explicit debounce, but if necessary, just add delay(20); before return
  while (true) {
    if(digitalRead(button1)==LOW) {
      if (released or millis()> ignore_until) {ignore_until=released?millis()+800:ignore_until+50; released=false; delay(20); return 1;}
      released=false;
      }
    else if(digitalRead(button2)==LOW) {
      if (released or millis()> ignore_until) {ignore_until=released?millis()+800:ignore_until+0; released=false; delay(20); return 2;}
      released=false;
      }
    else if(digitalRead(button3)==LOW) {
      if (released or millis()> ignore_until) {ignore_until=released?millis()+800:ignore_until+0; released=false; delay(20); return 3;}
      released=false;
      }
    else released=true;
  }
}

void pump(boolean direction, byte vessel) { 
  byte pin;
  switch (vessel) {
    case 1: pin=valve1; break;
    case 2: pin=valve2; break;
    case 3: pin=valve3; break;
    case 4: pin=valve4; break;
    case 5: pin=valve5; break;
    case 6: pin=valve6; break;
    }
  lcd.setCursor(12,1);
  lcd.print("pump ");
  if (direction) lcd.print("in ");
  else lcd.print("out");
  int i=0;
  float measurements[10];
  scale.tare();
  digitalWrite(pin,HIGH);
  digitalWrite(direction?motorminus:motorplus,HIGH);
  t0=millis();
  bool error=false;
  while (1) {
    delay(100);
    measurements[i]=scale.get_units();
    lcd.setCursor(0,2);
    lcd.print(measurements[i]);
    lcd.print(F("     "));
    if(abs(measurements[i])>10.0*tank_cap) {error=false; break;}
    i=(i+1)%10;
    float maximum=measurements[0];
    float minimum=measurements[0];
    for(int j=0;j<10;j++) {
      if(measurements[j]<minimum) minimum=measurements[j];
      if(measurements[j]>maximum) maximum=measurements[j];
    }
    if(maximum-minimum<3.0 && millis()-t0>5000ul) {error=true; break;}
  }
  digitalWrite(motorminus,LOW);
  digitalWrite(motorplus,LOW);
  digitalWrite(pin,LOW);
}

void agitate(unsigned long stage_duration, byte init_agit, byte agit_period, byte agit_duration) {
  st_ag=millis(); //agitation-related times calculated from here
  if (agit_period==0) agit_period=255; //period equal to zero does not make sense, setting to infinity instead, should never happen
  lcd.setCursor(12,1);
  lcd.print("process ");
  while(millis()-st_st<stage_duration*1000ul) { //stage duration is calculated from beginning of pumping in to beginning of pumping out, not from agitation start
    lcd.setCursor(10,3);
    tohms((millis()-st_pr)/1000);
    lcd.setCursor(0,2);
    tohms((millis()-st_st)/1000);
    lcd.print(" / ");
    tohms(stage_duration);
    if ((millis()<st_ag+toseconds(init_agit)*1000ul)
      || ((millis()-st_ag-toseconds(init_agit)*1000ul+toseconds(agit_duration)*1000ul)%(toseconds(agit_period)*1000ul)<toseconds(agit_duration)*1000ul) )
        mixer.write(((millis()-st_ag)%2000UL<1000UL)?180:0);
  }
}

struct Stage { //definition of a processing stage, such as developing, fixing or washing
  const char display_name[12];
  unsigned long duration;
  byte init_agit;
  byte agit_period;
  byte agit_duration;
  byte fromvessel;
  byte tovessel;
  byte repeat;
};


void do_stage(struct Stage stage) { //execution one iteration of one processing stage
  st_st=millis();
  pump(true,stage.fromvessel);
  agitate(stage.duration, stage.init_agit, stage.agit_period, stage.agit_duration);
  pump(false,stage.tovessel);
}

struct Process { //definition of a process, such as C41 or D76
  const char display_name[16];
  struct Stage stages[8];
};

void do_process (const struct Process &process) { //execution of a process. Number of iterations and most of display output are taken care of here
  st_pr=millis();
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(F("               ")); //clear that part of display
  lcd.setCursor(0,0);
  lcd.print(process.display_name);
  byte stages_count=sizeof(process.stages)/sizeof(process.stages[0]);
  byte substages_count=0;
  byte substage=1;
  for (byte i=0;i<stages_count;i++) substages_count+=process.stages[i].repeat;
  for (byte i=0;i<stages_count;i++) {
    for (byte j=0;j<process.stages[i].repeat;j++) {
      lcd.setCursor(0,1);
      lcd.print(F("           ")); //clear that part of display
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
  lcd.print("        Done.       "); 

}

void d76() { //definition of black-and-white process, more of those can be written if needed
    struct Process process={"B&W develop", {
    (Stage){"Developer",toseconds(bw_dev_time),init_agit,agit_period,agit_duration,1,oneshot?byte(4):byte(1),1},
    (Stage){"Rinse dev",30ul,init_agit,agit_period,agit_duration,3,4,1},
    (Stage){"Fixer",toseconds(bw_fix_time),init_agit,agit_period,agit_duration,2,2,1},
    (Stage){"Wash ",toseconds(washes_duration),init_agit,agit_period,agit_duration,3,4,washes_count},
    (Stage){"Wet agent",toseconds(washes_duration),init_agit,agit_period,agit_duration,5,4,fotoflo}
  }};
  do_process(process);
}

void c41() { //definition of c41 process, more of those can be written if needed 
  struct Process process={"C41 develop", {
    (Stage){"Prewash",30ul,init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Developer",100ul,init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Rinse dev",30ul,init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Bleach",100ul,init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Rinse bl",30ul,init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Fixer",100ul,init_agit,agit_period,agit_duration,1,2,1},
    (Stage){"Wash ",toseconds(washes_duration),init_agit,agit_period,agit_duration,1,2,washes_count},
    (Stage){"Wet agent",toseconds(washes_duration),init_agit,agit_period,agit_duration,1,2,fotoflo}
  }};
  do_process(process);
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
  mixer.write(0);
  EEPROM.get(ess+12,divider); //this is here, because one can't use EEPROM.get outside of a function
  EEPROM.get(ess+16,offset);
  scale.begin(scaledat,scaleclk); //load cell
  scale.set_scale(divider);
  scale.set_offset(offset);
  lcd.init(); //display
  lcd.backlight();
}
void loop() {
  switch(k) {
    case 0: //main menu
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("A:");
    threechars(toseconds(init_agit));
    lcd.print("/");
    threechars(toseconds(agit_period));
    lcd.print("/");
    threechars(toseconds(agit_duration));
    lcd.setCursor(0,1);
    lcd.print("Wash:");
    lcd.print(washes_count);
    lcd.print(" x ");
    threechars(toseconds(washes_duration));
    if (fotoflo!=0) lcd.print(" + WA");
    lcd.setCursor(0,2);
    lcd.print("B&W: ");
    if (oneshot) lcd.print("1shot");
    else lcd.print(bw_film_count);
    lcd.setCursor(11,2);
    lcd.print("C41: #");
    lcd.print(c41_film_count);
    lcd.setCursor(0,3);
    lcd.print(F("B&W   C41   Settings"));
    switch(waitkey()){
      case 1: k=(oneshot==0)?1:2; break;
      case 2: k=4; break;
      case 3: k=5; EEPROM.update(ess+0,bw_dev_time);
      }
    break;
    
    case 1: //checking developer depletion
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("B&W developing"));
    lcd.setCursor(0,1);
    lcd.print(F("Film count: "));
    lcd.print(bw_film_count);
    lcd.setCursor(0,3);
    lcd.print(F("Reset    +    Next >"));
    switch(waitkey()){
      case 1: bw_film_count=1; break;
      case 2: bw_film_count++; break;
      case 3: k=2; bw_film_count++; EEPROM.update(ess+2,bw_film_count);
      }
    break;

    case 2: //set up dev time
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Developing time:"));
    lcd.setCursor(0,1);
    tohms(toseconds(bw_dev_time));
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: bw_dev_time--; break;
      case 2: bw_dev_time++; break;
      case 3: k=3; EEPROM.update(ess+0,bw_dev_time);
      }
    break;

    case 3: //set up fix time
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Fixing time:"));
    lcd.setCursor(0,1);
    tohms(toseconds(bw_fix_time));
    lcd.setCursor(0,3);
    lcd.print(F("-      +       Start"));
    switch(waitkey()){
      case 1: bw_fix_time--; break;
      case 2: bw_fix_time++; break;
      case 3: k=16; EEPROM.update(ess+1,bw_fix_time);
      }
    break;

    case 4: //checking chemicals depletion
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("C41 color developing"));
    lcd.setCursor(0,1);
    lcd.print(F("Film count: "));
    lcd.print(c41_film_count);
    lcd.setCursor(0,3);
    lcd.print(F("Reset    +     Start"));
    switch(waitkey()){
      case 1: c41_film_count=1; break;
      case 2: c41_film_count++; break;
      case 3: k=17; c41_film_count++; EEPROM.update(ess+3,c41_film_count);}
    break;

    case 5: //wash duration
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings         1/8"));
    lcd.setCursor(0,1);
    lcd.print(F("Final wash duration:"));
    lcd.setCursor(0,2);
    tohms(toseconds(washes_duration));
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: washes_duration--; break;
      case 2: washes_duration++; break;
      case 3: k=6; EEPROM.update(ess+5,washes_duration);
      }
    break;

    case 6: //how many washes
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings         2/8"));
    lcd.setCursor(0,1);
    lcd.print(F("Final washes number:"));
    lcd.setCursor(0,2);
    lcd.print(washes_count);
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: washes_count--; break;
      case 2: washes_count++; break;
      case 3: k=7; EEPROM.update(ess+4,washes_count);
      }
    break;

    case 7: //wetting agent in separate vessel
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings         3/8"));
    lcd.setCursor(0,1);
    lcd.print(F("Apply wetting agent?"));
    lcd.setCursor(0,2);
    if(fotoflo==0) lcd.print(F("                  No"));
    else lcd.print(F("                 Yes"));
    lcd.setCursor(0,3);
    lcd.print(F("No     Yes    Next >"));
    switch(waitkey()){
      case 1: fotoflo=0; break;
      case 2: fotoflo=1; break;
      case 3: k=8; EEPROM.update(ess+6,fotoflo);
      }
    break;

    case 8: //initial agitation
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings         4/8"));
    lcd.setCursor(0,1);
    lcd.print(F("Initial agitation:"));
    lcd.setCursor(0,2);
    tohms(toseconds(init_agit));
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: init_agit--; break;
      case 2: init_agit++; break;
      case 3: k=9; EEPROM.update(ess+7,init_agit);
      }
    break;

    case 9: //agitate every x seconds
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings         5/8"));
    lcd.setCursor(0,1);
    lcd.print(F("Agitations period: "));
    lcd.setCursor(0,2);
    tohms(toseconds(agit_period));
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: agit_period--; if(agit_period==0) agit_period--; break;
      case 2: agit_period++; if(agit_period==0) agit_period++; break;
      case 3: k=10; EEPROM.update(ess+8,agit_period);
      }
    break;

    case 10: //for how long to agitate
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings         6/8"));
    lcd.setCursor(0,1);
    lcd.print(F("Agitation duration:"));
    lcd.setCursor(0,2);
    tohms(toseconds(agit_duration));
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: agit_duration--; break;
      case 2: agit_duration++; break;
      case 3: k=11; EEPROM.update(ess+9,agit_duration);
      }
    break;

    case 11: //tank capacity, this also sets weight to use on scale calibration
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings         7/8"));
    lcd.setCursor(0,1);
    lcd.print(F("Tank capacity:"));
    lcd.setCursor(0,2);
    lcd.print(tank_cap*10);
    lcd.print("g");
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: tank_cap--; break;
      case 2: tank_cap++; break;
      case 3: k=12; EEPROM.update(ess+10,tank_cap);
      }
    break;

    case 12: //advanced settings
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings         8/8"));
    lcd.setCursor(0,1);
    lcd.print(F("Press two buttons to"));
    lcd.setCursor(0,2);
    lcd.print(F("enter advanced opts"));
    lcd.setCursor(0,3);
    lcd.print(F("Yes     Yes       No"));
    {bool keypressed=false;
    while (not keypressed) {
      if(digitalRead(button1)==LOW && digitalRead(button2)==LOW) {k=13; keypressed=true; delay(300);}
      if(digitalRead(button3)==LOW) {k=0; keypressed=true; delay(300);}
    }}
    break;

    case 13: //scale calibration
    lcd.setCursor(0,0);
    lcd.print(F("Advanced         1/2"));
    lcd.setCursor(0,2);
    lcd.print(F("Current: "));
    lcd.print(scale.get_units());
    lcd.print(F("           ")); //erase symbols left from previous measurment
    lcd.setCursor(0,1);
    lcd.print(F("Weight sensor tuning"));
    lcd.setCursor(0,3);
    lcd.print(F("Set:0  Set:"));
    lcd.print(tank_cap*10);
    lcd.print(F("g    >"));
    {bool keypressed=false;
    for (byte i=0;i<255;i++) {
      if(digitalRead(button1)==LOW) {offset=scale.read_average(10); scale.set_offset(offset); keypressed=true; scale_calibrated=true;}
      if(digitalRead(button2)==LOW) {scale.set_scale();divider=scale.get_units(10)/(10.f*tank_cap); scale.set_scale(divider); keypressed=true; scale_calibrated=true;}
      if(digitalRead(button3)==LOW) {k=14; keypressed=true; if (scale_calibrated) {EEPROM.put(ess+12,divider);EEPROM.put(ess+16,offset);} delay(300);}
      if(keypressed) break;
    }}
    break;

    case 14: //where does the developer go after use? Back to original vessel, or discarded?
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Advanced         2/2"));
    lcd.setCursor(0,1);
    lcd.print(F("Discard B&W dev"));
    lcd.setCursor(0,2);
    lcd.print(F("after use?       "));
    if(oneshot==0) lcd.print(" No");
    else lcd.print("Yes");
    lcd.setCursor(0,3);
    lcd.print(F("Yes     No      Done"));
    switch(waitkey()){
      case 1: oneshot=1; break;
      case 2: oneshot=0; break;
      case 3: k=0; EEPROM.update(ess+11,oneshot);
      }
    break;
    
    case 16:
    d76();
    waitkey();
    k=0;
    break;

    case 17:
    c41();
    waitkey(); 
    k=0;
    break;
  }
}
