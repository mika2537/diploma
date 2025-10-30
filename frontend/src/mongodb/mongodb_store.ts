import { MongoClient } from "npm:mongodb";

// ⚙️ MongoDB-тэй холбогдох
const client = new MongoClient(
  "mongodb+srv://mika:guhbac-guqce9-Syqjum@voting.e2szuse.mongodb.net/"
);
await client.connect();

// 📦 Database ба Collection тодорхойлох
const db = client.db("ubcarpool"); // чиний хүссэн нэр, автоматаар үүснэ
const collection = db.collection("kv_store");

// ✅ Key-value set
export const set = async (key: string, value: any): Promise<void> => {
  await collection.updateOne(
    { key },
    { $set: { key, value } },
    { upsert: true }
  );
};

// ✅ Get by key
export const get = async (key: string): Promise<any> => {
  const doc = await collection.findOne({ key });
  return doc?.value ?? null;
};

// ✅ Delete key
export const del = async (key: string): Promise<void> => {
  await collection.deleteOne({ key });
};

// ✅ Get multiple by prefix
export const getByPrefix = async (prefix: string): Promise<any[]> => {
  const docs = await collection
    .find({ key: { $regex: `^${prefix}` } })
    .toArray();
  return docs.map((d) => d.value);
};
