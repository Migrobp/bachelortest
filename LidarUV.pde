public void getLidarData() {
  if (isOnRaspBerry) {
    // Check whether we are on raspberry pi to ensure GPIO pins.
    // Update Lidar distance every 500ms.
    int updateTime = 1000;
    if (ser.available() > 8) {
      int timePassed = (millis() - time1);
      if (timePassed > updateTime) {
        time1 = millis();
        byte[] recv = ser.readBytes(9);
        ser.clear();
        if (recv[0] == 'Y' && recv[1] == 'Y') { // 0x59 is 'Y'
          int low = recv[2] & 0xff;
          int high = recv[3] & 0xff;
          int distance = low + high * 256;
          lidarDistance = distance;
        }
      }
    }
  }
}



public void uvLight() {
  // Check whether we are on raspberry pi to ensure GPIO pins.
  // If on raspberry turn on UV light and set timer to stop after timeActive, then turn UV off again.
  if (true) {
    int uvLightTime = lidarDistance * 60;
    int updateTime = 1000 * uvLightTime;
    int oneSecond = 1000;
    int savedTime = 0;
    if (!UVLightON) {
      UVLightON = true;
      GPIO.digitalWrite(4, GPIO.HIGH);
      savedTime = millis();
    }
    while (UVLightON) {
      int timePassed = (millis() - savedTime);
      if (timePassed > updateTime) {
        UVLightON = false;
        GPIO.digitalWrite(4, GPIO.LOW);
      }
      if (timePassed > oneSecond) {
        savedTime = millis();
        time2++;
        updateBackground();
      }
    }
    if (!UVLightON && UVOnce) {
      println("HELLO");
      UVOnce = false;
      thread("projection");
    }
  }
}
