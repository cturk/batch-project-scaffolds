@echo off
echo Starting SaaS Rapid Prototyping Project Setup...

REM Create project directory structure
echo Creating project directory structure...
mkdir saas-rapid-prototype
cd saas-rapid-prototype
mkdir src
cd src
mkdir app
mkdir components
mkdir lib
mkdir features
mkdir styles
mkdir utils
cd ..
mkdir prisma
mkdir docs
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
call npm install @trpc/client @trpc/server @trpc/react-query
call npm install next-auth @next-auth/prisma-adapter
call npm install tailwindcss@latest postcss@latest autoprefixer@latest
call npm install stripe @stripe/stripe-js
call npm install zod
call npm install react-hook-form @hookform/resolvers
call npm install axios
call npm install framer-motion
call npm install react-icons
call npm install @radix-ui/react-dialog
call npm install @radix-ui/react-dropdown-menu
call npm install @radix-ui/react-toast
call npm install react-hot-toast

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
echo }
echo.
echo enum Role {
echo   USER
echo   ADMIN
echo   SUBSCRIBER
echo }
echo.
echo model User {
echo   id            String    @id @default(cuid())
echo   name          String?
echo   email         String?   @unique
echo   emailVerified DateTime?
echo   image         String?
echo   role          Role      @default(USER)
echo   accounts      Account[]
echo   sessions      Session[]
echo   subscription  Subscription?
echo   createdAt     DateTime  @default(now())
echo   updatedAt     DateTime  @updatedAt
echo }
echo.
echo model Subscription {
echo   id            String    @id @default(cuid())
echo   userId        String    @unique
echo   user          User      @relation(fields: [userId], references: [id])
echo   stripeCustomerId String?
echo   stripePriceId   String?
echo   status         String?
echo   currentPeriodEnd DateTime?
echo } > prisma\schema.prisma

REM Create Next.js authentication options
echo Creating authentication options...
mkdir src\lib\auth
echo import { PrismaAdapter } from "@next-auth/prisma-adapter";
echo import { prisma } from "../prisma";
echo import { NextAuthOptions } from "next-auth";
echo import GoogleProvider from "next-auth/providers/google";
echo import GithubProvider from "next-auth/providers/github";
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
echo   },
echo }; > src\lib\auth\auth-options.ts

REM Create example environment file
echo Creating environment files...
echo # Database Connection>.env.example
echo DATABASE_URL="postgresql://user:password@localhost:5432/mydb?schema=public">>.env.example
echo.>>.env.example
echo # Next Auth>>.env.example
echo NEXTAUTH_URL="http://localhost:3000">>.env.example
echo NEXTAUTH_SECRET="your-secret-here">>.env.example
echo.>>.env.example
echo # OAuth Providers>>.env.example
echo GOOGLE_CLIENT_ID="your-google-client-id">>.env.example
echo GOOGLE_CLIENT_SECRET="your-google-client-secret">>.env.example
echo GITHUB_ID="your-github-id">>.env.example
echo GITHUB_SECRET="your-github-secret">>.env.example
echo.>>.env.example
echo # Stripe>>.env.example
echo STRIPE_SECRET_KEY="your-stripe-secret-key">>.env.example
echo STRIPE_PUBLISHABLE_KEY="your-stripe-publishable-key">>.env.example
echo STRIPE_WEBHOOK_SECRET="your-stripe-webhook-secret">>.env.example

REM Create basic Tailwind configuration
echo Creating Tailwind configuration...
echo module.exports = {
echo   content: [
echo     "./src/**/*.{js,ts,jsx,tsx}",
echo   ],
echo   theme: {
echo     extend: {},
echo   },
echo   plugins: [],
echo } > tailwind.config.js

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

REM Create README
echo Creating README.md...
echo # SaaS Rapid Prototype > README.md
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
echo    npm run prisma:migrate >> README.md
echo    \`\`\` >> README.md
echo 6. Start the development server: >> README.md
echo    \`\`\`bash >> README.md
echo    npm run dev >> README.md
echo    \`\`\` >> README.md
echo. >> README.md
echo ## Features >> README.md
echo - Next.js 13+ with App Router >> README.md
echo - TypeScript >> README.md
echo - Prisma ORM >> README.md
echo - NextAuth.js Authentication >> README.md
echo - Stripe Subscriptions >> README.md
echo - Tailwind CSS >> README.md
echo - React Query >> README.md
echo - tRPC >> README.md

REM Initialize git
echo Initializing git repository...
git init
echo node_modules/ > .gitignore
echo .next/ >> .gitignore
echo .env >> .gitignore
echo .env.local >> .gitignore
echo .vercel >> .gitignore
echo *.log >> .gitignore

echo SaaS Rapid Prototyping Setup Complete!
echo Next steps:
echo 1. Configure environment variables
echo 2. Set up OAuth providers
echo 3. Configure Stripe
echo 4. Start building your prototype
pause