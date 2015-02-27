/*int led = D0;
int led2 = D7;
unsigned int localPort = 8888;
UDP Udp;

SYSTEM_MODE(MANUAL);

void setup() {

  pinMode(led, OUTPUT);
  pinMode(led2, OUTPUT);
  WiFi.connect();
  //Udp.begin(localPort);
  Serial.begin(9600);
  Serial.println(WiFi.localIP());
}

void loop() {

  //IPAddress ipAddress = Udp.remoteIP();
  //int port = Udp.remotePort();

  //Udp.beginPacket(ipAddress, port);
  //Udp.write("test");
  //Udp.endPacket();

  digitalWrite(led,HIGH);
  digitalWrite(led2, HIGH);
  delay(250);
  digitalWrite(led, LOW);
  digitalWrite(led2, LOW);
  delay(250);
}*/
