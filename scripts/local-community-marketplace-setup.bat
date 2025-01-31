@echo off
echo Starting Local Community Marketplace Project Setup...

REM Create project directory structure
echo Creating project directory structure...
mkdir local-community-marketplace
cd local-community-marketplace
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
mkdir marketplace
mkdir events
mkdir resources
mkdir reputation
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
call npm install leaflet
call npm install react-leaflet

REM Install community and marketplace dependencies
echo Installing community marketplace dependencies...
call npm install @prisma/extension-accelerate
call npm install socket.io-client
call npm install geolib
call npm install moment
call npm install @uploadthing/react

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
echo   previewFeatures = ["fullTextSearch", "fullTextIndex", "postgresqlExtensions"]
echo }
echo.
echo enum ListingType {
echo   SERVICE
echo   ITEM
echo   EVENT
echo   RESOURCE
echo }
echo.
echo enum ListingStatus {
echo   ACTIVE
echo   PENDING
echo   COMPLETED
echo   CANCELLED
echo }
echo.
echo enum ReputationLevel {
echo   NEWCOMER
echo   COMMUNITY_MEMBER
echo   TRUSTED_CONTRIBUTOR
echo   COMMUNITY_LEADER
echo }
echo.
echo enum InteractionType {
echo   OFFER
echo   REQUEST
echo   EXCHANGE
echo   DONATION
echo }
echo.
echo model User {
echo   id            String    @id @default(cuid())
echo   name          String
echo   email         String    @unique
echo   emailVerified DateTime?
echo   image         String?
echo   location      Location?
echo   neighborhood  String?
echo   bio           String?
echo   phone         String?
echo   accounts      Account[]
echo   sessions      Session[]
echo   listings      Listing[]
echo   interactions  CommunityInteraction[]
echo   events        Event[]
echo   skills        Skill[]
echo   reputation    UserReputation?
echo   reviews       Review[]
echo   givenReviews  Review[]  @relation("GivenReviews")
echo   createdAt     DateTime  @default(now())
echo   updatedAt     DateTime  @updatedAt
echo }
echo.
echo model Location {
echo   id          String    @id @default(cuid())
echo   userId      String    @unique
echo   user        User      @relation(fields: [userId], references: [id])
echo   latitude    Float
echo   longitude   Float
echo   address     String?
echo   city        String
echo   state       String
echo   zipCode     String
echo }
echo.
echo model Skill {
echo   id          String    @id @default(cuid())
echo   name        String    @unique
echo   description String?
echo   category    String?
echo   users       User[]
echo }
echo.
echo model Listing {
echo   id          String        @id @default(cuid())
echo   title       String
echo   description String
echo   type        ListingType
echo   status      ListingStatus @default(ACTIVE)
echo   userId      String
echo   user        User          @relation(fields: [userId], references: [id])
echo   category    String?
echo   tags        String[]
echo   price       Decimal?
echo   location    String?
echo   imageUrls   String[]
echo   skills      Skill[]
echo   interactions CommunityInteraction[]
echo   createdAt   DateTime      @default(now())
echo   updatedAt   DateTime      @updatedAt
echo }
echo.
echo model CommunityInteraction {
echo   id          String        @id @default(cuid())
echo   type        InteractionType
echo   senderId    String
echo   sender      User          @relation(fields: [senderId], references: [id])
echo   listingId   String
echo   listing     Listing       @relation(fields: [listingId], references: [id])
echo   message     String?
echo   status      String        @default("PENDING")
echo   createdAt   DateTime      @default(now())
echo }
echo.
echo model Event {
echo   id          String    @id @default(cuid())
echo   title       String
echo   description String
echo   organizerId  String
echo   organizer   User      @relation(fields: [organizerId], references: [id])
echo   location    String
echo   latitude    Float?
echo   longitude   Float?
echo   startDate   DateTime
echo   endDate     DateTime?
echo   capacity    Int?
echo   tags        String[]
echo   attendees   EventAttendee[]
echo   createdAt   DateTime  @default(now())
echo   updatedAt   DateTime  @updatedAt
echo }
echo.
echo model EventAttendee {
echo   id          String    @id @default(cuid())
echo   eventId     String
echo   event       Event     @relation(fields: [eventId], references: [id])
echo   userId      String
echo   user        User      @relation(fields: [userId], references: [id])
echo   status      String    @default("CONFIRMED")
echo   createdAt   DateTime  @default(now())
echo }
echo.
echo model UserReputation {
echo   id          String         @id @default(cuid())
echo   userId      String         @unique
echo   user        User           @relation(fields: [userId], references: [id])
echo   level       ReputationLevel @default(NEWCOMER)
echo   points      Int            @default(0)
echo   completedInteractions Int  @default(0)
echo   reviews     Review[]
echo }
echo.
echo model Review {
echo   id          String    @id @default(cuid())
echo   reviewerId  String
echo   reviewer    User      @relation("GivenReviews", fields: [reviewerId], references: [id])
echo   receiverId  String
echo   receiver    User      @relation(fields: [receiverId], references: [id])
echo   rating      Int
echo   comment     String?
echo   reputationId String?
echo   reputation   UserReputation? @relation(fields: [reputationId], references: [id])
echo   createdAt   DateTime  @default(now())
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

REM Create community reputation utility
echo Creating community reputation utility...
mkdir src\lib\community
echo import * as geolib from 'geolib';
echo import moment from 'moment';
echo.
echo class CommunityReputationSystem {
echo   // Calculate reputation points based on interactions
echo   calculateReputationPoints(interactions) {
echo     let points = 0;
echo.
echo     interactions.forEach(interaction => {
echo       switch(interaction.type) {
echo         case 'COMPLETED_OFFER':
echo           points += 10;
echo           break;
echo         case 'POSITIVE_REVIEW':
echo           points += 5;
echo           break;
echo         case 'EVENT_ORGANIZATION':
echo           points += 15;
echo           break;
echo         case 'SKILL_SHARING':
echo           points += 8;
echo           break;
echo       }
echo     });
echo.
echo     return points;
echo   }
echo.
echo   // Determine reputation level based on points
echo   determineReputationLevel(points) {
echo     if (points < 50) return 'NEWCOMER';
echo     if (points < 200) return 'COMMUNITY_MEMBER';
echo     if (points < 500) return 'TRUSTED_CONTRIBUTOR';
echo     return 'COMMUNITY_LEADER';
echo   }
echo.
echo   // Find nearby community opportunities
echo   findNearbyCommunityOpportunities(
echo     userLocation, 
echo     allListings, 
echo     maxDistance = 10 // kilometers
echo   ) {
echo     return allListings.filter(listing => {
echo       // Check if listing has a location
echo       if (!listing.location) return false;
echo.
echo       const distance = geolib.getDistance(
echo         { 
echo           latitude: userLocation.latitude, 
echo           longitude: userLocation.longitude 
echo         },
echo         { 
echo           latitude: listing.latitude, 
echo           longitude: listing.longitude 
echo         }
echo       );
echo.
echo       // Convert distance to kilometers
echo       const distanceKm = distance / 1000;
echo.
echo       return distanceKm <= maxDistance;
echo     });
echo   }
echo.
echo   // Generate personalized community recommendations
echo   generateCommunityRecommendations(user, communityData) {
echo     const recommendations = [];
echo.
echo     // Recommend events based on user's interests
echo     const relevantEvents = communityData.events.filter(event => 
echo       event.tags.some(tag => 
echo         user.skills.map(skill => skill.name).includes(tag)
echo       )
echo     );
echo.
echo     // Recommend nearby listings
echo     const nearbyListings = this.findNearbyCommunityOpportunities(
echo       user.location,
echo       communityData.listings
echo     );
echo.
echo     // Suggest skill matches
echo     const skillMatchOpportunities = communityData.listings.filter(listing => 
echo       listing.skills.some(skill => 
echo         user.skills.map(userSkill => userSkill.name).includes(skill.name)
echo       )
echo     );
echo.
echo     return {
echo       events: relevantEvents.slice(0, 3),
echo       nearbyListings: nearbyListings.slice(0, 5),
echo       skillMatches: skillMatchOpportunities.slice(0, 4)
echo     };
echo   }
echo } > src\lib\community\reputation.ts

REM Create example environment file
echo Creating environment files...
echo # Database Connection>.env.example
echo DATABASE_URL="postgresql://user:password@localhost:5432/community_marketplace?schema=public">>.env.example
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

REM Update package.json scripts
echo Updating package.json scripts...
call npm pkg set scripts.dev="next dev"
call npm pkg set