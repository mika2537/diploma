import { useState, useEffect } from "react";
import { Button } from "../ui/button";
import { Input } from "../ui/input";
import { ArrowUpRight, ArrowDownLeft, DollarSign, Plus } from "lucide-react";
import { projectId, publicAnonKey } from "../../utils/supabase/info";

interface WalletProps {
  user: any;
  role: "driver" | "passenger";
}

export function Wallet({ user, role }: WalletProps) {
  const [balance, setBalance] = useState(0);
  const [transactions, setTransactions] = useState<any[]>([]);
  const [showAddMoney, setShowAddMoney] = useState(false);
  const [showWithdraw, setShowWithdraw] = useState(false);
  const [amount, setAmount] = useState("");
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    loadWalletData();
  }, [user.id]);

  const loadWalletData = async () => {
    try {
      const response = await fetch(
        `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/wallet?userId=${user.id}`,
        {
          headers: {
            Authorization: `Bearer ${publicAnonKey}`,
          },
        }
      );

      if (response.ok) {
        const data = await response.json();
        setBalance(data.balance || 0);
        setTransactions(data.transactions || []);
      }
    } catch (err) {
      console.error("Failed to load wallet:", err);
    }
  };

  const handleAddMoney = async () => {
    if (!amount || parseFloat(amount) <= 0) {
      alert("Дүн оруулна уу");
      return;
    }

    setLoading(true);
    try {
      const response = await fetch(
        `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/wallet/add`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${publicAnonKey}`,
          },
          body: JSON.stringify({
            userId: user.id,
            amount: parseFloat(amount),
          }),
        }
      );

      if (response.ok) {
        alert("Мөнгө амжилттай нэмэгдлээ!");
        setShowAddMoney(false);
        setAmount("");
        loadWalletData();
      }
    } catch (err) {
      console.error("Failed to add money:", err);
      alert("Мөнгө нэмэхэд алдаа гарлаа");
    } finally {
      setLoading(false);
    }
  };

  const handleWithdraw = async () => {
    if (!amount || parseFloat(amount) <= 0) {
      alert("Дүн оруулна уу");
      return;
    }

    if (parseFloat(amount) > balance) {
      alert("Үлдэгдэл хүрэлцэхгүй байна");
      return;
    }

    setLoading(true);
    try {
      const response = await fetch(
        `https://${projectId}.supabase.co/functions/v1/make-server-ec1b9b7f/wallet/withdraw`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${publicAnonKey}`,
          },
          body: JSON.stringify({
            userId: user.id,
            amount: parseFloat(amount),
          }),
        }
      );

      if (response.ok) {
        alert("Мөнгө амжилттай татагдлаа!");
        setShowWithdraw(false);
        setAmount("");
        loadWalletData();
      }
    } catch (err) {
      console.error("Failed to withdraw:", err);
      alert("Мөнгө татахад алдаа гарлаа");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="pb-20 px-4 pt-6 max-w-md mx-auto">
      <h2 className="mb-6">Хэтэвч</h2>

      {/* Balance Card */}
      <div className="bg-gradient-to-br from-primary to-primary/80 text-primary-foreground rounded-3xl p-6 mb-6 shadow-xl">
        <p className="text-sm opacity-90 mb-2">Нийт үлдэгдэл</p>
        <h1 className="text-5xl mb-6">{balance.toLocaleString()}₮</h1>

        <div className="grid grid-cols-2 gap-3">
          <Button
            onClick={() => setShowAddMoney(true)}
            variant="secondary"
            className="bg-white/20 hover:bg-white/30 text-white border-0"
          >
            <Plus className="w-5 h-5 mr-2" />
            Нэмэх
          </Button>
          {role === "driver" && (
            <Button
              onClick={() => setShowWithdraw(true)}
              variant="secondary"
              className="bg-white/20 hover:bg-white/30 text-white border-0"
            >
              <ArrowUpRight className="w-5 h-5 mr-2" />
              Татах
            </Button>
          )}
        </div>
      </div>

      {/* Transactions */}
      <div>
        <h3 className="mb-3">Гүйлгээний түүх</h3>

        {transactions.length === 0 ? (
          <div className="bg-card border border-border rounded-2xl p-8 text-center">
            <DollarSign className="w-12 h-12 mx-auto mb-3 text-muted-foreground" />
            <p className="text-muted-foreground">Гүйлгээ олдсонгүй</p>
          </div>
        ) : (
          <div className="space-y-2">
            {transactions.map((tx: any, idx: number) => (
              <TransactionItem key={idx} transaction={tx} />
            ))}
          </div>
        )}
      </div>

      {/* Add Money Modal */}
      {showAddMoney && (
        <div className="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-6">
          <div className="bg-card rounded-2xl p-6 w-full max-w-md">
            <h3 className="mb-4">Мөнгө нэмэх</h3>
            <Input
              type="number"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              placeholder="Дүн оруулах (₮)"
              className="mb-4"
            />
            <div className="flex gap-3">
              <Button
                onClick={() => {
                  setShowAddMoney(false);
                  setAmount("");
                }}
                variant="outline"
                className="flex-1"
              >
                Цуцлах
              </Button>
              <Button onClick={handleAddMoney} disabled={loading} className="flex-1">
                {loading ? "Нэмж байна..." : "Нэмэх"}
              </Button>
            </div>
          </div>
        </div>
      )}

      {/* Withdraw Modal */}
      {showWithdraw && (
        <div className="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-6">
          <div className="bg-card rounded-2xl p-6 w-full max-w-md">
            <h3 className="mb-4">Мөнгө татах</h3>
            <p className="text-sm text-muted-foreground mb-4">
              Үлдэгдэл: {balance.toLocaleString()}₮
            </p>
            <Input
              type="number"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              placeholder="Дүн оруулах (₮)"
              className="mb-4"
            />
            <div className="flex gap-3">
              <Button
                onClick={() => {
                  setShowWithdraw(false);
                  setAmount("");
                }}
                variant="outline"
                className="flex-1"
              >
                Цуцлах
              </Button>
              <Button onClick={handleWithdraw} disabled={loading} className="flex-1">
                {loading ? "Татаж байна..." : "Татах"}
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function TransactionItem({ transaction }: { transaction: any }) {
  const isIncoming = transaction.type === "incoming" || transaction.type === "add";

  return (
    <div className="bg-card border border-border rounded-xl p-4 flex items-center justify-between">
      <div className="flex items-center gap-3">
        <div
          className={`w-10 h-10 rounded-full flex items-center justify-center ${
            isIncoming ? "bg-secondary/10" : "bg-destructive/10"
          }`}
        >
          {isIncoming ? (
            <ArrowDownLeft className="w-5 h-5 text-secondary" />
          ) : (
            <ArrowUpRight className="w-5 h-5 text-destructive" />
          )}
        </div>
        <div>
          <p>{transaction.description || "Гүйлгээ"}</p>
          <p className="text-sm text-muted-foreground">
            {transaction.date || "Өнөөдөр"}
          </p>
        </div>
      </div>
      <p className={isIncoming ? "text-secondary" : "text-destructive"}>
        {isIncoming ? "+" : "-"}
        {transaction.amount.toLocaleString()}₮
      </p>
    </div>
  );
}
