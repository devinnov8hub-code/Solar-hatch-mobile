const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

/**
 * Cloud Function triggered on RTDB `/test` changes.
 * Monitors telemetry and sends push notifications (FCM) and in-app alerts
 * for motor turn events, temperature/humidity warnings, and connectivity changes.
 */
exports.onIncubatorDataChange = functions.database
  .ref("/test")
  .onWrite(async (change, context) => {
    // Exit if data was deleted
    if (!change.after.exists()) {
      return null;
    }

    const beforeData = change.before.exists() ? change.before.val() : {};
    const afterData = change.after.val();

    const alertsToSend = [];

    // 1. Motor Turn Alert
    // Triggers when motorTurned changes to 1 (egg turning engaged / completed)
    if (afterData.motorTurned === 1 && beforeData.motorTurned !== 1) {
      alertsToSend.push({
        title: "Egg Turning Cycle Completed",
        description: `Automated motor turn finished on Day ${afterData.currentIncubationDay || 0}.`,
        iconType: "motor",
        type: "motor",
      });
    }

    // 2. Turn Stop Alert (Lockdown phase or manual stop)
    if (afterData.turnStop === 1 && beforeData.turnStop !== 1) {
      alertsToSend.push({
        title: "Egg Turning Stopped",
        description: "Egg turning has been stopped for the hatching lockdown phase.",
        iconType: "motor",
        type: "motor_stop",
      });
    }

    // 3. Temperature Warning (deviation > 1.0°C from setpoint)
    if (
      typeof afterData.temperature === "number" &&
      typeof afterData.setTemperature === "number"
    ) {
      const tempDiff = Math.abs(afterData.temperature - afterData.setTemperature);
      const prevDiff =
        beforeData.temperature && beforeData.setTemperature
          ? Math.abs(beforeData.temperature - beforeData.setTemperature)
          : 0;

      if (tempDiff > 1.0 && prevDiff <= 1.0) {
        alertsToSend.push({
          title: "Temperature Warning",
          description: `Chamber temp is ${afterData.temperature}°C (Target: ${afterData.setTemperature}°C).`,
          iconType: "temperature",
          type: "temperature",
        });
      }
    }

    // 4. Humidity Warning (deviation > 5.0%RH from setpoint)
    if (
      typeof afterData.humidity === "number" &&
      typeof afterData.setHumidity === "number"
    ) {
      const humDiff = Math.abs(afterData.humidity - afterData.setHumidity);
      const prevHumDiff =
        beforeData.humidity && beforeData.setHumidity
          ? Math.abs(beforeData.humidity - beforeData.setHumidity)
          : 0;

      if (humDiff > 5.0 && prevHumDiff <= 5.0) {
        alertsToSend.push({
          title: "Humidity Warning",
          description: `Chamber humidity is ${afterData.humidity}%RH (Target: ${afterData.setHumidity}%RH).`,
          iconType: "humidifier",
          type: "humidifier",
        });
      }
    }

    // 5. Hardware Wi-Fi Disconnected Warning
    if (afterData.wifiStatus === 0 && beforeData.wifiStatus === 1) {
      alertsToSend.push({
        title: "Incubator Offline",
        description: "Hardware Wi-Fi module disconnected from the cloud.",
        iconType: "system",
        type: "system",
      });
    }

    if (alertsToSend.length === 0) {
      return null;
    }

    // Fetch registered device FCM tokens
    const tokensSnapshot = await admin.database().ref("/fcmTokens").once("value");
    const tokensMap = tokensSnapshot.val() || {};
    const tokens = Object.keys(tokensMap).filter(Boolean);

    const now = new Date();
    const timeString = now.toLocaleTimeString("en-US", {
      hour: "2-digit",
      minute: "2-digit",
      hour12: true,
    });

    for (const alert of alertsToSend) {
      // 1. Write to RTDB `/alerts` for in-app NotificationsView list
      await admin.database().ref("/alerts").push({
        title: alert.title,
        description: alert.description,
        time: timeString,
        isUnread: true,
        iconType: alert.iconType,
        createdAt: admin.database.ServerValue.TIMESTAMP,
      });

      // 2. Broadcast push notification to all devices
      if (tokens.length > 0) {
        const messagePayload = {
          tokens: tokens,
          notification: {
            title: alert.title,
            body: alert.description,
          },
          data: {
            click_action: "FLUTTER_NOTIFICATION_CLICK",
            type: alert.type,
            motorTurned: String(afterData.motorTurned ?? 0),
            turnInterval: String(afterData.turnInterval ?? 2),
            turnStop: String(afterData.turnStop ?? 0),
            temperature: String(afterData.temperature ?? 0),
            humidity: String(afterData.humidity ?? 0),
            currentIncubationDay: String(afterData.currentIncubationDay ?? 0),
          },
        };

        try {
          const response = await admin.messaging().sendEachForMulticast(messagePayload);
          console.log(`Sent notification "${alert.title}" successfully: ${response.successCount} succeeded, ${response.failureCount} failed.`);

          // Clean up invalid or expired tokens
          if (response.failureCount > 0) {
            const tokensToRemove = [];
            response.responses.forEach((resp, idx) => {
              if (!resp.success) {
                const errorCode = resp.error ? resp.error.code : "";
                if (
                  errorCode === "messaging/invalid-registration-token" ||
                  errorCode === "messaging/registration-token-not-registered"
                ) {
                  tokensToRemove.push(tokens[idx]);
                }
              }
            });

            await Promise.all(
              tokensToRemove.map((t) => admin.database().ref(`/fcmTokens/${t}`).remove())
            );
          }
        } catch (error) {
          console.error("Error sending FCM multicast notification:", error);
        }
      }
    }

    return null;
  });
