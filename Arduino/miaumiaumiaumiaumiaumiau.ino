// Dreams client sketch for ENC28J60 based Ethernet Shield.
// Author: Henry Lopez del Pino - henry.lopez@mail.udp.cl
// Based in Twitter Client for ENC28J60 from EtherCard.h Examples

#include <EtherCard.h>
#include <dht.h>

dht DHT;

#define DHT11_PIN 3

// ethernet interface mac address, must be unique on the LAN
byte mymac[] = { 0x74,0x69,0x69,0x2D,0x30,0x31 };

const char website[] PROGMEM = "dreams.cuy.cl";

static byte session;

byte Ethernet::buffer[700];
Stash stash;
uint32_t timer;

int sound;


static void sendToServer () {
  Serial.println("Sending Data to Server...");
  byte sd = stash.create();

  // Get Values
  int chk = DHT.read11(DHT11_PIN);
  int light = 1023-((analogRead(A0)+analogRead(A1))/2);
  //int sound = analogRead(A2);
  int temp = DHT.temperature;
  int humid = DHT.humidity;
  
  Serial.println();
  Serial.print("Light: ");
  Serial.println(light);
  Serial.print("Sound: ");
  Serial.println(sound);
  Serial.print("Temp: ");
  Serial.println(temp);
  Serial.print("Humid:");
  Serial.println(humid);
  Serial.println();
  
  stash.print("light=");
  stash.print(light);
  stash.print("&sound=");
  stash.print(sound);
  stash.print("&temperature=");
  stash.print(temp);
  stash.print("&humidity=");
  stash.print(humid);
  stash.save();
  int stash_size = stash.size();

  // Compose the http POST request, taking the headers below and appending
  // previously created stash in the sd holder.
  Stash::prepare(PSTR("POST http://$F/users/1/measurements/ HTTP/1.0" "\r\n"
    "Host: $F" "\r\n"
    "Connection: close" "\r\n"
    "Content-Type: application/x-www-form-urlencoded" "\r\n"
    "Content-Length: $D" "\r\n"
    "\r\n"
    "$H"),
  website, website, stash_size, sd);


  // send the packet - this also releases all stash buffers once done
  // Save the session ID so we can watch for it in the main loop.
  session = ether.tcpSend();
}

void setup () {
  // Front LEDs Setup
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  digitalWrite(6,HIGH);

  // Serial Setup
  Serial.begin(9600);
  Serial.println("\n[Twitter Client]");

  // Ethernet Setup
  if (ether.begin(sizeof Ethernet::buffer, mymac) == 0){ 
    Serial.println(F("Failed to access Ethernet controller"));
      while(true){
        digitalWrite(6,HIGH);
        delay(100);
        digitalWrite(6,LOW);
        delay(100);
      }
  }
  if (!ether.dhcpSetup()){
    Serial.println(F("DHCP failed"));
       while(true){
        digitalWrite(6,HIGH);
        delay(500);
        digitalWrite(6,LOW);
        delay(500);
      }
  }

  ether.printIp("IP:  ", ether.myip);
  ether.printIp("GW:  ", ether.gwip);  
  ether.printIp("DNS: ", ether.dnsip);  

  if (!ether.dnsLookup(website)){
    Serial.println(F("DNS failed"));
       while(true){
        digitalWrite(6,HIGH);
        delay(500);
        digitalWrite(6,LOW);
        delay(500);
      }
  }
  ether.printIp("SRV: ", ether.hisip);
  digitalWrite(6,LOW);
  digitalWrite(7,HIGH); // Everything's right, so turn on the green led :)

}

void loop () {
  ether.packetLoop(ether.packetReceive());

  //int tmp_light = 1023-((analogRead(A0)+analogRead(A1))/2);
  int tmp_sound = analogRead(A2);

  if (tmp_sound!=0){
    sound = tmp_sound;
  }

  
   if (millis() > timer) {
     timer = millis() + 15000; // Timer every 15 seconds
     sendToServer(); // Send TCP data to server
   }

  const char* reply = ether.tcpReply(session);
  if (reply != 0) {
    Serial.println("Got a response!");
    //Serial.println(reply);
  }
}

