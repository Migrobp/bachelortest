void getDistance() {
  while (port.available() > 0) {
   int distance = port.read();
   println(distance);
  }
}
