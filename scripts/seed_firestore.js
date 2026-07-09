#!/usr/bin/env node
/**
 * Seeds Firestore products from assets/seed/products_catalog.json
 *
 * Usage:
 *   node scripts/seed_firestore.js
 *
 * Requires GOOGLE_APPLICATION_CREDENTIALS or Firebase CLI login.
 */
const admin = require("firebase-admin");
const fs = require("fs");
const path = require("path");

const catalogPath = path.join(
  __dirname,
  "..",
  "assets",
  "seed",
  "products_catalog.json"
);

function toFirestoreProduct(product) {
  const data = {
    name: product.name,
    description: product.description,
    price: product.price,
    images: product.images,
    categoryId: product.categoryId,
    inStock: product.inStock,
    stockQuantity: product.stockQuantity,
    rating: product.rating,
    reviewCount: product.reviewCount,
    featured: product.featured,
    createdAt: product.createdAt,
  };

  if (product.salePrice != null) {
    data.salePrice = product.salePrice;
  }

  return data;
}

async function main() {
  if (!admin.apps.length) {
    admin.initializeApp();
  }

  const products = JSON.parse(fs.readFileSync(catalogPath, "utf8"));
  const db = admin.firestore();
  const batch = db.batch();

  for (const product of products) {
    const ref = db.collection("products").doc(product.id);
    batch.set(ref, toFirestoreProduct(product), { merge: true });
  }

  await batch.commit();
  console.log(`Seeded ${products.length} products to Firestore.`);
}

main().catch(() => {
  console.error("Seed failed.");
  process.exit(1);
});
