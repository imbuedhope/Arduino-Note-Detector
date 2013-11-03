import java.util.*;

class noteDetectorThread extends Thread {

  private int[] serialInArray;

  private ArrayList<Integer> min = new ArrayList<Integer>();
  private ArrayList<Integer> max = new ArrayList<Integer>();

  private ArrayList<Integer> dist = new ArrayList<Integer>();

  noteDetectorThread(int[] serialIn) {
    serialInArray = serialIn;
  }

  public void run() {
    int[] d = new int[serialInArray.length-1]; //rate of change array

    for (int i = 0; i < d.length; i++) {
      d[i] = serialInArray[i+1]-serialInArray[i];
    }

    for (int i = 1; i < d.length; i++) {
      if (d[i-1] < 0 && d[i] > 0) {
        //minimum
        min.add(new Integer(i));
      } 
      else if (d[i-1] > 0 && d[i] < 0) {
        //maximum
        max.add(new Integer(i));
      } 
      else if (d[i] == 0) {
        //rare senario where the wave is flat. ie, no vibrations picked up.
        //should scan to edge of flat to find appox time
        //will ignore this senario for this work
      }
    }

    //everything is sorted by default which is nice and saves processing time
    //should finish each thread in 10 seconds or issues will ensue

    //sometimes min and max lists may have a length diffence of 1
    //use the shorter length in this case

    int scanLen;
    if (min.size() == max.size()) {
      scanLen = min.size();
    } 
    else if (min.size() > max.size()) {
      scanLen = max.size();
    } 
    else {
      scanLen = min.size();
    }

    for (int i = 0; i < scanLen; i++) {
      dist.add(new Integer(Math.abs(min.get(i).intValue()-max.get(i).intValue()))); 
      //positive time differnce between a single half period

      //average period calculation
      int sum = 0;
      for (Integer v: dist) {
        sum += v.intValue();
      }

      double per = sum / dist.size();
      per *= 2;
      per /= 38500; //multiply by time per data to get period of wave

      //average frequency calculation
      double freq = 1/per;

      //check against notes for value
      printNote(freq);
    }
  }

  private void printNote(double freq) {
    int f = (int) freq;

    if (f < 31) {
      System.out.println("Frequency too low");
    } 
    else if (f > 4978) {
      System.out.println("Frequency too high");
    } 
    else {
      int i = 0;
      boolean between = false;

      while (i < pitchFrequency.length) {
        if (pitchFrequency[i] == f) {
          between = false;
          break;
        } 
        else if (i+1 < pitchFrequency.length && pitchFrequency[i] < f && pitchFrequency[i+1] > f) {
          between = true;
          break;
        } 
        else {
          i++;
        }

        if (!between) {
          System.out.println("The note is: "+pitchName[i]);
        } 
        else {
          System.out.println("The note is between "+pitchName[i]+" and "+pitchName[i+1]);
        }
      }
    }
  }

  private int[] pitchFrequency = {
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

  private String pitchName[] = { 
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
}

