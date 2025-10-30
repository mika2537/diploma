import { useState } from "react";
import { LoginScreen } from "./components/auth/LoginScreen";
import { RegisterScreen } from "./components/auth/RegisterScreen";
import { BottomNav } from "./components/shared/BottomNav";
import { FloatingActionButton } from "./components/shared/FloatingActionButton";
import { Wallet } from "./components/shared/Wallet";
import { Profile } from "./components/shared/Profile";

// Driver Components
import { DriverDashboard } from "./components/driver/DriverDashboard";
import { MakeRoute } from "./components/driver/MakeRoute";
import { IncomingRequests } from "./components/driver/IncomingRequests";
import { ActiveRide } from "./components/driver/ActiveRide";

// Passenger Components
import { PassengerDashboard } from "./components/passenger/PassengerDashboard";
import { FindRoute } from "./components/passenger/FindRoute";
import { RideRequest } from "./components/passenger/RideRequest";
import { LiveTrip } from "./components/passenger/LiveTrip";
import { PaymentRating } from "./components/passenger/PaymentRating";

import { Plus, Route } from "lucide-react";

type AuthScreen = "login" | "register";
type DriverScreen = "dashboard" | "make-route" | "requests" | "active-ride" | "wallet" | "profile";
type PassengerScreen = "dashboard" | "find-route" | "request" | "live-trip" | "payment" | "wallet" | "profile";

export default function App() {
  const [authScreen, setAuthScreen] = useState<AuthScreen>("login");
  const [user, setUser] = useState<any>(null);
  const [role, setRole] = useState<"driver" | "passenger" | null>(null);
  
  // Driver state
  const [driverScreen, setDriverScreen] = useState<DriverScreen>("dashboard");
  const [activeRideId, setActiveRideId] = useState<string | null>(null);
  
  // Passenger state
  const [passengerScreen, setPassengerScreen] = useState<PassengerScreen>("dashboard");
  const [selectedRoute, setSelectedRoute] = useState<any>(null);
  const [currentRideId, setCurrentRideId] = useState<string | null>(null);
  const [completedRide, setCompletedRide] = useState<any>(null);

  // Bottom nav mapping
  const [activeTab, setActiveTab] = useState("home");

  const handleLogin = (userData: any, userRole: "driver" | "passenger") => {
    setUser(userData);
    setRole(userRole);
  };

  const handleRegister = (userData: any, userRole: "driver" | "passenger") => {
    setUser(userData);
    setRole(userRole);
  };

  const handleLogout = () => {
    setUser(null);
    setRole(null);
    setAuthScreen("login");
    setDriverScreen("dashboard");
    setPassengerScreen("dashboard");
    setActiveTab("home");
  };

  const handleBottomNavChange = (tab: string) => {
    setActiveTab(tab);
    
    if (role === "driver") {
      switch (tab) {
        case "home":
          setDriverScreen("dashboard");
          break;
        case "rides":
          setDriverScreen("requests");
          break;
        case "wallet":
          setDriverScreen("wallet");
          break;
        case "profile":
          setDriverScreen("profile");
          break;
      }
    } else if (role === "passenger") {
      switch (tab) {
        case "home":
          setPassengerScreen("dashboard");
          break;
        case "rides":
          // Show ride history or current ride
          break;
        case "wallet":
          setPassengerScreen("wallet");
          break;
        case "profile":
          setPassengerScreen("profile");
          break;
      }
    }
  };

  // Not logged in - show auth
  if (!user || !role) {
    if (authScreen === "login") {
      return (
        <LoginScreen
          onLogin={handleLogin}
          onSwitchToRegister={() => setAuthScreen("register")}
        />
      );
    } else {
      return (
        <RegisterScreen
          onRegister={handleRegister}
          onSwitchToLogin={() => setAuthScreen("login")}
        />
      );
    }
  }

  // ==================== DRIVER APP ====================
  if (role === "driver") {
    return (
      <div className="min-h-screen bg-background">
        {/* Screen Content */}
        {driverScreen === "dashboard" && (
          <DriverDashboard
            user={user}
            onMakeRoute={() => setDriverScreen("make-route")}
            onViewRequests={() => setDriverScreen("requests")}
          />
        )}

        {driverScreen === "make-route" && (
          <MakeRoute
            user={user}
            onRouteCreated={() => setDriverScreen("dashboard")}
            onBack={() => setDriverScreen("dashboard")}
          />
        )}

        {driverScreen === "requests" && (
          <IncomingRequests
            user={user}
            onBack={() => setDriverScreen("dashboard")}
          />
        )}

        {driverScreen === "active-ride" && activeRideId && (
          <ActiveRide
            user={user}
            rideId={activeRideId}
            onComplete={() => {
              setActiveRideId(null);
              setDriverScreen("dashboard");
            }}
            onBack={() => setDriverScreen("dashboard")}
          />
        )}

        {driverScreen === "wallet" && (
          <Wallet user={user} role="driver" />
        )}

        {driverScreen === "profile" && (
          <Profile user={user} role="driver" onLogout={handleLogout} />
        )}

        {/* Bottom Navigation */}
        <BottomNav
          activeTab={activeTab}
          onTabChange={handleBottomNavChange}
          role="driver"
        />

        {/* FAB for Make Route */}
        {driverScreen === "dashboard" && (
          <FloatingActionButton
            onClick={() => setDriverScreen("make-route")}
            icon={<Route className="w-6 h-6" />}
          />
        )}
      </div>
    );
  }

  // ==================== PASSENGER APP ====================
  if (role === "passenger") {
    return (
      <div className="min-h-screen bg-background">
        {/* Screen Content */}
        {passengerScreen === "dashboard" && (
          <PassengerDashboard
            user={user}
            onFindRoute={() => setPassengerScreen("find-route")}
          />
        )}

        {passengerScreen === "find-route" && (
          <FindRoute
            user={user}
            onRequestRide={(route) => {
              setSelectedRoute(route);
              setPassengerScreen("request");
            }}
            onBack={() => setPassengerScreen("dashboard")}
          />
        )}

        {passengerScreen === "request" && selectedRoute && (
          <RideRequest
            route={selectedRoute}
            user={user}
            onConfirm={async () => {
              // Create ride request
              const rideId = `ride_${Date.now()}`;
              setCurrentRideId(rideId);
              setPassengerScreen("live-trip");
            }}
            onCancel={() => {
              setSelectedRoute(null);
              setPassengerScreen("find-route");
            }}
          />
        )}

        {passengerScreen === "live-trip" && currentRideId && (
          <LiveTrip
            user={user}
            rideId={currentRideId}
            onComplete={() => {
              setCompletedRide({ id: currentRideId, fare: 5000, totalAmount: 5500 });
              setPassengerScreen("payment");
            }}
          />
        )}

        {passengerScreen === "payment" && completedRide && (
          <PaymentRating
            ride={completedRide}
            user={user}
            onComplete={() => {
              setCompletedRide(null);
              setCurrentRideId(null);
              setPassengerScreen("dashboard");
            }}
          />
        )}

        {passengerScreen === "wallet" && (
          <Wallet user={user} role="passenger" />
        )}

        {passengerScreen === "profile" && (
          <Profile user={user} role="passenger" onLogout={handleLogout} />
        )}

        {/* Bottom Navigation */}
        <BottomNav
          activeTab={activeTab}
          onTabChange={handleBottomNavChange}
          role="passenger"
        />

        {/* FAB for Find Route */}
        {passengerScreen === "dashboard" && (
          <FloatingActionButton
            onClick={() => setPassengerScreen("find-route")}
            icon={<Plus className="w-6 h-6" />}
          />
        )}
      </div>
    );
  }

  return null;
}
