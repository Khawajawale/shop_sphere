export interface ProductSeed {
  id: string;
  name: string;
  description: string;
  price: number;
  salePrice?: number;
  images: string[];
  categoryId: string;
  inStock: boolean;
  stockQuantity: number;
  rating: number;
  reviewCount: number;
  featured: boolean;
  createdAt: string;
}

// Canonical catalog — keep in sync with assets/seed/products_catalog.json
export const productSeedData: ProductSeed[] = [
  {
    id: "prod-001",
    name: "AirPods Pro (2nd Gen)",
    description:
      "Active noise cancellation, adaptive transparency, and personalized spatial audio for an immersive listening experience.",
    price: 249.99,
    salePrice: 199.99,
    images: ["https://picsum.photos/seed/airpods/600/600"],
    categoryId: "electronics",
    inStock: true,
    stockQuantity: 42,
    rating: 4.8,
    reviewCount: 1240,
    featured: true,
    createdAt: "2026-03-01T00:00:00.000Z",
  },
  {
    id: "prod-002",
    name: "Galaxy Watch Ultra",
    description:
      "Premium titanium smartwatch with advanced health tracking, GPS, and multi-day battery life.",
    price: 649.99,
    images: ["https://picsum.photos/seed/galaxywatch/600/600"],
    categoryId: "electronics",
    inStock: true,
    stockQuantity: 18,
    rating: 4.6,
    reviewCount: 532,
    featured: true,
    createdAt: "2026-02-20T00:00:00.000Z",
  },
  {
    id: "prod-003",
    name: "Premium Leather Jacket",
    description:
      "Handcrafted full-grain leather jacket with minimalist design and premium lining for all-season comfort.",
    price: 289.0,
    salePrice: 229.0,
    images: ["https://picsum.photos/seed/leatherjacket/600/600"],
    categoryId: "fashion",
    inStock: true,
    stockQuantity: 25,
    rating: 4.7,
    reviewCount: 318,
    featured: true,
    createdAt: "2026-02-15T00:00:00.000Z",
  },
  {
    id: "prod-004",
    name: "Urban Runner Sneakers",
    description:
      "Lightweight performance sneakers with responsive cushioning and breathable knit upper.",
    price: 129.99,
    images: ["https://picsum.photos/seed/sneakers/600/600"],
    categoryId: "fashion",
    inStock: true,
    stockQuantity: 60,
    rating: 4.5,
    reviewCount: 890,
    featured: true,
    createdAt: "2026-01-28T00:00:00.000Z",
  },
  {
    id: "prod-005",
    name: "Minimalist Desk Lamp",
    description:
      "Adjustable LED desk lamp with warm-to-cool color temperature and touch dimming controls.",
    price: 79.99,
    salePrice: 59.99,
    images: ["https://picsum.photos/seed/desklamp/600/600"],
    categoryId: "home",
    inStock: true,
    stockQuantity: 35,
    rating: 4.4,
    reviewCount: 210,
    featured: true,
    createdAt: "2026-02-05T00:00:00.000Z",
  },
  {
    id: "prod-006",
    name: "Ceramic Planter Set",
    description:
      "Set of three matte ceramic planters with drainage trays, perfect for modern interiors.",
    price: 49.99,
    images: ["https://picsum.photos/seed/planter/600/600"],
    categoryId: "home",
    inStock: true,
    stockQuantity: 80,
    rating: 4.3,
    reviewCount: 156,
    featured: false,
    createdAt: "2026-01-10T00:00:00.000Z",
  },
  {
    id: "prod-007",
    name: "Vitamin C Serum",
    description:
      "Brightening serum with 20% vitamin C, hyaluronic acid, and vitamin E for radiant skin.",
    price: 34.99,
    salePrice: 27.99,
    images: ["https://picsum.photos/seed/serum/600/600"],
    categoryId: "beauty",
    inStock: true,
    stockQuantity: 120,
    rating: 4.6,
    reviewCount: 742,
    featured: true,
    createdAt: "2026-02-18T00:00:00.000Z",
  },
  {
    id: "prod-008",
    name: "Luxury Face Cream",
    description:
      "Rich moisturizing cream with peptides and botanical extracts for deep hydration.",
    price: 68.0,
    images: ["https://picsum.photos/seed/facecream/600/600"],
    categoryId: "beauty",
    inStock: true,
    stockQuantity: 45,
    rating: 4.5,
    reviewCount: 423,
    featured: false,
    createdAt: "2026-01-22T00:00:00.000Z",
  },
  {
    id: "prod-009",
    name: "Pro Yoga Mat",
    description:
      "Extra-thick non-slip yoga mat with alignment lines and eco-friendly TPE material.",
    price: 59.99,
    salePrice: 44.99,
    images: ["https://picsum.photos/seed/yogamat/600/600"],
    categoryId: "sports",
    inStock: true,
    stockQuantity: 55,
    rating: 4.7,
    reviewCount: 389,
    featured: true,
    createdAt: "2026-02-25T00:00:00.000Z",
  },
  {
    id: "prod-010",
    name: "Adjustable Dumbbell Set",
    description:
      "Space-saving adjustable dumbbells from 5 to 52.5 lbs with quick-change dial system.",
    price: 399.99,
    images: ["https://picsum.photos/seed/dumbbell/600/600"],
    categoryId: "sports",
    inStock: true,
    stockQuantity: 12,
    rating: 4.9,
    reviewCount: 678,
    featured: false,
    createdAt: "2026-01-05T00:00:00.000Z",
  },
  {
    id: "prod-011",
    name: "STEM Building Kit",
    description:
      "Educational robotics kit with 200+ pieces for creative engineering and coding projects.",
    price: 89.99,
    salePrice: 74.99,
    images: ["https://picsum.photos/seed/stemkit/600/600"],
    categoryId: "toys",
    inStock: true,
    stockQuantity: 30,
    rating: 4.8,
    reviewCount: 267,
    featured: true,
    createdAt: "2026-03-03T00:00:00.000Z",
  },
  {
    id: "prod-012",
    name: "Plush Adventure Bear",
    description:
      "Ultra-soft collectible plush bear with premium stitching and hypoallergenic fill.",
    price: 29.99,
    images: ["https://picsum.photos/seed/plushbear/600/600"],
    categoryId: "toys",
    inStock: true,
    stockQuantity: 100,
    rating: 4.6,
    reviewCount: 512,
    featured: false,
    createdAt: "2026-02-08T00:00:00.000Z",
  },
  {
    id: "prod-013",
    name: "4K Action Camera",
    description:
      "Waterproof action camera with 4K60 recording, image stabilization, and wide-angle lens.",
    price: 349.99,
    salePrice: 299.99,
    images: ["https://picsum.photos/seed/actioncam/600/600"],
    categoryId: "electronics",
    inStock: true,
    stockQuantity: 22,
    rating: 4.5,
    reviewCount: 445,
    featured: false,
    createdAt: "2026-01-18T00:00:00.000Z",
  },
  {
    id: "prod-014",
    name: "Linen Summer Dress",
    description:
      "Breathable linen midi dress with relaxed fit and side pockets for effortless style.",
    price: 89.0,
    images: ["https://picsum.photos/seed/linendress/600/600"],
    categoryId: "fashion",
    inStock: true,
    stockQuantity: 40,
    rating: 4.4,
    reviewCount: 198,
    featured: false,
    createdAt: "2026-02-12T00:00:00.000Z",
  },
  {
    id: "prod-015",
    name: "Smart Home Hub",
    description:
      "Central smart home controller compatible with major ecosystems and voice assistants.",
    price: 129.99,
    salePrice: 99.99,
    images: ["https://picsum.photos/seed/smarthub/600/600"],
    categoryId: "electronics",
    inStock: false,
    stockQuantity: 0,
    rating: 4.2,
    reviewCount: 167,
    featured: false,
    createdAt: "2026-01-30T00:00:00.000Z",
  },
];

export function toFirestoreProduct(product: ProductSeed): Record<string, unknown> {
  const data: Record<string, unknown> = {
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
