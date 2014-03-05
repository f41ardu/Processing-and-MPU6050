/* Example by F41ARDU
   Vorraussetzung
   Ein Android basiertes SMARTPHONE 
   Prozessing (Mode Android), Ardunio
   Als Eingabe dient das Android Programm Motorflug.
   Siehe:   http://www.tec.reutlingen-university.de/fakultaet-technik/personen/professoren/prof-dr-rer-nat-stefan-mack/ardusmartpilot-projekt.html
   Die Idee diese Programms ist bei der Entwicklung der Kommunikationsstings zu unterstützen. 
   Serieller Eingabe bei Arduino und Prozessing gibt. 
   In diesem Beispiel bewegen wir eine Drahtbox.
*/   
import processing.serial.*; // Import der Serial Bibliothek
Serial myPort;  // The serial port
String myString;
float x,y,z; 
int i=0,trans=0, offset=10,j=0;
boolean debug=false; // Für Kontrollausgaben der Übertragenen Daten debug = true  
int[] werte = new int[3]; //Array für die beiden Integerwerte
int arrayIndex = 0; //Arrayindex initialisieren.
int kommaZahl = 0; //Anzal der empfangenen Werte
long zeitSteuerAlt = 0;
long zeitSteuerNeu = 0;

int zaehlSensor = 0;
// Setup Routine 
void setup() {
  size(480, 320, P3D); 
  frameRate(20);
  background(255);
  // Alle vorhandene seriellen Ports auflisten
  println(Serial.list());
  // Den Port öffen der in der Bluetoooth Configuration definiert ist
  // 0 = com 1 
  // 1 = com15
  // Bitte an die eigene Konfiguration anpassen  
  myPort = new Serial(this, Serial.list()[1], 115200); // Den verwendeten Port öffen. 
  noStroke();
  background(0);
  x=radians(90-offset);
  y=radians(90);
}
// Hier geht die Hauptroutine los
void draw() {
   
 
// Wir starten mit der Default Darstellung des Objekts.      
  background(0);
  lights(); 
  pushMatrix();
  translate(width/2,height/2, trans);   
//  
   rotateX(x);
   rotateY(y);  
//   rotateX(radians(i++));
//     fill(255,255,0);
//     box(100,100,10);
   noFill(); 
   stroke(255);
//        sphere(100);
        fill(0,255,0);
   stroke(0,0,255);
   box(10,100,100);
   box(75,5,5);
   
   translate(-60,0,0);
   sphere(10);
   translate(120,0,0);
   stroke(255,0,0);
   sphere(10);
   popMatrix();   
// Auslesen der seriellen Daten           
   while (myPort.available() > 0) { // Liegen neue Daten am serieller Port an?
   char ch = myPort.readChar(); 
   if (ch >= '0' && ch <= '9') {
     werte[arrayIndex] = (werte[arrayIndex] * 10 + (ch - '0'));
   } else if (ch == ',') {
     arrayIndex++;
   //  arrayIndex = min(arrayIndex,2); // Den Index auf maximal 2 begrenzen
     kommaZahl++;
      //Serial.println("hab ein Komma");
   } else if ( ch == '\n') {
     // Test Ausgabe kann zur Kontrolle aus oder einkommentiert werden      
     if (debug) {
       println(werte[0]);
       
       println(werte[1]);
       println(werte[2]);
     }
      // Anzeige Rückmeldung Arduino Zahl empfangener Werte
  textSize(10);
  fill(255, 255, 255); 
  text("X ", 25, 50);
  text(werte[0], 25, 50+15);
  text("Y ", 25, 100);
  text(werte[1], 25, 100+15);
  text("Z ", 25, 150);
  text(werte[2], 25, 150+15);
  
     y = radians(werte[0]);  // y,z (degree nach radian) und trans aktualisieren
     x = radians(werte[1]-offset);
     trans = werte[2];
     zaehlSensor++;
     for(int i=0; i <= arrayIndex; i++) werte[i] = 0; // Wertearray zurücksetzen.
     arrayIndex = 0;
     if((zaehlSensor % 10 == 0)) //Modulo Funktion (Rest nach Division)
      {
       zeitSteuerNeu = millis();
       myString="";
       myString = str(kommaZahl) + "," + str(int((zeitSteuerNeu - zeitSteuerAlt) % 10000)) + ","+ "\n";
       myPort.write(myString);
       zeitSteuerAlt = zeitSteuerNeu;
       }
     kommaZahl = 0;
    }
    
// Das wars 
    
    
    
    
    
    
    
    
    
    
    
    
  }
}
