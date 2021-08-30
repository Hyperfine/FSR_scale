/*********************

Example code for the Adafruit RGB Character LCD Shield and Library

This code displays text on the shield, and also reads the buttons on the keypad.
When a button is pressed, the backlight changes color.

**********************/

// define ONE of these macros to select the display mode
//#define DISPLAY_ADC_RAW 1
//#define DISPLAY_NORMALIZED 1
//#define DISPLAY_KOHM 1
#define DISPLAY_CAL_KG 1

#define Rpd_kohm 20.000
#define Rfsr_max_kohm 9999.00

// include the library code:
#include <Wire.h>
#include <Adafruit_RGBLCDShield.h>
#include <utility/Adafruit_MCP23017.h>
#include <stdlib.h>

// The shield uses the I2C SCL and SDA pins. On classic Arduinos
// this is Analog 4 and 5 so you can't use those for analogRead() anymore
// However, you can connect other I2C sensors to the I2C bus and share
// the I2C bus.
Adafruit_RGBLCDShield lcd = Adafruit_RGBLCDShield();

// These #defines make it easy to set the backlight color
#define RED 0x1
#define YELLOW 0x3
#define GREEN 0x2
#define TEAL 0x6
#define BLUE 0x4
#define VIOLET 0x5
#define WHITE 0x7
#define analogPin A0

#define uart_msg_tx_LEN 64
char msg_out[uart_msg_tx_LEN];

void setup() {
  Serial.begin(57600);
  Serial.println("setup");
  // set up the LCD's number of columns and rows: 
  lcd.begin(16, 2);

  // Print a message to the LCD. We track how long it takes since
  // this library has been optimized a bit and we're proud of it :)
  int time = millis();
#if defined(DISPLAY_ADC_RAW)
  lcd.print("Raw ADC value:");
  Serial.println("Raw ADC value:");
#elif defined(DISPLAY_NORMALIZED)
  lcd.print("% Full scale:");
  Serial.println("% Full scale:");
#elif defined(DISPLAY_KOHM)
  lcd.print("FSR kohms:");
  Serial.println("FSR kohms:");
#elif defined(DISPLAY_CAL_KG)
  lcd.print("FSR kG:");
  Serial.println("FSR kG:");
#endif
  lcd.setBacklight(WHITE);
  lcd.setCursor(0, 1);
}

float FSR_measurement_raw_norm;
float FSR_measurement_units;

void loop() {

  //not using any buttons
  //uint8_t buttons = lcd.readButtons();

  char teststring[12];
  lcd.setCursor(0,1);
  int a;

  FSR_measurement_raw_norm=measureFSR_float_norm();
  

#if defined(DISPLAY_ADC_RAW)
  FSR_measurement_units=FSR_measurement_raw_norm*1023.0;
  #if defined(CAL_ADC_raw)
  FSR_measurement_units=apply_cal(FSR_measurement_units);
  #endif
  dtostrf(FSR_measurement_units,7,2,teststring);
  lcd.print(teststring);
   
  sprintf(msg_out,"Raw ADC value = %s\n",teststring);
  Serial.print(msg_out);
#elif defined(DISPLAY_NORMALIZED)
  FSR_measurement_units=FSR_measurement_raw_norm*100.0;
  dtostrf(FSR_measurement_units,6,2,teststring);
  //a = teststring;
  lcd.print(teststring);
  lcd.print("%");

  sprintf(msg_out,"Norm ADC value = %s\n",teststring);
  Serial.print(msg_out);
#elif defined(DISPLAY_KOHM)
  //double alpha=measureFSR_double();
  float Rfsr_kohm=0.0;
  if (FSR_measurement_raw_norm<=0.0)
  {
    Rfsr_kohm=Rfsr_max_kohm;
  }
  else
  {
    Rfsr_kohm=Rpd_kohm*(1.00/FSR_measurement_raw_norm-1);
  }
  if(Rfsr_kohm>Rfsr_max_kohm)
  {
    Rfsr_kohm=Rfsr_max_kohm;
  }
  dtostrf(Rfsr_kohm,6,4,teststring);
  lcd.print(teststring);
  lcd.print(" K");

  sprintf(msg_out,"FSR = %s",teststring);
  Serial.print(msg_out);
  Serial.println(" kohm");
#elif defined(DISPLAY_CAL_KG)
  float Rfsr_kohm=0.0;
  if (FSR_measurement_raw_norm<=0.0)
  {
    Rfsr_kohm=Rfsr_max_kohm;
  }
  else
  {
    Rfsr_kohm=Rpd_kohm*(1.00/FSR_measurement_raw_norm-1);
  }
  if(Rfsr_kohm>Rfsr_max_kohm)
  {
    Rfsr_kohm=Rfsr_max_kohm;
  }
  
  
  dtostrf(Rfsr_kohm,4,2,teststring);
  if(Rfsr_kohm >= Rfsr_max_kohm) {
    sprintf(msg_out,"R = inf kOhm",teststring);
  }
  else {
    sprintf(msg_out,"R = %s kOhm",teststring);
  }
  Serial.println(msg_out);
  //first row is for kohm measurement
  lcd.setCursor(0, 0);
  //lcd.print("R = ");
  lcd.print(msg_out);
  //lcd.print(" kOhm");
  

  FSR_measurement_units=apply_cal_kohm_to_kg(Rfsr_kohm);
  dtostrf(FSR_measurement_units,4,2,teststring);
  if(Rfsr_kohm >= Rfsr_max_kohm) {
    sprintf(msg_out,"M = 0 kg",teststring);
  }
  else
  {
    sprintf(msg_out,"M = %s kg",teststring);
  }
  Serial.println(msg_out);
  
  //second row for calibrated kG value
  lcd.setCursor(0, 1);
  //lcd.print("Mass = ");
  lcd.print(msg_out);
  //lcd.print(" kg");
  
  //lcd.print(teststring);
  ///lcd.print(" kG");

  
  #endif
}

float measureFSR_float_norm(void)
{
  float FSR_float=0;
  uint16_t idx=0;
  for(idx=0;idx<1000;idx++)
  {
    FSR_float=FSR_float+(float)analogRead(analogPin)/1023.0;
    delayMicroseconds(100);
  }
  //return 125.5;
  return (FSR_float/1000.0);
}

double measureFSR_double(void)
{
  double FSR_double=0;
  uint16_t idx=0;
  for(idx=0;idx<1000;idx++)
  {
    FSR_double=FSR_double+(double)analogRead(analogPin)/1023.0;
    delayMicroseconds(100);
  }
  //return 125.5;
  return (FSR_double/1000.0);
}

// calibration data taken on 2/25/21
// check matlab code cal_2_25_21.m

double apply_cal_kohm_to_kg(float raw_kohm)
{
  float kg_out=0;
  float x=1.0/raw_kohm;
  int n=4;
  //float p[5] = {2.8373e6, -4.0202e5, 2.2768e4, 291.58,5.4305}; //2_25_21
  //float p[5] = {3.5249e7, -2.7592e6, 7.4759e4, -194.5859,3.6994}; //4_08_21
  float p[5] = {1.1565e7, -1.1762e6, 4.7002e4, 87.667,3.8749}; //4_16_21
  // yfit = p1*x^n + p2*x^(n-1) + .... pn*x + pn+1
  // where n=1,2,....,n+1
  uint16_t k;
  for(k=0;k<(n+1);k++)
  {
    kg_out+=p[k]*pow(x,n-k);
  }
  return kg_out;
}
