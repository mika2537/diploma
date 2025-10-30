import { useState } from "react";
import { Button } from "../ui/button";
import { Input } from "../ui/input";
import { Label } from "../ui/label";
import { Car, Fingerprint } from "lucide-react";
import { API_BASE_URL } from "../../utils/api";

interface LoginScreenProps {
  onLogin: (user: any, role: "driver" | "passenger") => void;
  onSwitchToRegister: () => void;
}

export function LoginScreen({ onLogin, onSwitchToRegister }: LoginScreenProps) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [role, setRole] = useState<"driver" | "passenger">("passenger");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      const response = await fetch(`${API_BASE_URL}/auth/login`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password, role }),
      });

      const data = await response.json();

      if (!response.ok) throw new Error(data.error || "Нэвтрэхэд алдаа гарлаа");

      // ✅ Save token & user to localStorage
      localStorage.setItem("token", data.token);
      localStorage.setItem("user", JSON.stringify(data.user));

      onLogin(data.user, role);
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-primary/10 to-background flex items-center justify-center p-6">
      <div className="w-full max-w-md">
        {/* Logo */}
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-20 h-20 bg-primary rounded-full mb-4">
            <Car className="w-10 h-10 text-primary-foreground" />
          </div>
          <h1 className="text-primary">UB Carpool</h1>
          <p className="text-muted-foreground">Нэвтрэх</p>
        </div>

        {/* Role Selector */}
        <div className="flex gap-2 mb-6">
          {["passenger", "driver"].map((r) => (
            <button
              key={r}
              onClick={() => setRole(r as "driver" | "passenger")}
              className={`flex-1 py-3 rounded-xl transition-all ${
                role === r
                  ? "bg-primary text-primary-foreground"
                  : "bg-card text-foreground border border-border"
              }`}
            >
              {r === "driver" ? "Жолооч" : "Зорчигч"}
            </button>
          ))}
        </div>

        {/* Login Form */}
        <form
          onSubmit={handleLogin}
          className="bg-card rounded-2xl p-6 shadow-lg space-y-4"
        >
          <div>
            <Label>Цахим шуудан</Label>
            <Input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="example@email.com"
              required
              className="mt-1"
            />
          </div>

          <div>
            <Label>Нууц үг</Label>
            <Input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              required
              className="mt-1"
            />
          </div>

          {error && <p className="text-destructive text-sm">{error}</p>}

          <Button type="submit" className="w-full" disabled={loading}>
            {loading ? "Уншиж байна..." : "Нэвтрэх"}
          </Button>

          <button
            type="button"
            className="w-full py-3 flex items-center justify-center gap-2 border border-border rounded-xl hover:bg-accent transition-colors"
          >
            <Fingerprint className="w-5 h-5" />
            <span>Биометрик нэвтрэх</span>
          </button>

          <div className="text-center text-sm text-muted-foreground">
            Бүртгэлгүй юу?{" "}
            <button
              onClick={onSwitchToRegister}
              className="text-primary hover:underline"
            >
              Бүртгүүлэх
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
