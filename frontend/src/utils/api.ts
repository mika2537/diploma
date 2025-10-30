interface ImportMetaEnv {
  readonly VITE_API_BASE_URL?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}

export const API_BASE_URL =
  import.meta.env.VITE_API_BASE_URL || "http://localhost:5050/api";
