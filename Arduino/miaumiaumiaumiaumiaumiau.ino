// Dreams client sketch for ENC28J60 based Ethernet Shield.
// Author: Henry Lopez del Pino - henry.lopez@mail.udp.cl
// Based in Twitter Client for ENC28J60 from EtherCard.h Examples

#include <EtherCard.h>

// ethernet interface mac address, must be unique on the LAN
byte mymac[] = { 0x74,0x69,0x69,0x2D,0x30,0x31 };

const char website[] PROGMEM = "dreams.cuy.cl";

static byte session;

byte Ethernet::buffer[700];
Stash stash;
uint32_t timer;

static void sendToServer () {
  Serial.println("Sending Data to Server...");
  byte sd = stash.create();

  // Creating random values TEMPORARILY
  int light = random(1023);
  int sound = random(1023);
  int temp = random(50);
  int humid = random(100);
  
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
  Serial.begin(9600);
  Serial.println("\n[Twitter Client]");

  if (ether.begin(sizeof Ethernet::buffer, mymac) == 0) 
    Serial.println(F("Failed to access Ethernet controller"));
  if (!ether.dhcpSetup())
    Serial.println(F("DHCP failed"));

  ether.printIp("IP:  ", ether.myip);
  ether.printIp("GW:  ", ether.gwip);  
  ether.printIp("DNS: ", ether.dnsip);  

  if (!ether.dnsLookup(website))
    Serial.println(F("DNS failed"));

  ether.printIp("SRV: ", ether.hisip);

  // RANDOM
  randomSeed(analogRead(A5));

}

void loop () {
  ether.packetLoop(ether.packetReceive());
  
   if (millis() > timer) {
     timer = millis() + 15000; // Timer every 15 seconds
     sendToServer(); // Send TCP data to server
   }

  const char* reply = ether.tcpReply(session);
  if (reply != 0) {
    Serial.println("Got a response!");
    Serial.println(reply);
  }
}

