import { useState } from "react";
import { Button } from "../ui/button";
import { Textarea } from "../ui/textarea";
import { Star, CheckCircle } from "lucide-react";
import { projectId, publicAnonKey } from "../../utils/supabase/info";

interface PaymentRatingProps {
  ride: any;
  user: any;
  onComplete: () => void;
}

export function PaymentRating({ ride, user, onComplete }: PaymentRatingProps) {
  const [step, setStep] = useState<"payment" | "rating">("payment");
  const [rating, setRating] = useState(0);
  const [feedback, setFeedback] = useState("");
  const [hoveredRating, setHoveredRating] = useState(0);
  const [loading, setLoading] = useState(false);

  const handlePayNow = async () => {
    setLoading(true);
    try {
      const response = await fetch(
        `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/rides/${ride.id}/pay`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${publicAnonKey}`,
          },
          body: JSON.stringify({
            userId: user.id,
            amount: ride.totalAmount,
          }),
        }
      );

      if (response.ok) {
        setStep("rating");
      } else {
        throw new Error("Payment failed");
      }
    } catch (err) {
      console.error("Payment error:", err);
      alert("Төлбөр амжилтгүй боллоо");
    } finally {
      setLoading(false);
    }
  };

  const handleSubmitRating = async () => {
    if (rating === 0) {
      alert("Үнэлгээ өгнө үү");
      return;
    }

    setLoading(true);
    try {
      const response = await fetch(
        `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/rides/${ride.id}/rate`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${publicAnonKey}`,
          },
          body: JSON.stringify({
            rating,
            feedback,
            driverId: ride.driverId,
          }),
        }
      );

      if (response.ok) {
        alert("Баярлалаа! Таны үнэлгээ хүлээн авлаа.");
        onComplete();
      }
    } catch (err) {
      console.error("Rating error:", err);
      alert("Үнэлгээ илгээхэд алдаа гарлаа");
    } finally {
      setLoading(false);
    }
  };

  if (step === "payment") {
    return (
      <div className="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-end sm:items-center justify-center">
        <div className="bg-card w-full max-w-md rounded-t-3xl sm:rounded-3xl p-6">
          <div className="w-12 h-1 bg-border rounded-full mx-auto mb-6" />

          <div className="text-center mb-6">
            <div className="w-20 h-20 bg-secondary/10 rounded-full flex items-center justify-center mx-auto mb-4">
              <CheckCircle className="w-10 h-10 text-secondary" />
            </div>
            <h2 className="mb-2">Аялал амжилттай дууслаа!</h2>
            <p className="text-muted-foreground">Төлбөр төлөхөөр бэлэн үү?</p>
          </div>

          {/* Trip Summary */}
          <div className="bg-accent/30 rounded-2xl p-4 mb-6">
            <div className="space-y-3">
              <div className="flex justify-between">
                <span className="text-muted-foreground">Хөдөлсөн зай</span>
                <span>{ride.distance || "8.5"} км</span>
              </div>
              <div className="flex justify-between">
                <span className="text-muted-foreground">Хугацаа</span>
                <span>{ride.duration || "25"} мин</span>
              </div>
              <div className="flex justify-between">
                <span className="text-muted-foreground">Аяллын үнэ</span>
                <span>{ride.fare || "5,000"}₮</span>
              </div>
              <div className="flex justify-between">
                <span className="text-muted-foreground">Үйлчилгээний хураамж</span>
                <span>500₮</span>
              </div>
              <div className="h-px bg-border my-2" />
              <div className="flex justify-between text-lg">
                <span>Нийт</span>
                <span className="text-primary">
                  {ride.totalAmount || "5,500"}₮
                </span>
              </div>
            </div>
          </div>

          <Button onClick={handlePayNow} disabled={loading} className="w-full mb-3">
            {loading ? "Төлж байна..." : "Төлөх"}
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-end sm:items-center justify-center">
      <div className="bg-card w-full max-w-md rounded-t-3xl sm:rounded-3xl p-6 max-h-[90vh] overflow-y-auto">
        <div className="w-12 h-1 bg-border rounded-full mx-auto mb-6" />

        <div className="text-center mb-6">
          <h2 className="mb-2">Жолоочоо үнэлэх</h2>
          <p className="text-muted-foreground">
            Таны санал бидний үйлчилгээг сайжруулахад тусална
          </p>
        </div>

        {/* Star Rating */}
        <div className="flex justify-center gap-2 mb-6">
          {[1, 2, 3, 4, 5].map((star) => (
            <button
              key={star}
              onClick={() => setRating(star)}
              onMouseEnter={() => setHoveredRating(star)}
              onMouseLeave={() => setHoveredRating(0)}
              className="transition-transform hover:scale-110"
            >
              <Star
                className={`w-12 h-12 ${
                  star <= (hoveredRating || rating)
                    ? "fill-yellow-400 text-yellow-400"
                    : "text-gray-300"
                }`}
              />
            </button>
          ))}
        </div>

        <div className="text-center mb-6">
          {rating === 0 && <p className="text-muted-foreground">Одоор дарж үнэлнэ үү</p>}
          {rating === 1 && <p className="text-destructive">Маш муу</p>}
          {rating === 2 && <p className="text-orange-500">Муу</p>}
          {rating === 3 && <p className="text-yellow-500">Дунд зэрэг</p>}
          {rating === 4 && <p className="text-primary">Сайн</p>}
          {rating === 5 && <p className="text-secondary">Маш сайн!</p>}
        </div>

        {/* Feedback */}
        <div className="mb-6">
          <label className="block mb-2 text-sm">
            Санал сэтгэгдэл (заавал биш)
          </label>
          <Textarea
            value={feedback}
            onChange={(e) => setFeedback(e.target.value)}
            placeholder="Жолооч, үйлчилгээний талаарх таны санал..."
            rows={4}
            className="resize-none"
          />
        </div>

        <div className="flex gap-3">
          <Button onClick={onComplete} variant="outline" className="flex-1">
            Алгасах
          </Button>
          <Button onClick={handleSubmitRating} disabled={loading} className="flex-1">
            {loading ? "Илгээж байна..." : "Илгээх"}
          </Button>
        </div>
      </div>
    </div>
  );
}
