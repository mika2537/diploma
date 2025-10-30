import { useState } from "react";
import { Button } from "../ui/button";
import { Input } from "../ui/input";
import { Label } from "../ui/label";
import { Car } from "lucide-react";
import { API_BASE_URL } from "../../utils/api";

interface RegisterScreenProps {
  onRegister: (user: any, role: "driver" | "passenger") => void;
  onSwitchToLogin: () => void;
}

export function RegisterScreen({
  onRegister,
  onSwitchToLogin,
}: RegisterScreenProps) {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    password: "",
    confirmPassword: "",
    role: "passenger" as "driver" | "passenger",
    vehicleModel: "",
    vehiclePlate: "",
    licenseNumber: "",
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");

    if (formData.password !== formData.confirmPassword)
      return setError("Нууц үг таарахгүй байна");
    if (formData.password.length < 6)
      return setError("Нууц үг 6-аас дээш тэмдэгт байх ёстой");

    setLoading(true);
    try {
      const res = await fetch(`${API_BASE_URL}/auth/register`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || "Бүртгэл амжилтгүй боллоо");
      onRegister(data.user, formData.role);
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-primary/10 to-background flex items-center justify-center p-6 overflow-y-auto">
      <div className="w-full max-w-md py-8">
        <div className="text-center mb-6">
          <div className="inline-flex items-center justify-center w-20 h-20 bg-primary rounded-full mb-4">
            <Car className="w-10 h-10 text-primary-foreground" />
          </div>
          <h1 className="text-primary">UB Carpool</h1>
          <p className="text-muted-foreground">Бүртгүүлэх</p>
        </div>

        <form
          onSubmit={handleSubmit}
          className="bg-card rounded-2xl p-6 shadow-lg space-y-4"
        >
          {/* Common fields */}
          <div>
            <Label>Нэр</Label>
            <Input
              value={formData.name}
              onChange={(e) =>
                setFormData({ ...formData, name: e.target.value })
              }
            />
          </div>

          <div>
            <Label>Цахим шуудан</Label>
            <Input
              type="email"
              value={formData.email}
              onChange={(e) =>
                setFormData({ ...formData, email: e.target.value })
              }
            />
          </div>

          <div>
            <Label>Утасны дугаар</Label>
            <Input
              type="tel"
              value={formData.phone}
              onChange={(e) =>
                setFormData({ ...formData, phone: e.target.value })
              }
            />
          </div>

          {/* Role selector */}
          <div className="flex gap-2">
            {["passenger", "driver"].map((r) => (
              <button
                key={r}
                onClick={() =>
                  setFormData({
                    ...formData,
                    role: r as "driver" | "passenger",
                  })
                }
                type="button"
                className={`flex-1 py-3 rounded-xl ${
                  formData.role === r
                    ? "bg-primary text-white"
                    : "bg-card border border-border"
                }`}
              >
                {r === "driver" ? "Жолооч" : "Зорчигч"}
              </button>
            ))}
          </div>

          {/* Driver fields */}
          {formData.role === "driver" && (
            <>
              <div>
                <Label>Машины марк</Label>
                <Input
                  value={formData.vehicleModel}
                  onChange={(e) =>
                    setFormData({ ...formData, vehicleModel: e.target.value })
                  }
                />
              </div>
              <div>
                <Label>Улсын дугаар</Label>
                <Input
                  value={formData.vehiclePlate}
                  onChange={(e) =>
                    setFormData({ ...formData, vehiclePlate: e.target.value })
                  }
                />
              </div>
              <div>
                <Label>Жолоочийн үнэмлэх</Label>
                <Input
                  value={formData.licenseNumber}
                  onChange={(e) =>
                    setFormData({ ...formData, licenseNumber: e.target.value })
                  }
                />
              </div>
            </>
          )}

          {/* Password fields */}
          <div>
            <Label>Нууц үг</Label>
            <Input
              type="password"
              value={formData.password}
              onChange={(e) =>
                setFormData({ ...formData, password: e.target.value })
              }
            />
          </div>

          <div>
            <Label>Нууц үг давтах</Label>
            <Input
              type="password"
              value={formData.confirmPassword}
              onChange={(e) =>
                setFormData({ ...formData, confirmPassword: e.target.value })
              }
            />
          </div>

          {error && <p className="text-destructive text-sm">{error}</p>}

          <Button type="submit" className="w-full" disabled={loading}>
            {loading ? "Бүртгэж байна..." : "Бүртгүүлэх"}
          </Button>

          <div className="text-center text-sm text-muted-foreground">
            Бүртгэлтэй юу?{" "}
            <button
              onClick={onSwitchToLogin}
              className="text-primary hover:underline"
            >
              Нэвтрэх
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
