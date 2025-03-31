import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;
import Toybox.Weather;

class MinimalWatchFaceView extends WatchUi.WatchFace {
  
  function initialize() {
    WatchFace.initialize();
  }

  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));
  }

  function onShow() as Void {}

  function onUpdate(dc as Dc) as Void {
    updateTime();
    updateDate();
    updateTemperature();
    updateBattery();
    View.onUpdate(dc); // Call parent function to redraw the layout
  }

  function onHide() as Void {}

  function onExitSleep() as Void {}

  function onEnterSleep() as Void {}

  private function updateTime() as Void {
    var clockTime = System.getClockTime();
    var timeString = Lang.format("$1$:$2$", [
      clockTime.hour,
      clockTime.min.format("%02d"),
    ]);
    var clockView = View.findDrawableById("TimeLabel") as Text;
    clockView.setText(timeString);
  }

  private function updateDate() as Void {
    var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    var dateString = Lang.format("$1$ $2$ $3$", [
      today.day_of_week,
      today.day,
      today.month,
    ]);
    var dateView = View.findDrawableById("DateLabel") as Text;
    dateView.setText(dateString);
  }

  private function updateTemperature() as Void {
    var currentConditions = Weather.CurrentConditions;
    var temperature = "000";
    var unit = "°C";

    if (currentConditions != null && currentConditions.temperature != null) {
      if (System.getDeviceSettings().temperatureUnits == 0) {
        temperature = currentConditions.temperature.format("%d");
      } else {
        temperature = (((currentConditions.temperature * 9) / 5) + 32).format("%d");
        unit = "°F";
      }
    }

    var tempView = View.findDrawableById("TemperatureLabel") as Text;
    tempView.setText(temperature + " " + unit);
  }

  private function updateBattery() as Void {
    var systemStats = System.getSystemStats();
    var batteryString = "000";

    if (systemStats.battery != null) {
      batteryString = Lang.format("$1$%", [
        systemStats.battery.toNumber().format("%02d"),
      ]);
    }

    var batteryView = View.findDrawableById("BatteryLabel") as Text;
    batteryView.setText(batteryString);
  }
}
