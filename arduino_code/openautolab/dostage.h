#include <LiquidCrystal_I2C.h>
struct Stage {
  char display_name[12];
  unsigned long stage_duration;
  unsigned long init_agit;
  unsigned long agit_period;
  unsigned long agit_duration;
  byte fromvessel;
  byte tovessel;
  };
  
void dostage(Stage stage, LiquidCrystal_I2C lcd) {
  lcd.setCursor(0,1);
  lcd.print(stage.display_name);
  pump(true,stage.fromvessel);
  agitate(stage.stage_duration, stage.init_agit, stage.agit_period, stage.agit_duration);
  pump(false,stage.tovessel);
  }
