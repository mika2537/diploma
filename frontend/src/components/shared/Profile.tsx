import { useState } from "react";
import { Button } from "../ui/button";
import { Input } from "../ui/input";
import { Label } from "../ui/label";
import { Switch } from "../ui/switch";
import { User, Car, Phone, Mail, Shield, Moon, LogOut, Edit } from "lucide-react";

interface ProfileProps {
  user: any;
  role: "driver" | "passenger";
  onLogout: () => void;
}

export function Profile({ user, role, onLogout }: ProfileProps) {
  const [darkMode, setDarkMode] = useState(false);
  const [editMode, setEditMode] = useState(false);
  const [formData, setFormData] = useState({
    name: user.name || "",
    phone: user.phone || "",
    email: user.email || "",
    // Driver specific
    vehicleModel: user.vehicleModel || "",
    vehiclePlate: user.vehiclePlate || "",
    licenseNumber: user.licenseNumber || "",
  });

  const toggleDarkMode = () => {
    setDarkMode(!darkMode);
    document.documentElement.classList.toggle("dark");
  };

  const handleSave = () => {
    alert("Мэдээлэл амжилттай хадгалагдлаа!");
    setEditMode(false);
  };

  const handleSOSSetup = () => {
    alert("SOS тохиргоо удахгүй нэмэгдэнэ");
  };

  return (
    <div className="pb-20 px-4 pt-6 max-w-md mx-auto">
      <div className="flex items-center justify-between mb-6">
        <h2>Профайл</h2>
        {!editMode && (
          <Button onClick={() => setEditMode(true)} variant="outline" size="sm">
            <Edit className="w-4 h-4 mr-2" />
            Засах
          </Button>
        )}
      </div>

      {/* Profile Photo */}
      <div className="flex flex-col items-center mb-6">
        <div className="w-24 h-24 bg-gradient-to-br from-primary to-primary/80 rounded-full flex items-center justify-center mb-3">
          <User className="w-12 h-12 text-primary-foreground" />
        </div>
        <h3>{user.name}</h3>
        <p className="text-sm text-muted-foreground">
          {role === "driver" ? "Жолооч" : "Зорчигч"}
        </p>
      </div>

      {/* Personal Info */}
      <div className="bg-card border border-border rounded-2xl p-4 mb-4">
        <h4 className="mb-4">Хувийн мэдээлэл</h4>

        <div className="space-y-4">
          <div>
            <Label>Нэр</Label>
            <div className="relative mt-1">
              <User className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
              <Input
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                disabled={!editMode}
                className="pl-10"
              />
            </div>
          </div>

          <div>
            <Label>Утасны дугаар</Label>
            <div className="relative mt-1">
              <Phone className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
              <Input
                value={formData.phone}
                onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                disabled={!editMode}
                className="pl-10"
              />
            </div>
          </div>

          <div>
            <Label>Цахим шуудан</Label>
            <div className="relative mt-1">
              <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
              <Input
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                disabled={!editMode}
                className="pl-10"
              />
            </div>
          </div>
        </div>
      </div>

      {/* Driver Vehicle Info */}
      {role === "driver" && (
        <div className="bg-card border border-border rounded-2xl p-4 mb-4">
          <h4 className="mb-4">Тээврийн хэрэгсэл</h4>

          <div className="space-y-4">
            <div>
              <Label>Машины марк</Label>
              <div className="relative mt-1">
                <Car className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
                <Input
                  value={formData.vehicleModel}
                  onChange={(e) =>
                    setFormData({ ...formData, vehicleModel: e.target.value })
                  }
                  disabled={!editMode}
                  className="pl-10"
                />
              </div>
            </div>

            <div>
              <Label>Улсын дугаар</Label>
              <Input
                value={formData.vehiclePlate}
                onChange={(e) =>
                  setFormData({ ...formData, vehiclePlate: e.target.value })
                }
                disabled={!editMode}
              />
            </div>

            <div>
              <Label>Жолоочийн үнэмлэх</Label>
              <Input
                value={formData.licenseNumber}
                onChange={(e) =>
                  setFormData({ ...formData, licenseNumber: e.target.value })
                }
                disabled={!editMode}
              />
            </div>
          </div>
        </div>
      )}

      {/* Settings */}
      <div className="bg-card border border-border rounded-2xl p-4 mb-4">
        <h4 className="mb-4">Тохиргоо</h4>

        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Moon className="w-5 h-5" />
              <div>
                <p>Харанхуй горим</p>
                <p className="text-sm text-muted-foreground">Өнгөний горим</p>
              </div>
            </div>
            <Switch checked={darkMode} onCheckedChange={toggleDarkMode} />
          </div>

          <button
            onClick={handleSOSSetup}
            className="w-full flex items-center justify-between p-3 rounded-xl hover:bg-accent transition-colors"
          >
            <div className="flex items-center gap-3">
              <Shield className="w-5 h-5" />
              <div className="text-left">
                <p>SOS тохиргоо</p>
                <p className="text-sm text-muted-foreground">
                  Яаралтай холбоо барих
                </p>
              </div>
            </div>
          </button>
        </div>
      </div>

      {/* Save/Cancel Buttons */}
      {editMode && (
        <div className="flex gap-3 mb-4">
          <Button onClick={() => setEditMode(false)} variant="outline" className="flex-1">
            Цуцлах
          </Button>
          <Button onClick={handleSave} className="flex-1">
            Хадгалах
          </Button>
        </div>
      )}

      {/* Logout */}
      <Button
        onClick={onLogout}
        variant="outline"
        className="w-full border-destructive text-destructive hover:bg-destructive hover:text-destructive-foreground"
      >
        <LogOut className="w-5 h-5 mr-2" />
        Гарах
      </Button>
    </div>
  );
}
