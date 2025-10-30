/* global use, db */
// MongoDB Playground

// 🔹 Төслийн дата сангийн нэр
const database = "ubcarpool";

// 🔹 Төслийн үндсэн collection-ууд
const collections = [
  "users",
  "wallets",
  "rides",
  "routes",
  "transactions",
  "ratings",
];

// 🧱 Database руу шилжих
use(database);

// 🔧 Collection-ууд үүсгэх
collections.forEach((c) => {
  if (!db.getCollectionNames().includes(c)) {
    db.createCollection(c);
    print(`✅ Created collection: ${c}`);
  } else {
    print(`⚠️ Already exists: ${c}`);
  }
});
