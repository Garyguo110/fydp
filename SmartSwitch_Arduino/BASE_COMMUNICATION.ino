int input1 = D1;
int power = D7;
int output1 = D0;
int switchDriver = D2;
int groupMemAddress = 1;
int stateMemAddress = 80;

int count = 0;
int lightState = 0;
int switchState = 0;

char state[10];
char groupId[500];
char a[1];

void setup() {
  Spark.variable("lightState", &lightState, INT);
  Spark.variable("switchState", &switchState, INT);
  Spark.variable("state", state, STRING);
  Spark.variable("groupId", groupId, STRING);
  Spark.variable("a", a, STRING);

  Spark.function("setState", setState);
  Spark.function("setCores", setCores);
  Spark.function("flipLight", flipLight);

  Spark.subscribe("flip_switch", switchHandler);

  pinMode(input1, INPUT);
  pinMode(output1, OUTPUT);
  pinMode(power, OUTPUT);
  pinMode(switchDriver, OUTPUT);

  digitalWrite(switchDriver, HIGH);

  EEPROM.write(0, '|');
}

void loop() {
  String s = state;
  if(s == "SWITCH" && switchState == 0 && digitalRead(input1) == HIGH ) {
    Spark.publish("flip_switch", groupId);
    switchState = 1;
    digitalWrite(power, HIGH);
    delay(250);
  }
  if(s == "SWITCH" && switchState == 1 && digitalRead(input1) == LOW ) {
    Spark.publish("flip_switch", groupId);
    switchState = 0;
    digitalWrite(power, LOW);
    delay(250);
  }
}

int setState(String command)
{
  if( command == "SWITCH" || command == "LIGHT" ) {
    strcpy(state, command.c_str());
    for(int i = 0; i < strlen(state); i++) {
      EEPROM.write(stateMemAddress + i, state[i]);
    }
    EEPROM.write(stateMemAddress + strlen(state), '\0');
    return 1;
  }
  else return -1;
}

int setCores(String command)
{
  strcpy(groupId, command.c_str());
  for(int i = 0; i < strlen(groupId); i++) {
    EEPROM.write(groupMemAddress + i, groupId[i]);
  }
  EEPROM.write(groupMemAddress + strlen(groupId), '\0');
  return 1;
}

int flipLight(String command)
{
  String st = state;
  if(command == "TOGGLE") {
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
  } else if (command == "OFF") {
    if(lightState == 1) {
      digitalWrite(power, LOW);
      digitalWrite(output1, LOW);
      lightState = 0;
    }
  } else if (command == "ON") {
    if(lightState ==  0) {
      digitalWrite(power, HIGH);
      digitalWrite(power, LOW);
    }
  } else return -1;
}

void switchHandler(const char *event, const char *data) {
  String s = state;
  if(groupId[0] != '\0' && s == "LIGHT" && strstr(data, groupId) != NULL )
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
