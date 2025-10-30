import { Home, Car, Wallet, User } from "lucide-react";

interface BottomNavProps {
  activeTab: string;
  onTabChange: (tab: string) => void;
  role: "driver" | "passenger";
}

export function BottomNav({ activeTab, onTabChange, role }: BottomNavProps) {
  const tabs = [
    { id: "home", label: "Home", icon: Home },
    { id: "rides", label: role === "driver" ? "Routes" : "My Rides", icon: Car },
    { id: "wallet", label: "Wallet", icon: Wallet },
    { id: "profile", label: "Profile", icon: User },
  ];

  return (
    <nav className="fixed bottom-0 left-0 right-0 bg-card border-t border-border z-50">
      <div className="max-w-md mx-auto flex justify-around items-center h-16">
        {tabs.map((tab) => {
          const Icon = tab.icon;
          const isActive = activeTab === tab.id;
          return (
            <button
              key={tab.id}
              onClick={() => onTabChange(tab.id)}
              className={`flex flex-col items-center gap-1 px-4 py-2 transition-colors ${
                isActive ? "text-primary" : "text-muted-foreground"
              }`}
            >
              <Icon className="w-6 h-6" />
              <span className="text-xs">{tab.label}</span>
            </button>
          );
        })}
      </div>
    </nav>
  );
}
