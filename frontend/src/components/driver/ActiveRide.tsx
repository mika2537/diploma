import { useState, useEffect } from "react";
import { MapView } from "../shared/MapView";
import { Button } from "../ui/button";
import { MessageCircle, AlertCircle, CheckCircle, Clock, Navigation } from "lucide-react";
import { projectId, publicAnonKey } from "../../utils/supabase/info";

interface ActiveRideProps {
  user: any;
  rideId: string;
  onComplete: () => void;
  onBack: () => void;
}

export function ActiveRide({ user, rideId, onComplete, onBack }: ActiveRideProps) {
  const [ride, setRide] = useState<any>(null);
  const [elapsed, setElapsed] = useState(0);
  const [distance, setDistance] = useState(0);

  useEffect(() => {
    loadRideData();
    const interval = setInterval(() => {
      setElapsed((prev) => prev + 1);
      updateGPS();
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
      }
    } catch (err) {
      console.error("Failed to load ride:", err);
    }
  };

  const updateGPS = async () => {
    // Simulate GPS update
    setDistance((prev) => prev + 0.1);
  };

  const handlePassengerSeated = async () => {
    try {
      const response = await fetch(
        `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/rides/${rideId}/seated`,
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${publicAnonKey}`,
          },
        }
      );

      if (response.ok) {
        alert("Зорчигч суусан гэж баталгаажлаа");
        loadRideData();
      }
    } catch (err) {
      console.error("Failed to update status:", err);
    }
  };

  const handleDropOff = async () => {
    try {
      const response = await fetch(
        `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/rides/${rideId}/complete`,
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${publicAnonKey}`,
          },
          body: JSON.stringify({
            distance,
            duration: elapsed,
          }),
        }
      );

      if (response.ok) {
        alert("Аялал амжилттай дууслаа!");
        onComplete();
      }
    } catch (err) {
      console.error("Failed to complete ride:", err);
    }
  };

  const handleChat = () => {
    alert("Чат функц удахгүй нэмэгдэнэ");
  };

  const handleCancel = async () => {
    if (confirm("Та энэ аяллыг цуцлахдаа итгэлтэй байна уу?")) {
      try {
        const response = await fetch(
          `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/rides/${rideId}/cancel`,
          {
            method: "PUT",
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${publicAnonKey}`,
            },
          }
        );

        if (response.ok) {
          alert("Аялал цуцлагдлаа");
          onBack();
        }
      } catch (err) {
        console.error("Failed to cancel ride:", err);
      }
    }
  };

  if (!ride) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-muted-foreground">Уншиж байна...</p>
      </div>
    );
  }

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, "0")}`;
  };

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

        {/* Trip Info Overlay */}
        <div className="absolute top-6 left-4 right-4 bg-card/95 backdrop-blur rounded-2xl p-4 shadow-lg">
          <div className="flex items-center justify-between mb-3">
            <div>
              <h3>{ride.passengerName}</h3>
              <p className="text-sm text-muted-foreground">{ride.vehicleModel || "Toyota Prius"}</p>
            </div>
            <div
              className={`px-3 py-1 rounded-full text-xs ${
                ride.status === "seated"
                  ? "bg-secondary/20 text-secondary"
                  : "bg-primary/20 text-primary"
              }`}
            >
              {ride.status === "seated" ? "Зорчигч суусан" : "Очиж байна"}
            </div>
          </div>

          <div className="grid grid-cols-3 gap-4 text-center">
            <div>
              <div className="flex items-center justify-center gap-1 text-muted-foreground mb-1">
                <Clock className="w-4 h-4" />
              </div>
              <p className="text-sm">{formatTime(elapsed)}</p>
              <p className="text-xs text-muted-foreground">Хугацаа</p>
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
      </div>

      {/* Bottom Actions */}
      <div className="bg-card border-t border-border p-4 space-y-3">
        {ride.status !== "seated" && (
          <Button
            onClick={handlePassengerSeated}
            className="w-full bg-secondary hover:bg-secondary/90"
          >
            <CheckCircle className="w-5 h-5 mr-2" />
            Зорчигч суусан
          </Button>
        )}

        {ride.status === "seated" && (
          <Button onClick={handleDropOff} className="w-full bg-primary hover:bg-primary/90">
            <CheckCircle className="w-5 h-5 mr-2" />
            Буулгах
          </Button>
        )}

        <div className="grid grid-cols-2 gap-3">
          <Button onClick={handleChat} variant="outline">
            <MessageCircle className="w-5 h-5 mr-2" />
            Чат
          </Button>

          <Button onClick={handleCancel} variant="outline" className="border-destructive text-destructive">
            <AlertCircle className="w-5 h-5 mr-2" />
            Цуцлах
          </Button>
        </div>
      </div>
    </div>
  );
}
