import { useState } from "react";
import { Button } from "../ui/button";
import { User, MapPin, Clock, DollarSign, CreditCard, QrCode, Wallet } from "lucide-react";

interface RideRequestProps {
  route: any;
  user: any;
  onConfirm: () => void;
  onCancel: () => void;
}

export function RideRequest({ route, user, onConfirm, onCancel }: RideRequestProps) {
  const [paymentMethod, setPaymentMethod] = useState<"qr" | "card" | "wallet">("wallet");

  const paymentMethods = [
    { id: "wallet", label: "Wallet", icon: Wallet },
    { id: "qr", label: "QR", icon: QrCode },
    { id: "card", label: "Карт", icon: CreditCard },
  ];

  return (
    <div className="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-end sm:items-center justify-center">
      <div className="bg-card w-full max-w-md rounded-t-3xl sm:rounded-3xl p-6 max-h-[90vh] overflow-y-auto">
        <div className="w-12 h-1 bg-border rounded-full mx-auto mb-6" />

        <h2 className="mb-6">Хүсэлт баталгаажуулах</h2>

        {/* Driver Info */}
        <div className="bg-accent/50 rounded-2xl p-4 mb-6">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center">
              <User className="w-8 h-8 text-primary" />
            </div>
            <div className="flex-1">
              <h3>{route.driverName || "Жолооч"}</h3>
              <p className="text-sm text-muted-foreground">
                {route.vehicleModel || "Toyota Prius"}
              </p>
              <p className="text-sm text-muted-foreground">
                {route.vehiclePlate || "УБ 1234"}
              </p>
            </div>
          </div>

          <div className="space-y-3">
            <div className="flex items-start gap-2">
              <MapPin className="w-5 h-5 text-secondary mt-0.5 flex-shrink-0" />
              <div>
                <p className="text-sm text-muted-foreground">Авах цэг</p>
                <p>{route.startPoint || "Баянзүрх дүүрэг"}</p>
              </div>
            </div>

            <div className="flex items-start gap-2">
              <MapPin className="w-5 h-5 text-destructive mt-0.5 flex-shrink-0" />
              <div>
                <p className="text-sm text-muted-foreground">Буух цэг</p>
                <p>{route.endPoint || "Сүхбаатар дүүрэг"}</p>
              </div>
            </div>

            <div className="flex items-center gap-2">
              <Clock className="w-5 h-5 text-muted-foreground" />
              <div>
                <p className="text-sm text-muted-foreground">Хөдлөх цаг</p>
                <p>{route.departureTime || "08:00"}</p>
              </div>
            </div>
          </div>
        </div>

        {/* Price Breakdown */}
        <div className="bg-accent/30 rounded-2xl p-4 mb-6">
          <h4 className="mb-3">Төлбөрийн дэлгэрэнгүй</h4>
          <div className="space-y-2">
            <div className="flex justify-between text-sm">
              <span className="text-muted-foreground">Аяллын үнэ</span>
              <span>{route.price || "5,000"}₮</span>
            </div>
            <div className="flex justify-between text-sm">
              <span className="text-muted-foreground">Үйлчилгээний хураамж</span>
              <span>500₮</span>
            </div>
            <div className="h-px bg-border my-2" />
            <div className="flex justify-between">
              <span>Нийт</span>
              <span className="text-primary">
                {(parseInt(route.price || "5000") + 500).toLocaleString()}₮
              </span>
            </div>
          </div>
        </div>

        {/* Payment Method */}
        <div className="mb-6">
          <h4 className="mb-3">Төлбөрийн хэлбэр</h4>
          <div className="grid grid-cols-3 gap-3">
            {paymentMethods.map((method) => {
              const Icon = method.icon;
              return (
                <button
                  key={method.id}
                  onClick={() => setPaymentMethod(method.id as any)}
                  className={`p-4 rounded-xl border-2 transition-all ${
                    paymentMethod === method.id
                      ? "border-primary bg-primary/10"
                      : "border-border hover:bg-accent"
                  }`}
                >
                  <Icon className="w-6 h-6 mx-auto mb-2" />
                  <p className="text-sm">{method.label}</p>
                </button>
              );
            })}
          </div>
        </div>

        {/* Actions */}
        <div className="flex gap-3">
          <Button onClick={onCancel} variant="outline" className="flex-1">
            Цуцлах
          </Button>
          <Button onClick={onConfirm} className="flex-1">
            Баталгаажуулах
          </Button>
        </div>
      </div>
    </div>
  );
}
