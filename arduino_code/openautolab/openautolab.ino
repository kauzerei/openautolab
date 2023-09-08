int ess=0; //EEPROM starting address, change to ess+22 if settings saving and loading becomes unstable

#include <LiquidCrystal_I2C.h>
#include <Servo.h>
#include <HX711.h>
#include <EEPROM.h>

//pin numbers
const byte motorplus =5; //positive pole of pump motor
const byte motorminus=6; //negative pole of pump motor
const byte valve1=9; //pins
const byte valve2=11; //of
const byte valve3=10; //valves
const byte valve4=12;
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
byte prewashes_count=EEPROM.read(ess+4);
byte prewashes_duration=EEPROM.read(ess+5);
byte washes_count=EEPROM.read(ess+6);
byte washes_duration=EEPROM.read(ess+7);
byte fotoflo=EEPROM.read(ess+8);
byte init_agit=EEPROM.read(ess+9);
byte agit_period=EEPROM.read(ess+10);
byte agit_duration=EEPROM.read(ess+11);
byte tank_cap=EEPROM.read(ess+12);
byte oneshot=EEPROM.read(ess+13);
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

unsigned int getFreeMemory()
{
  uint8_t* temp = (uint8_t*)malloc(16);    // assumes there are no free holes so this is allocated at the end
  unsigned int rslt = (uint8_t*)SP - temp;
  free(temp);
  return rslt;
}

void beep() {
  st_ag=millis();
  while (1) {
    if((millis()-st_ag)%500UL<250UL) digitalWrite(buzzer,HIGH);
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
  delay(200);
  digitalWrite(direction?motorminus:motorplus,HIGH);
  t0=millis();
  bool error=false;
  while (1) {
    lcd.setCursor(10,3);
    tohms((millis()-st_pr)/1000);
    delay(100);
    measurements[i]=scale.get_units();
    lcd.setCursor(0,3);
    lcd.print(measurements[i]);
    lcd.print(F("  "));
    if(measurements[i]>10.0*tank_cap) {error=false; break;}
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
  delay(200);
  digitalWrite(motorplus,LOW);
  delay(200);
  digitalWrite(pin,LOW);
  delay(200);
}

void agitate(unsigned long stage_duration, byte init_agit, byte agit_period, byte agit_duration) {
  st_ag=millis(); //agitation-related times calculated from here
  if (agit_period==0) agit_period=255; //period equal to zero does not make sense, setting to infinity instead, should never happen
  lcd.setCursor(12,1);
  //lcd.print(getFreeMemory());
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
    (Stage){"Prewash ",toseconds(prewashes_duration),init_agit,agit_period,agit_duration,5,6,prewashes_count},
    (Stage){"Developer",toseconds(bw_dev_time),init_agit,agit_period,agit_duration,1,oneshot?byte(6):byte(1),1},
    (Stage){"Rinse dev",30ul,init_agit,agit_period,agit_duration,5,6,1},
    (Stage){"Fixer",toseconds(bw_fix_time),init_agit,agit_period,agit_duration,2,2,1},
    (Stage){"Wash ",toseconds(washes_duration),init_agit,agit_period,agit_duration,5,6,washes_count},
    (Stage){"Wet agent",toseconds(washes_duration),init_agit,agit_period,agit_duration,4,6,fotoflo}
  }};
  do_process(process);
}

void c41() { //definition of c41 process, more of those can be written if needed
  struct Process process={"C41 develop", {
    (Stage){"Prewash ",toseconds(prewashes_duration),init_agit,agit_period,agit_duration,5,6,prewashes_count},
    (Stage){"Developer",195ul+4ul*(c41_film_count-2),init_agit,agit_period,agit_duration,1,1,1},
    (Stage){"Rinse dev",30ul,init_agit,agit_period,agit_duration,5,6,1},
    (Stage){"Bleach",260ul,init_agit,agit_period,agit_duration,2,2,1},
    (Stage){"Rinse bl",30ul,init_agit,agit_period,agit_duration,5,6,1},
    (Stage){"Fixer",390ul,init_agit,agit_period,agit_duration,3,3,1},
    (Stage){"Wash ",toseconds(washes_duration),init_agit,agit_period,agit_duration,5,6,washes_count},
    (Stage){"Wet agent",toseconds(washes_duration),init_agit,agit_period,agit_duration,4,6,fotoflo}
  }};
  do_process(process);
}

void pumpallout() { //definition of wash process
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(F("Emptying vessels"));
  lcd.setCursor(0,1);
  lcd.print(F("from tank"));
  pump(false,6);
  for (byte i=1;i<=4;i++) {
    lcd.setCursor(0,1);
    lcd.print(F("Vessel   "));
    lcd.setCursor(7,1);
    lcd.print(i);
    lcd.setCursor(0,2);
    lcd.print(F("from vessel to tank"));
    pump(true,i);
    lcd.setCursor(0,2);
    lcd.print(F("from tank          "));
    pump(false,6);
    }
}

void pumpallin(bool tank) { //definition of wash process
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(F("Filling vessels"));
  for (byte i=1;i<=4;i++) {
    lcd.setCursor(0,1);
    lcd.print(F("Vessel "));
    lcd.print(i);
    lcd.setCursor(0,2);
    lcd.print(F("water to tank       "));
    pump(true,5);
    lcd.setCursor(0,2);
    lcd.print(F("from tank to vessel"));
    pump(false,i);
  }
  lcd.setCursor(0,1);
    lcd.print(F("        "));
  lcd.setCursor(0,3);
  lcd.print(F("water to tank       "));
  if (tank) pump(true,5);
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
  EEPROM.get(ess+14,divider); //this is here, because one can't use EEPROM.get outside of a function
  EEPROM.get(ess+18,offset);
  scale.begin(scaledat,scaleclk); //load cell
  scale.set_scale(divider);
  scale.set_offset(offset);
  lcd.init(); //display
  lcd.backlight();
  if(digitalRead(button1)==LOW && digitalRead(button2)==LOW && digitalRead(button3)==LOW) k=40; //service menu

}
void loop() {
  switch(k) {
    case 0: //main menu
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Agit: ");
    threechars(toseconds(init_agit));
    lcd.print("/");
    threechars(toseconds(agit_period));
    lcd.print("/");
    threechars(toseconds(agit_duration));
    lcd.setCursor(0,1);
    lcd.print("Wash:");
    lcd.print(prewashes_count);
    lcd.print("x");
    threechars(toseconds(prewashes_duration));
    lcd.print("+");
    lcd.print(washes_count);
    lcd.print("x");
    threechars(toseconds(washes_duration));
    if (fotoflo!=0) lcd.print("+WA");
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
      case 3: k=5;
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

    case 5: //prewash duration
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings        1/10"));
    lcd.setCursor(0,1);
    lcd.print(F("Prewash duration:"));
    lcd.setCursor(0,2);
    tohms(toseconds(prewashes_duration));
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: prewashes_duration--; break;
      case 2: prewashes_duration++; break;
      case 3: k=6; EEPROM.update(ess+5,prewashes_duration);
      }
    break;

    case 6: //how many prewashes
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings        2/10"));
    lcd.setCursor(0,1);
    lcd.print(F("Prewashes number:"));
    lcd.setCursor(0,2);
    lcd.print(prewashes_count);
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: prewashes_count--; break;
      case 2: prewashes_count++; break;
      case 3: k=7; EEPROM.update(ess+4,prewashes_count);
      }
    break;

    case 7: //wash duration
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings        3/10"));
    lcd.setCursor(0,1);
    lcd.print(F("Final wash duration:"));
    lcd.setCursor(0,2);
    tohms(toseconds(washes_duration));
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: washes_duration--; break;
      case 2: washes_duration++; break;
      case 3: k=8; EEPROM.update(ess+7,washes_duration);
      }
    break;

    case 8: //how many washes
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings        4/10"));
    lcd.setCursor(0,1);
    lcd.print(F("Final washes number:"));
    lcd.setCursor(0,2);
    lcd.print(washes_count);
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: washes_count--; break;
      case 2: washes_count++; break;
      case 3: k=9; EEPROM.update(ess+6,washes_count);
      }
    break;

    case 9: //wetting agent in separate vessel
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings        5/10"));
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
      case 3: k=10; EEPROM.update(ess+8,fotoflo);
      }
    break;

    case 10: //initial agitation
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings        6/10"));
    lcd.setCursor(0,1);
    lcd.print(F("Initial agitation:"));
    lcd.setCursor(0,2);
    tohms(toseconds(init_agit));
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: init_agit--; break;
      case 2: init_agit++; break;
      case 3: k=11; EEPROM.update(ess+9,init_agit);
      }
    break;

    case 11: //agitate every x seconds
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings        7/10"));
    lcd.setCursor(0,1);
    lcd.print(F("Agitations period: "));
    lcd.setCursor(0,2);
    tohms(toseconds(agit_period));
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: agit_period--; if(agit_period==0) agit_period--; break;
      case 2: agit_period++; if(agit_period==0) agit_period++; break;
      case 3: k=12; EEPROM.update(ess+10,agit_period);
      }
    break;

    case 12: //for how long to agitate
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings        8/10"));
    lcd.setCursor(0,1);
    lcd.print(F("Agitation duration:"));
    lcd.setCursor(0,2);
    tohms(toseconds(agit_duration));
    lcd.setCursor(0,3);
    lcd.print(F("-      +      Next >"));
    switch(waitkey()){
      case 1: agit_duration--; break;
      case 2: agit_duration++; break;
      case 3: k=13; EEPROM.update(ess+11,agit_duration);
      }
    break;

    case 13: //tank capacity, this also sets weight to use on scale calibration
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings        9/10"));
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
      case 3: k=14; EEPROM.update(ess+12,tank_cap);
      }
    break;

    case 14: //where does the developer go after use? Back to original vessel, or discarded?
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Settings       10/10"));
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
      case 3: k=0; EEPROM.update(ess+13,oneshot);
      }
    break;

    case 40: //service menu
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Service menu"));
    delay(2000);
    k=41;
    break;
    
    case 41: //scale calibration
    lcd.setCursor(0,0);
    lcd.print(F("Service menu     1/3"));
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
    for (byte i=0;i<255;i++) { //I forgot why this loop is there, probably has to do with screen blinking
      if(digitalRead(button1)==LOW) {offset=scale.read_average(10); scale.set_offset(offset); keypressed=true; scale_calibrated=true;}
      if(digitalRead(button2)==LOW) {scale.set_scale();divider=scale.get_units(10)/(10.f*tank_cap); scale.set_scale(divider); keypressed=true; scale_calibrated=true;}
      if(digitalRead(button3)==LOW) {k=42; keypressed=true; if (scale_calibrated) {EEPROM.put(ess+14,divider);EEPROM.put(ess+18,offset);}}
      if(keypressed) break;
    }}
    break;

    case 42: //pump in
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Service menu     2/3"));
    lcd.setCursor(0,1);
    lcd.print(F("Fill only vessels,"));
    lcd.setCursor(0,2);
    lcd.print(F("or also the tank?"));
    lcd.setCursor(0,3);
    lcd.print(F("V      V+T    Next >"));
    switch(waitkey()){
      case 1: pumpallin(false); break;
      case 2: pumpallin(true); break;
      case 3: k=43; EEPROM.update(ess+13,oneshot);
      }
    break;

    case 43: //cleaning cycle
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(F("Service menu     3/3"));
    lcd.setCursor(0,1);
    lcd.print(F("Clean. Are vessels"));
    lcd.setCursor(0,2);
    lcd.print(F("empty right now?"));
    lcd.setCursor(0,3);
    lcd.print(F("No     Yes    Done >"));
    switch(waitkey()){
      case 1: 
        st_pr=millis();
        tank_cap=50;
        pumpallout();
        tank_cap=40;
        pumpallin(false);
        tank_cap=50;
        pumpallout();
        tank_cap=EEPROM.read(ess+10);
        lcd.setCursor(16,0);
        lcd.print(F("Done"));
        waitkey();
        break;
      case 2: 
        st_pr=millis();
        tank_cap=40;
        pumpallin(false);
        tank_cap=50;
        pumpallout();
        tank_cap=EEPROM.read(ess+10);
        lcd.setCursor(16,0);
        lcd.print(F("Done"));
        waitkey();
        break;
      case 3: k=0;
      }
    break;

    case 16:
    d76();
    beep();
    waitkey();
    k=0;
    break;

    case 17:
    c41();
    beep();
    waitkey();
    k=0;
    break;
  }
}
