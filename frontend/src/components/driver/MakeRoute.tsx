import { useState } from "react";
import { MapView } from "../shared/MapView";
import { Button } from "../ui/button";
import { Input } from "../ui/input";
import { Label } from "../ui/label";
import { MapPin, Mic, Clock, Bookmark } from "lucide-react";
import { projectId, publicAnonKey } from "../../utils/supabase/info";

interface MakeRouteProps {
  user: any;
  onRouteCreated: () => void;
  onBack: () => void;
}

export function MakeRoute({ user, onRouteCreated, onBack }: MakeRouteProps) {
  const [route, setRoute] = useState({
    startPoint: "",
    endPoint: "",
    midpoints: [""],
    departureTime: "",
    seats: "4",
    pricePerSeat: "",
  });
  const [voiceInput, setVoiceInput] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleAddMidpoint = () => {
    setRoute({ ...route, midpoints: [...route.midpoints, ""] });
  };

  const handleMidpointChange = (index: number, value: string) => {
    const newMidpoints = [...route.midpoints];
    newMidpoints[index] = value;
    setRoute({ ...route, midpoints: newMidpoints });
  };

  const handleVoiceInput = () => {
    setVoiceInput(!voiceInput);
    if (!voiceInput) {
      alert("Дуу авах функц идэвхжлээ (прототип горим)");
    }
  };

  const handlePublish = async () => {
    if (!route.startPoint || !route.endPoint || !route.departureTime || !route.pricePerSeat) {
      alert("Бүх шаардлагатай талбаруудыг бөглөнө үү");
      return;
    }

    setLoading(true);
    try {
      const response = await fetch(
        `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/routes/create`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${publicAnonKey}`,
          },
          body: JSON.stringify({
            ...route,
            driverId: user.id,
            status: "active",
          }),
        }
      );

      if (response.ok) {
        alert("Маршрут амжилттай нийтлэгдлээ!");
        onRouteCreated();
      } else {
        throw new Error("Failed to create route");
      }
    } catch (err) {
      console.error("Error creating route:", err);
      alert("Маршрут үүсгэхэд алдаа гарлаа");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="pb-20 px-4 pt-6 max-w-md mx-auto">
      {/* Header */}
      <div className="flex items-center gap-4 mb-6">
        <button onClick={onBack} className="text-primary">
          ← Буцах
        </button>
        <h2>Маршрут үүсгэх</h2>
      </div>

      {/* Map */}
      <div className="mb-6">
        <MapView
          height="h-64"
          showRoute={!!route.startPoint && !!route.endPoint}
          startPoint={route.startPoint ? { lat: 47.92, lng: 106.91 } : undefined}
          endPoint={route.endPoint ? { lat: 47.91, lng: 106.93 } : undefined}
        />
      </div>

      {/* Voice Input Toggle */}
      <div className="flex justify-end mb-4">
        <button
          onClick={handleVoiceInput}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl transition-colors ${
            voiceInput
              ? "bg-primary text-primary-foreground"
              : "bg-card border border-border"
          }`}
        >
          <Mic className="w-5 h-5" />
          <span className="text-sm">Дуугаар оруулах</span>
        </button>
      </div>

      {/* Form */}
      <div className="space-y-4">
        <div>
          <Label>Эхлэх цэг</Label>
          <div className="relative mt-1">
            <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
            <Input
              value={route.startPoint}
              onChange={(e) => setRoute({ ...route, startPoint: e.target.value })}
              placeholder="Баянзүрх дүүрэг, 3-р хороо"
              className="pl-10"
            />
          </div>
        </div>

        {/* Midpoints */}
        {route.midpoints.map((midpoint, idx) => (
          <div key={idx}>
            <Label>Дундын цэг {idx + 1}</Label>
            <div className="relative mt-1">
              <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-accent-foreground" />
              <Input
                value={midpoint}
                onChange={(e) => handleMidpointChange(idx, e.target.value)}
                placeholder="Нэмэлт зогсоол (заавал биш)"
                className="pl-10"
              />
            </div>
          </div>
        ))}

        <button
          onClick={handleAddMidpoint}
          className="text-primary text-sm hover:underline"
        >
          + Дундын цэг нэмэх
        </button>

        <div>
          <Label>Очих газар</Label>
          <div className="relative mt-1">
            <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-destructive" />
            <Input
              value={route.endPoint}
              onChange={(e) => setRoute({ ...route, endPoint: e.target.value })}
              placeholder="Сүхбаатар дүүрэг, 1-р хороо"
              className="pl-10"
            />
          </div>
        </div>

        <div>
          <Label>Хөдлөх цаг</Label>
          <div className="relative mt-1">
            <Clock className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
            <Input
              type="datetime-local"
              value={route.departureTime}
              onChange={(e) => setRoute({ ...route, departureTime: e.target.value })}
              className="pl-10"
            />
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <Label>Суудлын тоо</Label>
            <Input
              type="number"
              value={route.seats}
              onChange={(e) => setRoute({ ...route, seats: e.target.value })}
              min="1"
              max="8"
              className="mt-1"
            />
          </div>

          <div>
            <Label>Суудлын үнэ (₮)</Label>
            <Input
              type="number"
              value={route.pricePerSeat}
              onChange={(e) => setRoute({ ...route, pricePerSeat: e.target.value })}
              placeholder="5000"
              className="mt-1"
            />
          </div>
        </div>

        {/* Actions */}
        <div className="flex gap-3 pt-4">
          <button className="flex-1 border border-border rounded-xl py-3 flex items-center justify-center gap-2 hover:bg-accent transition-colors">
            <Bookmark className="w-5 h-5" />
            <span>Загвар хадгалах</span>
          </button>

          <Button onClick={handlePublish} disabled={loading} className="flex-1">
            {loading ? "Нийтлэж байна..." : "Нийтлэх"}
          </Button>
        </div>
      </div>
    </div>
  );
}
