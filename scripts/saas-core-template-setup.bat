@echo off
echo Starting SaaS Core Project Setup...

REM Create project directory structure
echo Creating project directory structure...
mkdir saas-core-platform
cd saas-core-platform
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
mkdir admin
mkdir billing
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
call npm install stripe @stripe/stripe-js @stripe/react-stripe-js
call npm install next-themes

REM Install authorization and access control
echo Installing authorization dependencies...
call npm install @casl/ability @casl/react

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
echo   USER
echo   ADMIN
echo   MEMBER
echo   OWNER
echo }
echo.
echo enum SubscriptionStatus {
echo   ACTIVE
echo   CANCELED
echo   PAST_DUE
echo   UNPAID
echo   INCOMPLETE
echo }
echo.
echo model User {
echo   id            String    @id @default(cuid())
echo   name          String?
echo   email         String    @unique
echo   emailVerified DateTime?
echo   image         String?
echo   role         UserRole  @default(USER)
echo   accounts     Account[]
echo   sessions     Session[]
echo   subscription Subscription?
echo   organizations Organization[]
echo   memberships  OrganizationMember[]
echo   createdAt    DateTime  @default(now())
echo   updatedAt    DateTime  @updatedAt
echo }
echo.
echo model Organization {
echo   id          String    @id @default(cuid())
echo   name        String
echo   description String?
echo   ownerId     String
echo   owner       User      @relation(fields: [ownerId], references: [id])
echo   members     OrganizationMember[]
echo   createdAt   DateTime  @default(now())
echo   updatedAt   DateTime  @updatedAt
echo }
echo.
echo model OrganizationMember {
echo   id             String       @id @default(cuid())
echo   userId         String
echo   user           User         @relation(fields: [userId], references: [id])
echo   organizationId String
echo   organization   Organization @relation(fields: [organizationId], references: [id])
echo   role           UserRole     @default(MEMBER)
echo   joinedAt       DateTime     @default(now())
echo }
echo.
echo model Subscription {
echo   id                 String             @id @default(cuid())
echo   userId             String             @unique
echo   user               User               @relation(fields: [userId], references: [id])
echo   stripeCustomerId   String             @unique
echo   stripeSubscriptionId String?          @unique
echo   status             SubscriptionStatus @default(INCOMPLETE)
echo   currentPeriodEnd   DateTime?
echo   cancelAtPeriodEnd  Boolean            @default(false)
echo   plan               SubscriptionPlan   @relation(fields: [planId], references: [id])
echo   planId             String
echo   createdAt          DateTime           @default(now())
echo   updatedAt          DateTime           @updatedAt
echo }
echo.
echo model SubscriptionPlan {
echo   id               String         @id @default(cuid())
echo   name             String
echo   stripeProductId  String         @unique
echo   stripePriceId    String         @unique
echo   description      String?
echo   features         String[]
echo   subscriptions    Subscription[]
echo   isActive         Boolean        @default(true)
echo   createdAt        DateTime       @default(now())
echo }
echo.
echo model Account {
echo   id                 String  @id @default(cuid())
echo   userId             String
echo   type               String
echo   provider           String
echo   providerAccountId  String
echo   refresh_token      String? @db.Text
echo   access_token       String? @db.Text
echo   expires_at         Int?
echo   token_type         String?
echo   scope              String?
echo   id_token           String? @db.Text
echo   session_state      String?
echo   user               User    @relation(fields: [userId], references: [id], onDelete: Cascade)
echo   @@unique([provider, providerAccountId])
echo }
echo.
echo model Session {
echo   id           String   @id @default(cuid())
echo   sessionToken String   @unique
echo   userId       String
echo   expires      DateTime
echo   user         User     @relation(fields: [userId], references: [id], onDelete: Cascade)
echo } > prisma\schema.prisma

REM Create authentication options
echo Creating authentication options...
mkdir src\lib\auth
echo import { PrismaAdapter } from "@next-auth/prisma-adapter";
echo import { prisma } from "../prisma";
echo import { NextAuthOptions } from "next-auth";
echo import GoogleProvider from "next-auth/providers/google";
echo import GithubProvider from "next-auth/providers/github";
echo import EmailProvider from "next-auth/providers/email";
echo.
echo export const authOptions: NextAuthOptions = {
echo   adapter: PrismaAdapter(prisma),
echo   providers: [
echo     GoogleProvider({
echo       clientId: process.env.GOOGLE_CLIENT_ID!,
echo       clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
echo     }),
echo     GithubProvider({
echo       clientId: process.env.GITHUB_ID!,
echo       clientSecret: process.env.GITHUB_SECRET!,
echo     }),
echo     EmailProvider({
echo       server: {
echo         host: process.env.EMAIL_SERVER_HOST,
echo         port: process.env.EMAIL_SERVER_PORT,
echo         auth: {
echo           user: process.env.EMAIL_SERVER_USER,
echo           pass: process.env.EMAIL_SERVER_PASSWORD
echo         }
echo       },
echo       from: process.env.EMAIL_FROM
echo     })
echo   ],
echo   callbacks: {
echo     session: async ({ session, user }) => {
echo       if (session.user) {
echo         session.user.id = user.id;
echo         session.user.role = user.role;
echo       }
echo       return session;
echo     },
echo   },
echo   pages: {
echo     signIn: "/auth/signin",
echo     signOut: "/auth/signout",
echo     error: "/auth/error",
echo     verifyRequest: "/auth/verify-request",
echo     newUser: "/onboarding"
echo   },
echo }; > src\lib\auth\auth-options.ts

REM Create access control utility
echo Creating access control utility...
mkdir src\lib\authorization
echo import { defineAbility } from '@casl/ability';
echo import { User, UserRole } from '@prisma/client';
echo.
echo export function defineUserAbilities(user: User) {
echo   return defineAbility((can) => {
echo     // General user permissions
echo     can('read', 'Profile');
echo     can('update', 'Profile', { id: user.id });
echo.
echo     // Role-specific permissions
echo     switch(user.role) {
echo       case UserRole.ADMIN:
echo         can('manage', 'all');
echo         break;
echo       case UserRole.OWNER:
echo         can('manage', 'Organization');
echo         can('invite', 'OrganizationMembers');
echo         break;
echo       case UserRole.MEMBER:
echo         can('read', 'Organization');
echo         break;
echo       default:
echo         can('read', 'public');
echo     }
echo   });
echo } > src\lib\authorization\abilities.ts

REM Create Stripe webhook handler
echo Creating Stripe webhook handler...
mkdir src\pages\api\webhooks
echo import { buffer } from 'micro';
echo import Stripe from 'stripe';
echo import { prisma } from '../../../lib/prisma';
echo.
echo const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
echo   apiVersion: '2023-10-16'
echo });
echo.
echo export const config = {
echo   api: {
echo     bodyParser: false
echo   }
echo };
echo.
echo export default async function handler(req, res) {
echo   if (req.method === 'POST') {
echo     const buf = await buffer(req);
echo     const sig = req.headers['stripe-signature'];
echo.
echo     let event;
echo.
echo     try {
echo       event = stripe.webhooks.constructEvent(
echo         buf,
echo         sig,
echo         process.env.STRIPE_WEBHOOK_SECRET!
echo       );
echo     } catch (err) {
echo       return res.status(400).send(`Webhook Error: ${err.message}`);
echo     }
echo.
echo     switch (event.type) {
echo       case 'customer.subscription.updated':
echo         await handleSubscriptionUpdate(event.data.object);
echo         break;
echo       case 'customer.subscription.deleted':
echo         await handleSubscriptionDeleted(event.data.object);
echo         break;
echo       // Handle other relevant events
echo     }
echo.
echo     res.json({ received: true });
echo   } else {
echo     res.setHeader('Allow', 'POST');
echo     res.status(405).end('Method Not Allowed');
echo   }
echo }
echo.
echo async function handleSubscriptionUpdate(subscription) {
echo   await prisma.subscription.update({
echo     where: { stripeSubscriptionId: subscription.id },
echo     data: {
echo       status: subscription.status,
echo       currentPeriodEnd: new Date(subscription.current_period_end * 1000),
echo       cancelAtPeriodEnd: subscription.cancel_at_period_end
echo     }
echo   });
echo }
echo.
echo async function handleSubscriptionDeleted(subscription) {
echo   await prisma.subscription.update({
echo     where: { stripeSubscriptionId: subscription.id },
echo     data: {
echo       status: 'CANCELED',
echo       stripeSubscriptionId: null
echo     }
echo   });
echo } > src\pages\api\webhooks\stripe.ts

REM Create example environment file
echo Creating environment files...
echo # Database Connection>.env.example
echo DATABASE_URL="postgresql://user:password@localhost:5432/saas_core?schema=public">>.env.example
echo.>>.env.example
echo # Next Auth>>.env.example
echo NEXTAUTH_URL="http://localhost:3000">>.env.example
echo NEXTAUTH_SECRET="your-nextauth-secret">>.env.example
echo.>>.env.example
echo # OAuth Providers>>.env.example
echo GOOGLE_CLIENT_ID="your-google-client-id">>.env.example
echo GOOGLE_CLIENT_SECRET="your-google-client-secret">>.env.example
echo GITHUB_ID="your-github-id">>.env.example
echo GITHUB_SECRET="your-github-secret">>.env.example
echo.>>.env.example
echo # Email Provider>>.env.example
echo EMAIL_SERVER_HOST="smtp.example.com">>.env.example
echo EMAIL_SERVER_PORT=587>>.env.example
echo EMAIL_SERVER_USER="your-email-user">>.env.example
echo EMAIL_SERVER_PASSWORD="your-email-password">>.env.example
echo EMAIL_FROM="noreply@yourdomain.com">>.env.example
echo.>>.env.example
echo # Stripe>>.env.example
echo STRIPE_SECRET_KEY="your-stripe-secret-key">>.env.example
echo STRIPE_PUBLISHABLE_KEY="your-stripe-publishable-key">>.env.example
echo STRIPE_WEBHOOK_SECRET="your-stripe-webhook-secret">>.env.example

REM Update package.json scripts
echo Updating package.json scripts...
call npm pkg set scripts.dev="next dev"
call npm pkg set scripts.build="next build"
call npm pkg set scripts.start="next start"
call npm pkg set scripts.lint="next lint"
call npm pkg set scripts.test="vitest"
call npm pkg set scripts.test:coverage="vitest run --coverage"
call npm pkg set scripts.prisma:generate="prisma generate"
call npm pkg set scripts.prisma:migrate="prisma migrate dev"
call npm pkg set scripts.stripe:listen="stripe listen --forward-to localhost:3000/api/webhooks/stripe"

REM Create README
echo Creating README.md...
echo # SaaS Core Platform > README.md
echo. >> README.md
echo ## Getting Started >> README.md
echo. >> README.md
echo 1. Clone the repository >> README.md
echo 2. Copy `.env.example` to `.env` and update the values >> README.md
echo 3. Install dependencies: >> README.md
echo    \`\`\`bash >> README.md
echo    npm install >> README.md
echo    \`\`\` >> README.md
echo 4. Generate Prisma client: >> README.md
echo    \`\`\`bash >> README.md
echo    npm run prisma:generate >> README.md
echo    \`\`\` >> README.md
echo 5. Run database migrations: >> README.md
echo    \`\`\`bash >> README.md
echo    npm run prisma:migrate