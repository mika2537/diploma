import { MapPin, Navigation } from "lucide-react";
import { useEffect, useState } from "react";

interface MapViewProps {
  startPoint?: { lat: number; lng: number; label?: string };
  endPoint?: { lat: number; lng: number; label?: string };
  currentLocation?: { lat: number; lng: number };
  midpoints?: Array<{ lat: number; lng: number; label?: string }>;
  height?: string;
  showRoute?: boolean;
}

export function MapView({
  startPoint,
  endPoint,
  currentLocation,
  midpoints = [],
  height = "h-64",
  showRoute = false,
}: MapViewProps) {
  const [userLocation, setUserLocation] = useState<{ lat: number; lng: number } | null>(null);

  useEffect(() => {
    // Simulate getting user location (Ulaanbaatar coordinates)
    if (!currentLocation) {
      setUserLocation({ lat: 47.9186, lng: 106.9177 });
    }
  }, [currentLocation]);

  const displayLocation = currentLocation || userLocation || { lat: 47.9186, lng: 106.9177 };

  return (
    <div className={`relative ${height} bg-muted rounded-2xl overflow-hidden shadow-lg`}>
      {/* Map Background - Google Maps style */}
      <div
        className="absolute inset-0 bg-cover bg-center"
        style={{
          backgroundImage: `url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23e5e7eb' fill-opacity='0.4'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")`,
          backgroundColor: "#f8f9fa",
        }}
      />

      {/* Road lines */}
      {showRoute && startPoint && endPoint && (
        <svg className="absolute inset-0 w-full h-full pointer-events-none">
          <line
            x1="30%"
            y1="70%"
            x2="70%"
            y2="30%"
            stroke="#1B5E20"
            strokeWidth="3"
            strokeDasharray="5,5"
          />
        </svg>
      )}

      {/* Start Point Marker */}
      {startPoint && (
        <div className="absolute top-[70%] left-[30%] -translate-x-1/2 -translate-y-full">
          <div className="bg-secondary text-secondary-foreground rounded-full p-2 shadow-lg">
            <MapPin className="w-6 h-6" />
          </div>
          {startPoint.label && (
            <div className="absolute top-full mt-1 left-1/2 -translate-x-1/2 bg-white px-2 py-1 rounded shadow text-xs whitespace-nowrap">
              {startPoint.label}
            </div>
          )}
        </div>
      )}

      {/* End Point Marker */}
      {endPoint && (
        <div className="absolute top-[30%] left-[70%] -translate-x-1/2 -translate-y-full">
          <div className="bg-destructive text-destructive-foreground rounded-full p-2 shadow-lg">
            <MapPin className="w-6 h-6" />
          </div>
          {endPoint.label && (
            <div className="absolute top-full mt-1 left-1/2 -translate-x-1/2 bg-white px-2 py-1 rounded shadow text-xs whitespace-nowrap">
              {endPoint.label}
            </div>
          )}
        </div>
      )}

      {/* Current Location */}
      {(currentLocation || userLocation) && (
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2">
          <div className="relative">
            <div className="absolute inset-0 bg-primary rounded-full opacity-20 animate-ping" />
            <div className="bg-primary text-primary-foreground rounded-full p-2 shadow-lg">
              <Navigation className="w-5 h-5" />
            </div>
          </div>
        </div>
      )}

      {/* Midpoints */}
      {midpoints.map((point, idx) => (
        <div
          key={idx}
          className="absolute"
          style={{ top: `${50 + idx * 10}%`, left: `${50 + idx * 10}%` }}
        >
          <div className="bg-accent text-accent-foreground rounded-full p-1.5 shadow">
            <div className="w-2 h-2 bg-primary rounded-full" />
          </div>
        </div>
      ))}

      {/* Controls */}
      <div className="absolute top-4 right-4 flex flex-col gap-2">
        <button className="bg-white rounded-lg p-2 shadow-md hover:bg-gray-50 transition-colors">
          <span className="text-lg">+</span>
        </button>
        <button className="bg-white rounded-lg p-2 shadow-md hover:bg-gray-50 transition-colors">
          <span className="text-lg">−</span>
        </button>
      </div>
    </div>
  );
}
