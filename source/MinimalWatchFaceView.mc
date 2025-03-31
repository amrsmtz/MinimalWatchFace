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

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {}

  // Update the view
  function onUpdate(dc as Dc) as Void {
    // Get and show the current time
    var clockTime = System.getClockTime();
    var timeString = Lang.format("$1$:$2$", [
      clockTime.hour,
      clockTime.min.format("%02d"),
    ]);
    var clockView = View.findDrawableById("TimeLabel") as Text;
    clockView.setText(timeString);

    // Get and show the current date
    var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    var dateString = Lang.format("$1$ $2$ $3$", [
      today.day_of_week,
      today.day,
      today.month
    ]);
    var dateView = View.findDrawableById("DateLabel") as Text;
    dateView.setText(dateString);

    // Get the temperature
    var currentConditions = Weather.CurrentConditions;
    var temperature = "000";
    var unit = "0";
    if (currentConditions != null && currentConditions.temperature != null) {     
      if (System.getDeviceSettings().temperatureUnits == 0) {  
        unit = "°C";
        temperature = currentConditions.temperature.format("%d");
      } else {
        temperature = (((currentConditions.temperature*9)/5)+32).format("%d"); 
        unit = "°F";   
      }}
    else {
      temperature = "000";
    }
    var tempView = View.findDrawableById("TemperatureLabel") as Text;
    tempView.setText(temperature + " " + unit);

    // Get the battery level
    var systemStats = System.getSystemStats();
    var batteryString = "000";
    if (systemStats.battery != null){batteryString = Lang.format("$1$%",[((systemStats.battery.toNumber())).format("%02d")]);}else{batteryString="000";}
    var batteryView = View.findDrawableById("BatteryLabel") as Text;
    batteryView.setText(batteryString);

    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {}

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() as Void {}

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() as Void {}
}
