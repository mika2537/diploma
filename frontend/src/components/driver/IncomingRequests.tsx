import { useState, useEffect } from "react";
import { MapPin, User, DollarSign, Clock } from "lucide-react";
import { Button } from "../ui/button";
import { projectId, publicAnonKey } from "../../utils/supabase/info";

interface IncomingRequestsProps {
  user: any;
  onBack: () => void;
}

export function IncomingRequests({ user, onBack }: IncomingRequestsProps) {
  const [requests, setRequests] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadRequests();
  }, [user.id]);

  const loadRequests = async () => {
    try {
      const response = await fetch(
        `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/rides/requests?driverId=${user.id}`,
        {
          headers: {
            Authorization: `Bearer ${publicAnonKey}`,
          },
        }
      );

      if (response.ok) {
        const data = await response.json();
        setRequests(data.requests || []);
      }
    } catch (err) {
      console.error("Failed to load requests:", err);
    } finally {
      setLoading(false);
    }
  };

  const handleAccept = async (requestId: string) => {
    try {
      const response = await fetch(
        `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/rides/${requestId}/accept`,
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${publicAnonKey}`,
          },
          body: JSON.stringify({ driverId: user.id }),
        }
      );

      if (response.ok) {
        alert("Хүсэлт амжилттай зөвшөөрөгдлөө!");
        loadRequests();
      }
    } catch (err) {
      console.error("Failed to accept request:", err);
    }
  };

  const handleReject = async (requestId: string) => {
    try {
      const response = await fetch(
        `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/rides/${requestId}/reject`,
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${publicAnonKey}`,
          },
          body: JSON.stringify({ driverId: user.id }),
        }
      );

      if (response.ok) {
        alert("Хүсэлт татгалзагдлаа");
        loadRequests();
      }
    } catch (err) {
      console.error("Failed to reject request:", err);
    }
  };

  return (
    <div className="pb-20 px-4 pt-6 max-w-md mx-auto">
      {/* Header */}
      <div className="flex items-center gap-4 mb-6">
        <button onClick={onBack} className="text-primary">
          ← Буцах
        </button>
        <h2>Ирсэн хүсэлтүүд</h2>
      </div>

      {/* Requests List */}
      {loading ? (
        <div className="text-center py-12 text-muted-foreground">Уншиж байна...</div>
      ) : requests.length === 0 ? (
        <div className="text-center py-12">
          <div className="w-16 h-16 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
            <User className="w-8 h-8 text-muted-foreground" />
          </div>
          <p className="text-muted-foreground">Одоогоор шинэ хүсэлт байхгүй байна</p>
        </div>
      ) : (
        <div className="space-y-4">
          {requests.map((request: any) => (
            <RequestCard
              key={request.id}
              request={request}
              onAccept={() => handleAccept(request.id)}
              onReject={() => handleReject(request.id)}
            />
          ))}
        </div>
      )}
    </div>
  );
}

function RequestCard({
  request,
  onAccept,
  onReject,
}: {
  request: any;
  onAccept: () => void;
  onReject: () => void;
}) {
  const [swiping, setSwiping] = useState(false);
  const [swipeX, setSwipeX] = useState(0);

  const handleTouchStart = (e: React.TouchEvent) => {
    setSwiping(true);
  };

  const handleTouchMove = (e: React.TouchEvent) => {
    if (swiping) {
      const touch = e.touches[0];
      setSwipeX(touch.clientX - 200); // Adjust based on card position
    }
  };

  const handleTouchEnd = () => {
    if (swipeX > 100) {
      onAccept();
    } else if (swipeX < -100) {
      onReject();
    }
    setSwiping(false);
    setSwipeX(0);
  };

  return (
    <div
      className="bg-card border border-border rounded-2xl p-4 shadow-sm transition-transform"
      style={{ transform: `translateX(${swipeX}px)` }}
      onTouchStart={handleTouchStart}
      onTouchMove={handleTouchMove}
      onTouchEnd={handleTouchEnd}
    >
      {/* Passenger Info */}
      <div className="flex items-start gap-3 mb-4">
        <div className="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center">
          <User className="w-6 h-6 text-primary" />
        </div>
        <div className="flex-1">
          <h4>{request.passengerName || "Зорчигч"}</h4>
          <div className="flex items-center gap-4 text-sm text-muted-foreground mt-1">
            <span className="flex items-center gap-1">
              <Clock className="w-4 h-4" />
              {request.requestTime || "10 мин өмнө"}
            </span>
          </div>
        </div>
        <div className="text-right">
          <div className="text-secondary">{request.fare || "5,000"}₮</div>
          <div className="text-xs text-muted-foreground">Тооцоолсон үнэ</div>
        </div>
      </div>

      {/* Pickup Point */}
      <div className="bg-accent/50 rounded-xl p-3 mb-3">
        <div className="flex items-start gap-2">
          <MapPin className="w-5 h-5 text-secondary mt-0.5" />
          <div>
            <p className="text-sm text-muted-foreground">Авах цэг</p>
            <p>{request.pickupPoint || "Баянзүрх дүүрэг, 3-р хороо"}</p>
          </div>
        </div>
      </div>

      {/* Actions */}
      <div className="flex gap-3">
        <Button
          onClick={onReject}
          variant="outline"
          className="flex-1 border-destructive text-destructive hover:bg-destructive hover:text-destructive-foreground"
        >
          Татгалзах
        </Button>
        <Button onClick={onAccept} className="flex-1 bg-secondary hover:bg-secondary/90">
          Зөвшөөрөх
        </Button>
      </div>

      {/* Swipe hint */}
      <p className="text-xs text-center text-muted-foreground mt-2">
        ← Шудрах эсвэл зөвшөөрөх →
      </p>
    </div>
  );
}
