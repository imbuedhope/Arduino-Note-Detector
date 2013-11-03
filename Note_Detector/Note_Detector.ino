const int arrLen = 89;

int pitchfrequency[] = {
  31,
  33,
  35,
  37,
  39,
  41,
  44,
  46,
  49,
  52,
  55,
  58,
  62,
  65,
  69,
  73,
  78,
  82,
  87,
  93,
  98,
  104,
  110,
  117,
  123,
  131,
  139,
  147,
  156,
  165,
  175,
  185,
  196,
  208,
  220,
  233,
  247,
  262,
  277,
  294,
  311,
  330,
  349,
  370,
  392,
  415,
  440,
  466,
  494,
  523,
  554,
  587,
  622,
  659,
  698,
  740,
  784,
  831,
  880,
  932,
  988,
  1047,
  1109,
  1175,
  1245,
  1319,
  1397,
  1480,
  1568,
  1661,
  1760,
  1865,
  1976,
  2093,
  2217,
  2349,
  2489,
  2637,
  2794,
  2960,
  3136,
  3322,
  3520,
  3729,
  3951,
  4186,
  4435,
  4699,
  4978
};

String pitchname[] = {
  "NOTE_B0",
  "NOTE_C1",
  "NOTE_CS1",
  "NOTE_D1",
  "NOTE_DS1",
  "NOTE_E1",
  "NOTE_F1",
  "NOTE_FS1",
  "NOTE_G1",
  "NOTE_GS1",
  "NOTE_A1",
  "NOTE_AS1",
  "NOTE_B1",
  "NOTE_C2",
  "NOTE_CS2",
  "NOTE_D2",
  "NOTE_DS2",
  "NOTE_E2",
  "NOTE_F2",
  "NOTE_FS2",
  "NOTE_G2",
  "NOTE_GS2",
  "NOTE_A2",
  "NOTE_AS2",
  "NOTE_B2",
  "NOTE_C3",
  "NOTE_CS3",
  "NOTE_D3",
  "NOTE_DS3",
  "NOTE_E3",
  "NOTE_F3",
  "NOTE_FS3",
  "NOTE_G3",
  "NOTE_GS3",
  "NOTE_A3",
  "NOTE_AS3",
  "NOTE_B3",
  "NOTE_C4",
  "NOTE_CS4",
  "NOTE_D4",
  "NOTE_DS4",
  "NOTE_E4",
  "NOTE_F4",
  "NOTE_FS4",
  "NOTE_G4",
  "NOTE_GS4",
  "NOTE_A4",
  "NOTE_AS4",
  "NOTE_B4",
  "NOTE_C5",
  "NOTE_CS5",
  "NOTE_D5",
  "NOTE_DS5",
  "NOTE_E5",
  "NOTE_F5",
  "NOTE_FS5",
  "NOTE_G5",
  "NOTE_GS5",
  "NOTE_A5",
  "NOTE_AS5",
  "NOTE_B5",
  "NOTE_C6",
  "NOTE_CS6",
  "NOTE_D6",
  "NOTE_DS6",
  "NOTE_E6",
  "NOTE_F6",
  "NOTE_FS6",
  "NOTE_G6",
  "NOTE_GS6",
  "NOTE_A6",
  "NOTE_AS6",
  "NOTE_B6",
  "NOTE_C7",
  "NOTE_CS7",
  "NOTE_D7",
  "NOTE_DS7",
  "NOTE_E7",
  "NOTE_F7",
  "NOTE_FS7",
  "NOTE_G7",
  "NOTE_GS7",
  "NOTE_A7",
  "NOTE_AS7",
  "NOTE_B7",
  "NOTE_C8",
  "NOTE_CS8",
  "NOTE_D8",
  "NOTE_DS8"
};

//Audio out with 38.5kHz sampling rate
//by Amanda Ghassaei
//http://www.instructables.com/id/Arduino-Audio-Input/
//Sept 2012

/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
*/

//int incomingAudio;//storage for A0 data

void setup(){
  
  //set up continuous sampling of analog pin 0 (you don't need to understand this part, just know how to use it in the loop())
  
  //clear ADCSRA and ADCSRB registers
  ADCSRA = 0;
  ADCSRB = 0;
  
  ADMUX |= (1 << REFS0); //set reference voltage
  ADMUX |= (1 << ADLAR); //left align the ADC value- so we can read highest 8 bits from ADCH register only
  
  ADCSRA |= (1 << ADPS2) | (1 << ADPS0); //set ADC clock with 32 prescaler- 16mHz/32=500kHz
  ADCSRA |= (1 << ADATE); //enabble auto trigger
  ADCSRA |= (1 << ADEN); //enable ADC
  ADCSRA |= (1 << ADSC); //start ADC measurements
  
  //if you want to add other things to setup(), do it here

}

void loop(){
  PORTD = ADCH;
}

void sendNoteData(int frequency){
  if(frequency < 31) {
    Serial.print("Frequency too low!");
  } else if(frequency > 4978) {
    Serial.print("Frequency too high!");
  } else {
    int i = 0;
    boolean between;
    while(i < arrLen) {
      if(pitchfrequency[i] == frequency) {
        between = false;
        break;
      } else if(i+1 < arrLen && pitchfrequency[i] < frequency && pitchfrequency[i+1] > frequency) {
        between = true;
        break;
      } else {
        i++;
      }
    }
    
    if(!between) {
      Serial.print("The note is: "+pitchname[i]);
    } else {
      Serial.print("The note is between "+pitchname[i]+"and "+pitchname[i+1]);
    }
    
  }
}
