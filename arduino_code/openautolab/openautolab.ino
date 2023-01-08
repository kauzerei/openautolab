#include <TM1637Display.h>
#include <Servo.h>
#include <HX711.h>
/*t B01111000
a B01110111
n B01010100
1 B00000110
2 B01011011
3 B01001111
w B01111110
s B01101101
h B01110110
d B01011110
e B01111001
v B00011100 */
const uint8_t tan1[] ={B01111000,B01110111,B01010100,B00000110};
const uint8_t tan2[] ={B01111000,B01110111,B01010100,B01011011};
const uint8_t tan3[] ={B01111000,B01110111,B01010100,B01001111};
const uint8_t wash[] ={B01111110,B01110111,B01101101,B01110110};
const uint8_t dev[] ={B01011110,B01111001,B00011100,B00000000};
const uint8_t devh[] ={B01011110,B01111001,B00011100,B01110110};
const uint8_t heat[] ={B01110110,B01111001,B01110111,B01111000};
unsigned long int t0; // here time of start will be stored
unsigned long int secs; // here number of seconds on display will be stored
const byte motorplus =12; //positive pole of pump motor
const byte motorminus=11; //negative pole of pump motor
const byte valve1=10; //pins
const byte valve2=9; //of
const byte valve3=8; //valves
const byte valve4=7;
const byte valve5=6;
const byte heater=5; //pin of heater
const byte therm=A6; //pin of thermometer
const byte servo=A0; //servo pin
const byte scaleclk=3; //pins of
const byte scaledat=2; //scale
const byte buzzer=4; //buzzer pin
const byte displayclk=A4; //pins of
const byte displaydio=A5; //display
const byte button1=A1; //buttons
const byte button2=A2;
const byte button3=A3;
volatile float curtemp=20.0;
float temperature=0.0; //goal temperature for heater
float tolerance=0.2; //temperature tolerance for hysteresis
byte dvlpr=4; //developer index
float dev_temp[]={20,20,30,38,20}; //corresponding developing temperature
byte k=0; //state index
byte container; //pin corresponding to current valve
unsigned long int airpump=10000UL; //number of milliseconds pumping without liquid tolerated   
bool error=false; //if something sent wrong machine beeps
TM1637Display display = TM1637Display(displayclk, displaydio);
Servo mixer;
HX711 scale;
ISR(TIMER2_OVF_vect){  //here we check thermometer value and turn on and off heating
  curtemp=0.99*curtemp+0.01*(((((float) analogRead(therm))+0.5)*1.1/1024.0-0.5)*100.0); //averaging
  if (curtemp<temperature-tolerance) digitalWrite(heater,LOW);
  if (curtemp>temperature+tolerance) digitalWrite(heater,HIGH);
}
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
  display.showNumberDecEx((secs/60UL)*100UL+(secs%60UL), 0b01000000, false);
}
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
  display.clear();
  int i=0;
  float measurements[10];
  scale.tare();
  digitalWrite(container,LOW);
  digitalWrite(motorminus,LOW);
  t0=millis();
  while (1) {
    delay(100);
    measurements[i]=scale.get_units();
    display.showNumberDecEx((int) measurements[i], 0b00000000, false);
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
  display.clear();
  int i=0;
  float measurements[10];
  scale.tare();
  digitalWrite(container,LOW);
  digitalWrite(motorplus,LOW);
  t0=millis();
  while (1) {
    delay(100);
    measurements[i]=scale.get_units();
    display.showNumberDecEx((int) measurements[i], 0b00000000, false);
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
    display.showNumberDecEx((secs/60UL)*100UL+(secs%60UL), 0b01000000, false);
  }
}

void heat_overshoot(float goaltemp) {
  temperature=2*goaltemp-curtemp;
  if (temperature>60) temperature=60;
  while(curtemp<temperature) display.showNumberDecEx((int) (curtemp*10.0), 0b00000000, true);
  temperature=goaltemp;
  while(curtemp>temperature) display.showNumberDecEx((int) (curtemp*10.0), 0b00000000, false); 
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
pinMode(heater,OUTPUT);
pinMode(buzzer,OUTPUT);
pinMode(button1,INPUT_PULLUP);
pinMode(button2,INPUT_PULLUP);
pinMode(button3,INPUT_PULLUP);
digitalWrite(valve1,HIGH);
digitalWrite(valve2,HIGH);
digitalWrite(valve3,HIGH);
digitalWrite(valve4,HIGH);
digitalWrite(valve5,HIGH);
digitalWrite(heater,HIGH);
digitalWrite(motorplus,HIGH);
digitalWrite(motorminus,HIGH);
digitalWrite(buzzer,LOW);
mixer.attach(servo);
display.setBrightness(7);
display.clear();
scale.begin(scaledat,scaleclk);
scale.set_scale(1850);
TCCR2A = 0; // Timer/counter 2 Control Register A
TCCR2B = 0; // Timer/counter 2 Control Register B
TCCR2B |= (1 << CS20);
TCCR2B |= (1 << CS21);
TCCR2B |= (1 << CS22); //timer prescaler 1024, see atmega 328 datasheet 17.11.2
TIMSK2 |= (1 <<  TOIE2); //timer overflow interrupt see atmega 328 datasheet 17.11.6
sei();

}
void loop() {
  switch(k){
    case 0: 
      display.setSegments(tan1);
      if(digitalRead(button1)==LOW) {k=6; delay(200);}
      if(digitalRead(button2)==LOW) {k++; delay(200);}
      if(digitalRead(button3)==LOW) {
        digitalWrite(valve1,LOW);
        digitalWrite(motorplus,LOW);
//        digitalWrite(motorminus,LOW);
      }
      if(digitalRead(button3)==HIGH) {
        digitalWrite(motorplus,HIGH);
//        digitalWrite(motorminus,HIGH);
        digitalWrite(valve1,HIGH);
      }
      break;
    case 1:
      display.setSegments(tan2);
      if(digitalRead(button1)==LOW) {k--; delay(200);}
      if(digitalRead(button2)==LOW) {k++; delay(200);}
      if(digitalRead(button3)==LOW) {
        digitalWrite(valve2,LOW);
        digitalWrite(motorplus,LOW);
//        digitalWrite(motorminus,LOW);
      }
      if(digitalRead(button3)==HIGH) {
        digitalWrite(motorplus,HIGH);
//        digitalWrite(motorminus,HIGH);
        digitalWrite(valve2,HIGH);
      }
      break;
    case 2: 
      display.setSegments(tan3);
      if(digitalRead(button1)==LOW) {k--; delay(200);}
      if(digitalRead(button2)==LOW) {k++; delay(200);}
      if(digitalRead(button3)==LOW) {
        digitalWrite(valve3,LOW);
        digitalWrite(motorplus,LOW);
//        digitalWrite(motorminus,LOW);
      }
      if(digitalRead(button3)==HIGH) {
        digitalWrite(motorplus,HIGH);
//        digitalWrite(motorminus,HIGH);
        digitalWrite(valve3,HIGH);
      }
      break;
    case 3: 
      display.setSegments(wash);
      if(digitalRead(button1)==LOW) {k--; delay(200);}
      if(digitalRead(button2)==LOW) {k++; delay(200);}
      if(digitalRead(button3)==LOW) {
        stage(4,1,0,1,0,0);
        stage(4,2,0,1,0,0);
        stage(4,3,0,1,0,0);
        stage(1,5,0,1,0,0);
        stage(2,5,0,1,0,0);
        stage(3,5,0,1,0,0);
        beep();
      }
      break;
    case 4:
      display.setSegments(dev);
      if(digitalRead(button1)==LOW) {k--; delay(200);}
      if(digitalRead(button2)==LOW) {k++; delay(200);}
      if(digitalRead(button3)==LOW) {
        develop();
        beep();
        }
        break;
    case 5: 
      display.setSegments(devh);
      if(digitalRead(button1)==LOW) {k--; delay(200);}
      if(digitalRead(button2)==LOW) {k++; delay(200);}
      if(digitalRead(button3)==LOW) {
        heat_overshoot(dev_temp[dvlpr]);
        wait(10.0);
        develop();
        beep();
      }      
      break;
    case 6: 
      display.setSegments(heat);
      if(digitalRead(button1)==LOW) {k--; delay(200);}
      if(digitalRead(button2)==LOW) {k=0; delay(200);}
      if(digitalRead(button3)==LOW) {
        heat_overshoot(dev_temp[dvlpr]);
        beep();
      }
      break;
  }
}


