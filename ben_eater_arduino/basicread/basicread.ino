char ADDR[16]; // init address array
char DATA [8];
#define CLOCK 2
#define READ_WRITE 3

void setup() {
  Serial.begin(57600);

  for (int i = 0; i < 16; i++) { // set up ADD pins
    int a = 22 + 2*i;
    ADDR[i] = a;
    pinMode (a, INPUT);
  }

  for (int i = 0; i < 8; i++) { // set up DATA pins
    int b = 37 + 2*i;
    DATA[i] = b;
    pinMode (b, INPUT);
  }

  pinMode(CLOCK, INPUT);
  pinMode(READ_WRITE, INPUT);

  attachInterrupt(digitalPinToInterrupt(CLOCK), onClock, RISING);
}

void onClock() {

  unsigned int address = 0;
  for (int n = 0; n < 16; n++){
    int bit = digitalRead(ADDR[n]) ? 1 : 0;
    Serial.print(bit);
    address = (address << 1) + bit;
  }
  
  Serial.print(" ");
  char output[15];

  unsigned int data = 0;
  for (int n = 0; n < 8; n++){
    int bit = digitalRead(DATA[n]) ? 1 : 0;
    Serial.print(bit);
    data = (data << 1) + bit;

  }
  sprintf(output, "  %04x %c %02x", address, digitalRead(READ_WRITE)? 'R' : 'W', data);
  Serial.println(output);

}

void loop() {
}
