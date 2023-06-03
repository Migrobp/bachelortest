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
          lidarDistance = distance + 3;
          uvLightTime = 600 + ((int)lidarDistance * 60)/10;
          println("Distance: " + lidarDistance);
        }
      }
    }
  }
}



public void uvLight() {
  // Check whether we are on raspberry pi to ensure GPIO pins.
  // If on raspberry turn on UV light and set timer to stop after timeActive, then turn UV off again.
  int updateTime = uvLightTime;
  int oneSecond = 1000;
  int savedTime = 0;
  projectorScreen.setProject(false);
  if (!UVLightON) {
    UVLightON = true;
    GPIO.digitalWrite(4, GPIO.HIGH);
    savedTime = millis();
  }
  while(UVLightON) {
    int timePassed = (millis() - savedTime);
    if (timePassed >= oneSecond) {
      savedTime += oneSecond;
    } else {
      long sleepTime = oneSecond - timePassed;
      //println(sleepTime);
      try {
        Thread.sleep(sleepTime);
      }
      catch(InterruptedException e) {
        println("Got interrupted!");
      }
    }
    savedTime = millis();
    time2++;
    updateBackground();
    isNew = true;
    if (time2 >= updateTime) {
      UVLightON = false;
      GPIO.digitalWrite(4, GPIO.LOW);
      thread("projection");
    }
  }
}
