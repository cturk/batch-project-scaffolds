@echo off
echo Starting Social Learning Platform Project Setup...

REM Create project directory structure
echo Creating project directory structure...
mkdir social-learning-platform
cd social-learning-platform
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
mkdir learning
mkdir community
mkdir gamification
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
call npm install next-themes
call npm install socket.io-client

REM Install learning and gamification dependencies
echo Installing learning platform dependencies...
call npm install @prisma/extension-accelerate
call npm install chart.js react-chartjs-2
call npm install markdown-to-jsx
call npm install react-markdown
call npm install @editorjs/editorjs
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
echo   STUDENT
echo   INSTRUCTOR
echo   ADMIN
echo }
echo.
echo enum CourseStatus {
echo   DRAFT
echo   PUBLISHED
echo   ARCHIVED
echo }
echo.
echo enum LearningPathStatus {
echo   IN_PROGRESS
echo   COMPLETED
echo   DROPPED
echo }
echo.
echo model User {
echo   id            String    @id @default(cuid())
echo   name          String?
echo   email         String    @unique
echo   emailVerified DateTime?
echo   image         String?
echo   role         UserRole  @default(STUDENT)
echo   bio          String?
echo   skills       String[]
echo   accounts     Account[]
echo   sessions     Session[]
echo   courses      CourseEnrollment[]
echo   instructedCourses Course[] @relation("InstructedCourses")
echo   achievements Achievement[]
echo   learningPaths LearningPath[]
echo   projects     Project[]
echo   createdAt    DateTime  @default(now())
echo   updatedAt    DateTime  @updatedAt
echo }
echo.
echo model Course {
echo   id          String        @id @default(cuid())
echo   title       String
echo   description String?
echo   instructorId String
echo   instructor   User         @relation("InstructedCourses", fields: [instructorId], references: [id])
echo   status      CourseStatus  @default(DRAFT)
echo   level       String
echo   category    String
echo   sections    CourseSection[]
echo   enrollments CourseEnrollment[]
echo   tags        String[]
echo   createdAt   DateTime      @default(now())
echo   updatedAt   DateTime      @updatedAt
echo }
echo.
echo model CourseSection {
echo   id          String    @id @default(cuid())
echo   courseId    String
echo   course      Course    @relation(fields: [courseId], references: [id])
echo   title       String
echo   description String?
echo   order       Int
echo   lessons     Lesson[]
echo }
echo.
echo model Lesson {
echo   id          String    @id @default(cuid())
echo   sectionId   String
echo   section     CourseSection @relation(fields: [sectionId], references: [id])
echo   title       String
echo   content     String
echo   videoUrl    String?
echo   resources   LessonResource[]
echo   quizzes     Quiz[]
echo }
echo.
echo model LessonResource {
echo   id          String    @id @default(cuid())
echo   lessonId    String
echo   lesson      Lesson    @relation(fields: [lessonId], references: [id])
echo   title       String
echo   type        String
echo   url         String
echo }
echo.
echo model Quiz {
echo   id          String    @id @default(cuid())
echo   lessonId    String
echo   lesson      Lesson    @relation(fields: [lessonId], references: [id])
echo   title       String
echo   questions   QuizQuestion[]
echo }
echo.
echo model QuizQuestion {
echo   id          String    @id @default(cuid())
echo   quizId      String
echo   quiz        Quiz      @relation(fields: [quizId], references: [id])
echo   question    String
echo   type        String
echo   options     String[]
echo   correctAnswer String
echo }
echo.
echo model CourseEnrollment {
echo   id          String    @id @default(cuid())
echo   userId      String
echo   user        User      @relation(fields: [userId], references: [id])
echo   courseId    String
echo   course      Course    @relation(fields: [courseId], references: [id])
echo   progress    Float     @default(0)
echo   status      LearningPathStatus @default(IN_PROGRESS)
echo   completedAt DateTime?
echo }
echo.
echo model LearningPath {
echo   id          String    @id @default(cuid())
echo   userId      String
echo   user        User      @relation(fields: [userId], references: [id])
echo   title       String
echo   description String?
echo   courses     Course[]
echo   status      LearningPathStatus @default(IN_PROGRESS)
echo   targetSkills String[]
echo }
echo.
echo model Achievement {
echo   id          String    @id @default(cuid())
echo   userId      String
echo   user        User      @relation(fields: [userId], references: [id])
echo   title       String
echo   description String
echo   points      Int
echo   badgeUrl    String?
echo   earnedAt    DateTime  @default(now())
echo }
echo.
echo model Project {
echo   id          String    @id @default(cuid())
echo   userId      String
echo   user        User      @relation(fields: [userId], references: [id])
echo   title       String
echo   description String
echo   githubUrl   String?
echo   liveUrl     String?
echo   skills      String[]
echo   status      String
echo   createdAt   DateTime  @default(now())
echo   updatedAt   DateTime  @updatedAt
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

REM Create gamification utility
echo Creating gamification utility...
mkdir src\lib\gamification
echo // Gamification logic for tracking user achievements and progress
echo class GamificationSystem {
echo   // Calculate user experience points based on course completion
echo   calculateCourseXP(course, completionPercentage) {
echo     const baseXP = 100;
echo     const difficultyMultiplier = {
echo       'Beginner': 1,
echo       'Intermediate': 1.5,
echo       'Advanced': 2
echo     };
echo.
echo     return Math.round(
echo       baseXP * 
echo       difficultyMultiplier[course.level] * 
echo       (completionPercentage / 100)
echo     );
echo   }
echo.
echo   // Generate achievements based on user milestones
echo   generateAchievements(user, event) {
echo     const achievements = [];
echo.
echo     switch(event.type) {
echo       case 'COURSE_COMPLETED':
echo         achievements.push({
echo           title: `Completed ${event.courseName}`,
echo           description: `Mastered the ${event.courseName} course`,
echo           points: 50
echo         });
echo         break;
echo       case 'SKILL_MASTERY':
echo         achievements.push({
echo           title: `${event.skill} Mastermind`,
echo           description: `Demonstrated expertise in ${event.skill}`,
echo           points: 100
echo         });
echo         break;
echo     }
echo.
echo     return achievements;
echo   }
echo.
echo   // Recommend learning paths based on user's skills and interests
echo   recommendLearningPath(user) {
echo     // Complex recommendation algorithm
echo     // Consider user's current skills, completed courses, and career goals
echo     const recommendedPaths = [];
echo.
echo     // Example simplified recommendation logic
echo     const skillGaps = this.identifySkillGaps(user);
echo     skillGaps.forEach(gap => {
echo       recommendedPaths.push({
echo         title: `Become a ${gap.skill} Expert`,
echo         description: `Bridge your ${gap.skill} knowledge gap`,
echo         courses: this.findRelevantCourses(gap.skill)
echo       });
echo     });
echo.
echo     return recommendedPaths;
echo   }
echo.
echo   // Identify skill gaps for recommendation
echo   identifySkillGaps(user) {
echo     // Placeholder for more complex skill gap analysis
echo     return [
echo       { skill: 'Web Development', proficiency: 'Beginner' },
echo       { skill: 'Data Science', proficiency: 'Intermediate' }
echo     ];
echo   }
echo.
echo   // Find courses relevant to a specific skill
echo   findRelevantCourses(skill) {
echo     // Placeholder for course recommendation logic
echo     return [];
echo   }
echo } > src\lib\gamification\achievements.ts

REM Create example environment file
echo Creating environment files...
echo # Database Connection>.env.example
echo DATABASE_URL="postgresql://user:password@localhost:5432/social_learning?schema=public">>.env.example
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

REM Update package.json scripts
echo Updating package.json scripts...
call npm pkg set scripts.dev="next dev"
call npm pkg set scripts.build="next build"
call npm pkg set scripts.start="next start"
call