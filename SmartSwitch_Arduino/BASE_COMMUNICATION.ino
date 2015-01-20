int input1 = D1;
int power = D7;
int output1 = D0;

int count = 0;
int lightState = 0;
int switchState = 0;

char state[10];
char pairedCores[500];

void setup() {
  Spark.variable("lightState", &lightState, INT);
  Spark.variable("switchState", &switchState, INT);
  Spark.variable("state", state, STRING);
  Spark.variable("pairedCores", pairedCores, STRING);

  Spark.function("setState", setState);
  Spark.function("setCores", setCores);
  Spark.function("flipLight", flipLight);

  Spark.subscribe("flip_switch", switchHandler);

  pinMode(input1, INPUT);
  pinMode(output1, OUTPUT);
  pinMode(power, OUTPUT);

}

void loop() {
  String s = state;
  if(s == "SWITCH" && switchState == 0 && digitalRead(input1) == HIGH ) {
    Spark.publish("flip_switch", pairedCores);
    switchState = 1;
    digitalWrite(power, HIGH);
    delay(1000);
  }
  if(s == "SWITCH" && switchState == 1 && digitalRead(input1) == LOW ) {
    Spark.publish("flip_switch", pairedCores);
    switchState = 0;
    digitalWrite(power, LOW);
    delay(1000);
  }
}

int setState(String command)
{
  if( command == "SWITCH" || command == "LIGHT" ) {
    strcpy(state, command.c_str());
    return 1;
  }
  else return -1;
}

int setCores(String command)
{
  strcpy(pairedCores, command.c_str());
  return 1;
}

int flipLight(String command)
{
  String st = state;
  if( st == "LIGHT") {
    if( lightState == 0 ){
      digitalWrite(power, HIGH);
      digitalWrite(output1, HIGH);
      lightState = 1;
    }
    else {
      digitalWrite(power, LOW);
      digitalWrite(output1, LOW);
      lightState = 0;
    }
    return 1;
  }
  else return -1;
}

void switchHandler(const char *event, const char *data) {
  String s = state;
  if( s == "LIGHT" && strstr(data, Spark.deviceID().c_str()) != NULL )
  {
    if( lightState == 0 ){
      digitalWrite(power, HIGH);
      digitalWrite(output1, HIGH);
      lightState = 1;
    }
    else {
      digitalWrite(power, LOW);
      digitalWrite(output1, LOW);
      lightState = 0;
    }
  }
}
