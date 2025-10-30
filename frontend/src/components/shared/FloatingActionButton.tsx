import { Plus } from "lucide-react";

interface FloatingActionButtonProps {
  onClick: () => void;
  icon?: React.ReactNode;
  label?: string;
}

export function FloatingActionButton({ onClick, icon, label }: FloatingActionButtonProps) {
  return (
    <button
      onClick={onClick}
      className="fixed bottom-24 right-6 bg-primary text-primary-foreground rounded-full p-4 shadow-xl hover:shadow-2xl transition-all hover:scale-110 z-40 flex items-center gap-2"
    >
      {icon || <Plus className="w-6 h-6" />}
      {label && <span className="pr-2">{label}</span>}
    </button>
  );
}
