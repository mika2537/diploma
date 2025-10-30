import { useState, useEffect } from "react";
import { MapView } from "../shared/MapView";
import { Search, Clock, TrendingUp, Bell } from "lucide-react";
import { API_BASE_URL } from "../../utils/api";

interface PassengerDashboardProps {
  user?: any;
  onFindRoute: () => void;
}

export function PassengerDashboard({
  user,
  onFindRoute,
}: PassengerDashboardProps) {
  const [storedUser, setStoredUser] = useState<any>(user || null);
  const [availableRoutes, setAvailableRoutes] = useState<any[]>([]);
  const [stats, setStats] = useState({ totalRides: 0, totalSpent: 0 });
  const [loading, setLoading] = useState(true);

  // ✅ Load user from localStorage if not passed from props
  useEffect(() => {
    if (!user) {
      const localUser = localStorage.getItem("user");
      if (localUser) {
        setStoredUser(JSON.parse(localUser));
      }
    }
  }, [user]);

  // ✅ Once user is known, load dashboard data from MongoDB
  useEffect(() => {
    if (storedUser?.id) {
      loadDashboardData(storedUser.id);
    }
  }, [storedUser?.id]);

  const loadDashboardData = async (userId: string) => {
    setLoading(true);
    try {
      const token = localStorage.getItem("token");
      const response = await fetch(
        `${API_BASE_URL}/passenger/dashboard?userId=${userId}`,
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
        }
      );

      if (!response.ok) {
        console.error("❌ Server Error:", response.statusText);
        return;
      }

      const data = await response.json();
      setAvailableRoutes(data.nearbyRoutes || []);
      setStats(data.stats || { totalRides: 0, totalSpent: 0 });
    } catch (err) {
      console.error("❌ Failed to load dashboard:", err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="pb-20 px-4 pt-6 max-w-md mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h2 className="text-lg font-semibold">Сайн байна уу,</h2>
          <p className="text-muted-foreground">
            {storedUser?.name || "Хэрэглэгч"}
          </p>
        </div>
        <button className="relative p-2 rounded-full bg-accent hover:bg-accent/80 transition-colors">
          <Bell className="w-6 h-6" />
        </button>
      </div>

      {/* Search Card */}
      <button
        onClick={onFindRoute}
        className="w-full bg-gradient-to-r from-primary to-primary/80 text-primary-foreground rounded-2xl p-6 mb-6 text-left hover:opacity-90 transition-opacity"
      >
        <div className="flex items-center gap-3 mb-2">
          <Search className="w-6 h-6" />
          <h3 className="text-white font-medium">Маршрут хайх</h3>
        </div>
        <p className="text-sm opacity-90">Хаашаа явах гэж байна?</p>
      </button>

      {/* Stats Section */}
      {loading ? (
        <p className="text-center text-muted-foreground mb-6">Уншиж байна...</p>
      ) : (
        <div className="grid grid-cols-2 gap-4 mb-6">
          <div className="bg-card border border-border rounded-2xl p-4">
            <div className="flex items-center gap-2 mb-2">
              <TrendingUp className="w-5 h-5 text-primary" />
              <span className="text-sm text-muted-foreground">Нийт аялал</span>
            </div>
            <p className="text-3xl font-semibold">{stats.totalRides}</p>
          </div>

          <div className="bg-card border border-border rounded-2xl p-4">
            <div className="flex items-center gap-2 mb-2">
              <span className="text-xl">💰</span>
              <span className="text-sm text-muted-foreground">Нийт зардал</span>
            </div>
            <p className="text-3xl font-semibold">
              {(stats.totalSpent / 1000).toFixed(0)}k₮
            </p>
          </div>
        </div>
      )}

      {/* Map Section */}
      <div className="mb-6">
        <h3 className="mb-3 font-medium">Таны байршил</h3>
        <MapView height="h-48" />
      </div>

      {/* Nearby Routes */}
      <div>
        <div className="flex items-center justify-between mb-3">
          <h3 className="font-medium">Ойролцоох маршрутууд</h3>
          <button
            onClick={onFindRoute}
            className="text-sm text-primary hover:underline"
          >
            Бүгдийг харах
          </button>
        </div>

        {loading ? (
          <p className="text-center text-muted-foreground">Ачаалж байна...</p>
        ) : availableRoutes.length === 0 ? (
          <div className="bg-card border border-border rounded-2xl p-6 text-center">
            <p className="text-muted-foreground">
              Одоогоор боломжтой маршрут байхгүй
            </p>
          </div>
        ) : (
          <div className="space-y-3">
            {availableRoutes.slice(0, 3).map((route: any, idx: number) => (
              <RouteCard key={idx} route={route} onSelect={onFindRoute} />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

function RouteCard({ route, onSelect }: { route: any; onSelect: () => void }) {
  return (
    <button
      onClick={onSelect}
      className="w-full bg-card border border-border rounded-2xl p-4 text-left hover:bg-accent transition-colors"
    >
      <div className="flex items-start justify-between mb-2">
        <div className="flex-1">
          <p className="text-sm text-muted-foreground">
            {route.startPoint || "Баянзүрх"} → {route.endPoint || "Сүхбаатар"}
          </p>
          <div className="flex items-center gap-3 mt-2 text-sm">
            <span className="flex items-center gap-1">
              <Clock className="w-4 h-4" />
              {route.departureTime || "08:00"}
            </span>
            <span className="text-muted-foreground">
              {route.seatsLeft || 3} суудал үлдсэн
            </span>
          </div>
        </div>
        <div className="text-right">
          <p className="text-primary font-medium">{route.price || "5,000"}₮</p>
          <p className="text-xs text-muted-foreground">
            ~{route.eta || "25"} мин
          </p>
        </div>
      </div>
    </button>
  );
}
