@echo off
echo Starting Freelance Marketplace Project Setup...

REM Create project directory structure
echo Creating project directory structure...
mkdir freelance-marketplace
cd freelance-marketplace
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
mkdir projects
mkdir profiles
mkdir payments
mkdir reviews
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
call npm install stripe @stripe/stripe-js
call npm install socket.io-client

REM Install additional marketplace dependencies
echo Installing marketplace dependencies...
call npm install @prisma/extension-accelerate
call npm install react-select
call npm install react-datepicker
call npm install markdown-to-jsx
call npm install react-markdown
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
echo   previewFeatures = ["fullTextSearch", "fullTextIndex"]
echo }
echo.
echo enum UserRole {
echo   FREELANCER
echo   CLIENT
echo   ADMIN
echo }
echo.
echo enum ProjectStatus {
echo   DRAFT
echo   OPEN
echo   IN_PROGRESS
echo   COMPLETED
echo   CANCELLED
echo }
echo.
echo enum SkillLevel {
echo   JUNIOR
echo   MID_LEVEL
echo   SENIOR
echo   EXPERT
echo }
echo.
echo model User {
echo   id            String    @id @default(cuid())
echo   name          String
echo   email         String    @unique
echo   emailVerified DateTime?
echo   image         String?
echo   role         UserRole
echo   profile      FreelancerProfile?
echo   accounts     Account[]
echo   sessions     Session[]
echo   clientProjects Project[] @relation("ClientProjects")
echo   freelancerProjects Project[] @relation("FreelancerProjects")
echo   bids          ProjectBid[]
echo   reviews       Review[]
echo   skills        Skill[]
echo   earnings      Earning[]
echo   wallet        Wallet?
echo   createdAt    DateTime  @default(now())
echo   updatedAt    DateTime  @updatedAt
echo }
echo.
echo model FreelancerProfile {
echo   id          String    @id @default(cuid())
echo   userId      String    @unique
echo   user        User      @relation(fields: [userId], references: [id])
echo   headline    String?
echo   bio         String?
echo   hourlyRate  Decimal?
echo   location    String?
echo   languages   String[]
echo   education   Education[]
echo   certifications Certification[]
echo   portfolioProjects PortfolioProject[]
echo }
echo.
echo model Skill {
echo   id          String    @id @default(cuid())
echo   name        String    @unique
echo   category    String
echo   users       User[]
echo }
echo.
echo model Project {
echo   id          String        @id @default(cuid())
echo   title       String
echo   description String
echo   clientId    String
echo   client      User         @relation("ClientProjects", fields: [clientId], references: [id])
echo   freelancerId String?
echo   freelancer   User?        @relation("FreelancerProjects", fields: [freelancerId], references: [id])
echo   status      ProjectStatus @default(DRAFT)
echo   requiredSkills Skill[]
echo   budget      Decimal?
echo   deadline    DateTime?
echo   bids        ProjectBid[]
echo   attachments String[]
echo   reviews     Review[]
echo   milestones  Milestone[]
echo   createdAt   DateTime      @default(now())
echo   updatedAt   DateTime      @updatedAt
echo }
echo.
echo model ProjectBid {
echo   id          String    @id @default(cuid())
echo   projectId   String
echo   project     Project   @relation(fields: [projectId], references: [id])
echo   freelancerId String
echo   freelancer   User     @relation(fields: [freelancerId], references: [id])
echo   proposedRate Decimal
echo   coverLetter String
echo   status      String    @default("PENDING")
echo   createdAt   DateTime  @default(now())
echo }
echo.
echo model Milestone {
echo   id          String    @id @default(cuid())
echo   projectId   String
echo   project     Project   @relation(fields: [projectId], references: [id])
echo   title       String
echo   description String?
echo   amount      Decimal
echo   dueDate     DateTime
echo   status      String    @default("PENDING")
echo }
echo.
echo model Review {
echo   id          String    @id @default(cuid())
echo   projectId   String
echo   project     Project   @relation(fields: [projectId], references: [id])
echo   reviewerId  String
echo   reviewer    User      @relation(fields: [reviewerId], references: [id])
echo   rating      Int
echo   comment     String?
echo   createdAt   DateTime  @default(now())
echo }
echo.
echo model Wallet {
echo   id          String    @id @default(cuid())
echo   userId      String    @unique
echo   user        User      @relation(fields: [userId], references: [id])
echo   balance     Decimal   @default(0)
echo   earnings    Earning[]
echo }
echo.
echo model Earning {
echo   id          String    @id @default(cuid())
echo   userId      String
echo   user        User      @relation(fields: [userId], references: [id])
echo   projectId   String
echo   amount      Decimal
echo   status      String
echo   createdAt   DateTime  @default(now())
echo }
echo.
echo model Education {
echo   id          String    @id @default(cuid())
echo   profileId   String
echo   profile     FreelancerProfile @relation(fields: [profileId], references: [id])
echo   institution String
echo   degree      String
echo   fieldOfStudy String
echo   startDate   DateTime
echo   endDate     DateTime?
echo }
echo.
echo model Certification {
echo   id          String    @id @default(cuid())
echo   profileId   String
echo   profile     FreelancerProfile @relation(fields: [profileId], references: [id])
echo   name        String
echo   issuedBy    String
echo   issueDate   DateTime
echo   expirationDate DateTime?
echo }
echo.
echo model PortfolioProject {
echo   id          String    @id @default(cuid())
echo   profileId   String
echo   profile     FreelancerProfile @relation(fields: [profileId], references: [id])
echo   title       String
echo   description String
echo   skills      Skill[]
echo   projectUrl  String?
echo   imageUrls   String[]
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

REM Create project bidding utility
echo Creating project bidding utility...
mkdir src\lib\marketplace
echo // Project bidding and matching logic
echo class MarketplaceBiddingSystem {
echo   // Rank and match freelancers to projects
echo   matchFreelancersToProject(project, freelancers) {
echo     return freelancers
echo       .filter(freelancer => this.isFreelancerQualified(freelancer, project))
echo       .map(freelancer => ({
echo         freelancer,
echo         matchScore: this.calculateMatchScore(freelancer, project)
echo       }))
echo       .sort((a, b) => b.matchScore - a.matchScore)
echo       .slice(0, 5); // Top 5 matches
echo   }
echo.
echo   // Check if freelancer is qualified for a project
echo   isFreelancerQualified(freelancer, project) {
echo     const requiredSkills = project.requiredSkills;
echo     const freelancerSkills = freelancer.skills;
echo.
echo     return requiredSkills.every(skill => 
echo       freelancerSkills.some(fs => fs.name === skill.name)
echo     );
echo   }
echo.
echo   // Calculate match score based on skills, experience, and past performance
echo   calculateMatchScore(freelancer, project) {
echo     let score = 0;
echo.
echo     // Skill match
echo     const skillMatchCount = project.requiredSkills.filter(skill => 
echo       freelancer.skills.some(fs => fs.name === skill.name)
echo     ).length;
echo     score += skillMatchCount * 10;
echo.
echo     // Past project success rate
echo     const successRate = this.calculateSuccessRate(freelancer);
echo     score += successRate * 5;
echo.
echo     // Hourly rate proximity
echo     if (project.budget && freelancer.profile.hourlyRate) {
echo       const rateDifference = Math.abs(
echo         project.budget - freelancer.profile.hourlyRate
echo       );
echo       score += Math.max(0, 10 - rateDifference);
echo     }
echo.
echo     return score;
echo   }
echo.
echo   // Calculate freelancer's success rate from past projects
echo   calculateSuccessRate(freelancer) {
echo     const completedProjects = freelancer.projects.filter(
echo       p => p.status === 'COMPLETED'
echo     );
echo     const totalProjects = freelancer.projects.length;
echo.
echo     return totalProjects > 0 
echo       ? completedProjects.length / totalProjects 
echo       : 0;
echo   }
echo.
echo   // Generate project recommendations
echo   generateProjectRecommendations(freelancer) {
echo     // Placeholder for complex recommendation algorithm
echo     // Would typically involve machine learning techniques
echo     return [];
echo   }
echo } > src\lib\marketplace\bidding.ts

REM Create example environment file
echo Creating environment files...
echo # Database Connection>.env.example
echo DATABASE_URL="postgresql://user:password@localhost:5432/freelance_marketplace?schema=public">>.env.example
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
echo #