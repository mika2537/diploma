import { useState, useEffect } from "react";
import { MapView } from "../shared/MapView";
import { Button } from "../ui/button";
import { MessageCircle, AlertCircle, Clock, Navigation, User } from "lucide-react";
import { projectId, publicAnonKey } from "../../utils/supabase/info";

interface LiveTripProps {
  user: any;
  rideId: string;
  onComplete: () => void;
}

export function LiveTrip({ user, rideId, onComplete }: LiveTripProps) {
  const [ride, setRide] = useState<any>(null);
  const [eta, setEta] = useState(25);
  const [distance, setDistance] = useState(0);

  useEffect(() => {
    loadRideData();
    const interval = setInterval(() => {
      updateLocation();
      setEta((prev) => Math.max(0, prev - 1));
    }, 5000); // Update every 5 seconds

    return () => clearInterval(interval);
  }, [rideId]);

  const loadRideData = async () => {
    try {
      const response = await fetch(
        `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/rides/${rideId}`,
        {
          headers: {
            Authorization: `Bearer ${publicAnonKey}`,
          },
        }
      );

      if (response.ok) {
        const data = await response.json();
        setRide(data.ride);
        setDistance(data.ride.distance || 0);
        setEta(data.ride.eta || 25);
      }
    } catch (err) {
      console.error("Failed to load ride:", err);
    }
  };

  const updateLocation = () => {
    // Simulate GPS update
    setDistance((prev) => prev + 0.1);
  };

  const handleChat = () => {
    alert("Чат функц удахгүй нэмэгдэнэ");
  };

  const handleEmergency = () => {
    if (confirm("Та яаралтай тусламж дуудах уу?")) {
      alert("SOS дуудлага илгээгдлээ");
    }
  };

  if (!ride) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-muted-foreground">Уншиж байна...</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen flex flex-col">
      {/* Map - Full height */}
      <div className="flex-1 relative">
        <MapView
          height="h-full"
          showRoute
          startPoint={{ lat: 47.92, lng: 106.91, label: ride.pickupPoint }}
          endPoint={{ lat: 47.91, lng: 106.93, label: ride.dropoffPoint }}
          currentLocation={{ lat: 47.915, lng: 106.92 }}
        />

        {/* Driver Info Overlay */}
        <div className="absolute top-6 left-4 right-4 bg-card/95 backdrop-blur rounded-2xl p-4 shadow-lg">
          <div className="flex items-center gap-3 mb-3">
            <div className="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center">
              <User className="w-6 h-6 text-primary" />
            </div>
            <div className="flex-1">
              <h4>{ride.driverName || "Жолооч"}</h4>
              <p className="text-sm text-muted-foreground">
                {ride.vehicleModel || "Toyota Prius"} • {ride.vehiclePlate || "УБ 1234"}
              </p>
            </div>
            <div
              className={`px-3 py-1 rounded-full text-xs ${
                ride.status === "in_progress"
                  ? "bg-secondary/20 text-secondary"
                  : "bg-primary/20 text-primary"
              }`}
            >
              {ride.status === "in_progress" ? "Зам дээр" : "Очиж байна"}
            </div>
          </div>

          <div className="grid grid-cols-3 gap-4 text-center">
            <div>
              <div className="flex items-center justify-center gap-1 text-muted-foreground mb-1">
                <Clock className="w-4 h-4" />
              </div>
              <p className="text-sm">{eta} мин</p>
              <p className="text-xs text-muted-foreground">Хүрэх хугацаа</p>
            </div>
            <div>
              <div className="flex items-center justify-center gap-1 text-muted-foreground mb-1">
                <Navigation className="w-4 h-4" />
              </div>
              <p className="text-sm">{distance.toFixed(1)} км</p>
              <p className="text-xs text-muted-foreground">Зай</p>
            </div>
            <div>
              <div className="flex items-center justify-center gap-1 text-muted-foreground mb-1">
                💰
              </div>
              <p className="text-sm">{ride.fare || 5000}₮</p>
              <p className="text-xs text-muted-foreground">Үнэ</p>
            </div>
          </div>
        </div>

        {/* Status Message */}
        {ride.status === "arriving" && (
          <div className="absolute top-32 left-4 right-4 bg-primary text-primary-foreground rounded-xl p-3 shadow-lg">
            <p className="text-center">
              Жолооч таны байршил руу ойртож байна • {eta} мин
            </p>
          </div>
        )}
      </div>

      {/* Bottom Actions */}
      <div className="bg-card border-t border-border p-4 space-y-3">
        <div className="grid grid-cols-2 gap-3">
          <Button onClick={handleChat} variant="outline">
            <MessageCircle className="w-5 h-5 mr-2" />
            Чат
          </Button>

          <Button
            onClick={handleEmergency}
            variant="outline"
            className="border-destructive text-destructive hover:bg-destructive hover:text-destructive-foreground"
          >
            <AlertCircle className="w-5 h-5 mr-2" />
            Яаралтай (SOS)
          </Button>
        </div>

        {/* Driver Contact */}
        <div className="bg-accent/50 rounded-xl p-3 flex items-center justify-between">
          <div>
            <p className="text-sm text-muted-foreground">Жолоочтой холбогдох</p>
            <p>{ride.driverPhone || "+976 9999 9999"}</p>
          </div>
          <Button size="sm" variant="outline">
            Залгах
          </Button>
        </div>
      </div>
    </div>
  );
}
