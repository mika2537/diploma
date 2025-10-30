import { useState, useEffect } from "react";
import { Bell, DollarSign, Car, TrendingUp } from "lucide-react";
import { useJsApiLoader, GoogleMap, Marker } from "@react-google-maps/api";

interface DriverDashboardProps {
  user: any;
  onMakeRoute: () => void;
  onViewRequests: () => void;
}

export function DriverDashboard({
  user,
  onMakeRoute,
  onViewRequests,
}: DriverDashboardProps) {
  const [stats, setStats] = useState({
    todayRides: 0,
    todayIncome: 0,
    activeRides: 0,
    totalIncome: 0,
  });
  const [notifications, setNotifications] = useState<any[]>([]);
  const [location, setLocation] = useState<{ lat: number; lng: number } | null>(
    null
  );

  useEffect(() => {
    loadDashboardData();
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setLocation({
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          });
        },
        () => {
          setLocation({ lat: 47.9191, lng: 106.917 }); // Default location if permission denied (Ulaanbaatar)
        }
      );
    } else {
      setLocation({ lat: 47.9191, lng: 106.917 }); // Default location if geolocation not supported
    }
  }, [user.id]);

  const loadDashboardData = async () => {
    try {
      const response = await fetch(
        `http://localhost:5050/api/driver/dashboard?userId=${user.id}`
      );

      if (response.ok) {
        const data = await response.json();
        setStats(data.stats || stats);
        setNotifications(data.notifications || []);
      }
    } catch (err) {
      console.error("Failed to load dashboard:", err);
    }
  };
  const { isLoaded, loadError } = useJsApiLoader({
    googleMapsApiKey: import.meta.env.VITE_GOOGLE_MAPS_API_KEY || "",
  });

  return (
    <div className="pb-20 px-4 pt-6 max-w-md mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h2>Сайн байна уу,</h2>
          <p className="text-muted-foreground">{user.name}</p>
        </div>
        <button className="relative p-2 rounded-full bg-accent hover:bg-accent/80 transition-colors">
          <Bell className="w-6 h-6" />
          {notifications.length > 0 && (
            <span className="absolute top-0 right-0 w-5 h-5 bg-destructive text-destructive-foreground rounded-full text-xs flex items-center justify-center">
              {notifications.length}
            </span>
          )}
        </button>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-2 gap-4 mb-6">
        <div className="bg-gradient-to-br from-primary to-primary/80 text-primary-foreground rounded-2xl p-4">
          <div className="flex items-center gap-2 mb-2">
            <Car className="w-5 h-5" />
            <span className="text-sm opacity-90">Өнөөдрийн аялал</span>
          </div>
          <p className="text-3xl">{stats.todayRides}</p>
        </div>

        <div className="bg-gradient-to-br from-secondary to-secondary/80 text-secondary-foreground rounded-2xl p-4">
          <div className="flex items-center gap-2 mb-2">
            <DollarSign className="w-5 h-5" />
            <span className="text-sm opacity-90">Өнөөдрийн орлого</span>
          </div>
          <p className="text-3xl">{stats.todayIncome.toLocaleString()}₮</p>
        </div>

        <div className="bg-card border border-border rounded-2xl p-4">
          <div className="flex items-center gap-2 mb-2">
            <TrendingUp className="w-5 h-5 text-primary" />
            <span className="text-sm text-muted-foreground">
              Идэвхтэй аялал
            </span>
          </div>
          <p className="text-3xl">{stats.activeRides}</p>
        </div>

        <div className="bg-card border border-border rounded-2xl p-4">
          <div className="flex items-center gap-2 mb-2">
            <DollarSign className="w-5 h-5 text-secondary" />
            <span className="text-sm text-muted-foreground">Нийт орлого</span>
          </div>
          <p className="text-3xl">{(stats.totalIncome / 1000).toFixed(0)}k₮</p>
        </div>
      </div>

      {/* Map Preview */}
      <div className="mb-6">
        <h3 className="mb-3">Таны байршил</h3>

        <div className="w-full h-48 rounded-lg overflow-hidden relative bg-card border border-border flex items-center justify-center">
          {loadError && (
            <p className="text-sm text-red-500 px-4 text-center">
              ❌ Газрын зураг ачаалагдсангүй:{" "}
              {String(loadError.message || loadError)}
            </p>
          )}

          {!isLoaded && !loadError && (
            <p className="text-sm text-muted-foreground text-center">
              Газрын зураг ачаалж байна...
            </p>
          )}

          {isLoaded && location && (
            <GoogleMap
              mapContainerStyle={{ width: "100%", height: "100%" }}
              center={location}
              zoom={14}
              options={{
                disableDefaultUI: true,
                zoomControl: true,
                mapTypeControl: false,
                streetViewControl: false,
              }}
            >
              <Marker position={location} />
            </GoogleMap>
          )}
        </div>
      </div>

      {/* Quick Actions */}
      <div className="space-y-3">
        <button
          onClick={onMakeRoute}
          className="w-full bg-primary text-primary-foreground rounded-2xl p-4 flex items-center justify-between hover:opacity-90 transition-opacity"
        >
          <span>Маршрут үүсгэх</span>
          <Car className="w-6 h-6" />
        </button>

        <button
          onClick={onViewRequests}
          className="w-full bg-card border border-border rounded-2xl p-4 flex items-center justify-between hover:bg-accent transition-colors"
        >
          <div className="text-left">
            <p>Хүсэлтүүд үзэх</p>
            <p className="text-sm text-muted-foreground">
              {notifications.length} шинэ хүсэлт
            </p>
          </div>
          <Bell className="w-6 h-6" />
        </button>
      </div>

      {/* Recent Notifications */}
      {notifications.length > 0 && (
        <div className="mt-6">
          <h3 className="mb-3">Сүүлийн мэдэгдлүүд</h3>
          <div className="space-y-2">
            {notifications.slice(0, 3).map((notif: any, idx: number) => (
              <div
                key={idx}
                className="bg-card border border-border rounded-xl p-3 flex items-start gap-3"
              >
                <div className="w-2 h-2 bg-primary rounded-full mt-2" />
                <div className="flex-1">
                  <p className="text-sm">{notif.message}</p>
                  <p className="text-xs text-muted-foreground mt-1">
                    {notif.time}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
