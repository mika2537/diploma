import { useState } from "react";
import { MapView } from "../shared/MapView";
import { Button } from "../ui/button";
import { Input } from "../ui/input";
import { Label } from "../ui/label";
import { MapPin, Search, Clock, User, Star } from "lucide-react";
import { projectId, publicAnonKey } from "../../utils/supabase/info";

interface FindRouteProps {
  user: any;
  onRequestRide: (route: any) => void;
  onBack: () => void;
}

export function FindRoute({ user, onRequestRide, onBack }: FindRouteProps) {
  const [search, setSearch] = useState({
    pickup: "",
    destination: "",
    time: "",
  });
  const [results, setResults] = useState<any[]>([]);
  const [searching, setSearching] = useState(false);

  const handleSearch = async () => {
    if (!search.pickup || !search.destination) {
      alert("Авах болон буух газраа оруулна уу");
      return;
    }

    setSearching(true);
    try {
      const response = await fetch(
        `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/routes/search`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${publicAnonKey}`,
          },
          body: JSON.stringify(search),
        }
      );

      if (response.ok) {
        const data = await response.json();
        setResults(data.routes || []);
      }
    } catch (err) {
      console.error("Failed to search routes:", err);
    } finally {
      setSearching(false);
    }
  };

  return (
    <div className="pb-20 px-4 pt-6 max-w-md mx-auto">
      {/* Header */}
      <div className="flex items-center gap-4 mb-6">
        <button onClick={onBack} className="text-primary">
          ← Буцах
        </button>
        <h2>Маршрут хайх</h2>
      </div>

      {/* Map */}
      <div className="mb-6">
        <MapView
          height="h-48"
          showRoute={!!search.pickup && !!search.destination}
          startPoint={search.pickup ? { lat: 47.92, lng: 106.91 } : undefined}
          endPoint={search.destination ? { lat: 47.91, lng: 106.93 } : undefined}
        />
      </div>

      {/* Search Form */}
      <div className="space-y-4 mb-6">
        <div>
          <Label>Авах цэг</Label>
          <div className="relative mt-1">
            <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-secondary" />
            <Input
              value={search.pickup}
              onChange={(e) => setSearch({ ...search, pickup: e.target.value })}
              placeholder="Хаанаас явах вэ?"
              className="pl-10"
            />
          </div>
        </div>

        <div>
          <Label>Буух цэг</Label>
          <div className="relative mt-1">
            <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-destructive" />
            <Input
              value={search.destination}
              onChange={(e) => setSearch({ ...search, destination: e.target.value })}
              placeholder="Хаашаа явах вэ?"
              className="pl-10"
            />
          </div>
        </div>

        <div>
          <Label>Хөдлөх цаг (заавал биш)</Label>
          <div className="relative mt-1">
            <Clock className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
            <Input
              type="time"
              value={search.time}
              onChange={(e) => setSearch({ ...search, time: e.target.value })}
              className="pl-10"
            />
          </div>
        </div>

        <Button onClick={handleSearch} disabled={searching} className="w-full">
          <Search className="w-5 h-5 mr-2" />
          {searching ? "Хайж байна..." : "Хайх"}
        </Button>
      </div>

      {/* Results */}
      {results.length > 0 && (
        <div>
          <h3 className="mb-3">Олдсон маршрутууд ({results.length})</h3>
          <div className="space-y-3">
            {results.map((route: any, idx: number) => (
              <RouteResultCard
                key={idx}
                route={route}
                onSelect={() => onRequestRide(route)}
              />
            ))}
          </div>
        </div>
      )}

      {!searching && results.length === 0 && search.pickup && search.destination && (
        <div className="text-center py-8">
          <p className="text-muted-foreground">
            Таны хайлтад тохирох маршрут олдсонгүй
          </p>
        </div>
      )}
    </div>
  );
}

function RouteResultCard({ route, onSelect }: { route: any; onSelect: () => void }) {
  return (
    <div className="bg-card border border-border rounded-2xl p-4 hover:bg-accent transition-colors">
      {/* Driver Info */}
      <div className="flex items-center gap-3 mb-3">
        <div className="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center">
          <User className="w-6 h-6 text-primary" />
        </div>
        <div className="flex-1">
          <h4>{route.driverName || "Жолооч"}</h4>
          <div className="flex items-center gap-2 text-sm">
            <div className="flex items-center gap-1 text-yellow-500">
              <Star className="w-4 h-4 fill-current" />
              <span>{route.rating || "4.8"}</span>
            </div>
            <span className="text-muted-foreground">
              {route.vehicleModel || "Toyota Prius"}
            </span>
          </div>
        </div>
        <div className="text-right">
          <p className="text-primary">{route.price || "5,000"}₮</p>
          <p className="text-xs text-muted-foreground">Суудал</p>
        </div>
      </div>

      {/* Route Details */}
      <div className="bg-accent/50 rounded-xl p-3 mb-3 space-y-2">
        <div className="flex items-start gap-2">
          <MapPin className="w-5 h-5 text-secondary mt-0.5" />
          <div className="flex-1">
            <p className="text-sm text-muted-foreground">Авах</p>
            <p>{route.startPoint || "Баянзүрх дүүрэг"}</p>
          </div>
        </div>
        <div className="flex items-start gap-2">
          <MapPin className="w-5 h-5 text-destructive mt-0.5" />
          <div className="flex-1">
            <p className="text-sm text-muted-foreground">Буух</p>
            <p>{route.endPoint || "Сүхбаатар дүүрэг"}</p>
          </div>
        </div>
      </div>

      {/* Trip Info */}
      <div className="flex items-center justify-between text-sm mb-3">
        <span className="flex items-center gap-1">
          <Clock className="w-4 h-4" />
          {route.departureTime || "08:00"}
        </span>
        <span className="text-muted-foreground">
          ~{route.duration || "25"} мин
        </span>
        <span className="text-secondary">
          {route.seatsLeft || 3} суудал үлдсэн
        </span>
      </div>

      <Button onClick={onSelect} className="w-full">
        Хүсэлт илгээх
      </Button>
    </div>
  );
}
