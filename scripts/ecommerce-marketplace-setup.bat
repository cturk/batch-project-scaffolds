@echo off
echo Starting E-commerce Marketplace Project Setup...

REM Create project directory structure
echo Creating project directory structure...
mkdir ecommerce-marketplace
cd ecommerce-marketplace
mkdir src
cd src
mkdir app
mkdir components
mkdir features
mkdir lib
mkdir services
mkdir utils
mkdir styles
mkdir hooks
cd ..
mkdir prisma
mkdir public
mkdir scripts
mkdir tests

REM Initialize Node project
echo Initializing Node project...
call npm init -y

REM Install core dependencies
echo Installing core dependencies...
call npm install next@latest react@latest react-dom@latest
call npm install @prisma/client
call npm install @tanstack/react-query
call npm install stripe @stripe/stripe-js
call npm install @stripe/react-stripe-js
call npm install next-auth @next-auth/prisma-adapter
call npm install tailwindcss@latest postcss@latest autoprefixer@latest
call npm install zod
call npm install react-hook-form @hookform/resolvers
call npm install axios
call npm install framer-motion
call npm install react-icons
call npm install @radix-ui/react-dialog
call npm install @radix-ui/react-dropdown-menu
call npm install @radix-ui/react-toast
call npm install react-hot-toast
call npm install next-cloudinary
call npm install @prisma/extension-accelerate

REM Install development dependencies
echo Installing development dependencies...
call npm install -D typescript @types/react @types/node @types/react-dom
call npm install -D prisma
call npm install -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
call npm install -D prettier prettier-plugin-tailwindcss
call npm install -D jest @testing-library/react @testing-library/jest-dom
call npm install -D vitest @vitest/coverage-c8
call npm install -D playwright

REM Initialize TypeScript configuration
echo Creating TypeScript configuration...
echo {
echo   "compilerOptions": {
echo     "target": "es5",
echo     "lib": ["dom", "dom.iterable", "esnext"],
echo     "allowJs": true,
echo     "skipLibCheck": true,
echo     "strict": true,
echo     "noEmit": true,
echo     "esModuleInterop": true,
echo     "module": "esnext",
echo     "moduleResolution": "bundler",
echo     "resolveJsonModule": true,
echo     "isolatedModules": true,
echo     "jsx": "preserve",
echo     "incremental": true,
echo     "plugins": [{ "name": "next" }],
echo     "paths": {
echo       "@/*": ["./src/*"]
echo     }
echo   },
echo   "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
echo   "exclude": ["node_modules"]
echo } > tsconfig.json

REM Create Prisma schema
echo Creating Prisma schema...
echo datasource db {
echo   provider = "postgresql"
echo   url      = env("DATABASE_URL")
echo }
echo.
echo generator client {
echo   provider = "prisma-client-js"
echo   previewFeatures = ["fullTextSearch", "fullTextIndex"]
echo }
echo.
echo enum UserRole {
echo   BUYER
echo   SELLER
echo   ADMIN
echo }
echo.
echo enum ProductStatus {
echo   DRAFT
echo   ACTIVE
echo   ARCHIVED
echo }
echo.
echo model User {
echo   id            String    @id @default(cuid())
echo   name          String?
echo   email         String    @unique
echo   emailVerified DateTime?
echo   image         String?
echo   role         UserRole  @default(BUYER)
echo   products     Product[]
echo   orders       Order[]
echo   accounts     Account[]
echo   sessions     Session[]
echo   createdAt    DateTime  @default(now())
echo   updatedAt    DateTime  @updatedAt
echo }
echo.
echo model Product {
echo   id          String        @id @default(cuid())
echo   name        String
echo   description String?
echo   price       Decimal
echo   stock       Int
echo   imageUrls   String[]
echo   status      ProductStatus @default(DRAFT)
echo   sellerId    String
echo   seller      User          @relation(fields: [sellerId], references: [id])
echo   category    Category?     @relation(fields: [categoryId], references: [id])
echo   categoryId  String?
echo   orders      OrderItem[]
echo   createdAt   DateTime      @default(now())
echo   updatedAt   DateTime      @updatedAt
echo }
echo.
echo model Category {
echo   id          String    @id @default(cuid())
echo   name        String    @unique
echo   description String?
echo   products    Product[]
echo }
echo.
echo model Order {
echo   id          String       @id @default(cuid())
echo   userId      String
echo   user        User         @relation(fields: [userId], references: [id])
echo   items       OrderItem[]
echo   total       Decimal
echo   status      String
echo   stripePaymentIntentId String?
echo   createdAt   DateTime     @default(now())
echo   updatedAt   DateTime     @updatedAt
echo }
echo.
echo model OrderItem {
echo   id          String   @id @default(cuid())
echo   orderId     String
echo   order       Order    @relation(fields: [orderId], references: [id])
echo   productId   String
echo   product     Product  @relation(fields: [productId], references: [id])
echo   quantity    Int
echo   price       Decimal
echo }
echo.
echo