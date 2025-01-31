@echo off
echo Starting enhanced Supabase project setup...

REM Create base directories
echo Creating directory structure...
mkdir src
cd src
mkdir app
cd app
mkdir (auth)
mkdir (dashboard)
mkdir api
cd ..
mkdir core
cd core
mkdir config
mkdir auth
mkdir errors
cd ..
mkdir features
cd features
mkdir analytics
mkdir datasets
mkdir visualizations
cd ..
mkdir lib
cd lib
mkdir ai
mkdir supabase
mkdir utils
cd ..
mkdir server
cd server
mkdir api
mkdir middleware
mkdir services
cd ..
mkdir shared
cd shared
mkdir components
mkdir hooks
mkdir styles
mkdir types
cd ..
mkdir subscription
cd subscription
mkdir plans
mkdir features
mkdir limits
cd ..
cd ..
mkdir public
mkdir scripts
cd scripts
mkdir seed
mkdir maintenance
cd ..
mkdir tests
cd tests
mkdir e2e
mkdir integration
mkdir unit
cd ..

REM Initialize Node project
echo Initializing Node project...
call npm init -y

REM Install core dependencies
echo Installing core dependencies...
call npm install next@latest react@latest react-dom@latest
call npm install @supabase/supabase-js @supabase/auth-helpers-nextjs
call npm install @tanstack/react-query @trpc/client @trpc/server
call npm install @headlessui/react @radix-ui/react-dialog @radix-ui/react-dropdown-menu
call npm install lucide-react recharts zod axios
call npm install next-auth
call npm install @tanstack/react-table date-fns
call npm install react-hook-form @hookform/resolvers
call npm install papaparse xlsx

REM Install development dependencies
echo Installing development dependencies...
call npm install -D typescript @types/react @types/node @types/react-dom
call npm install -D tailwindcss postcss autoprefixer
call npm install -D eslint eslint-config-next @typescript-eslint/parser @typescript-eslint/eslint-plugin
call npm install -D prettier prettier-plugin-tailwindcss
call npm install -D @testing-library/react @testing-library/jest-dom @testing-library/user-event
call npm install -D jest jest-environment-jsdom
call npm install -D vitest @vitest/coverage-c8
call npm install -D msw
call npm install -D @types/papaparse @types/xlsx
call npm install -D @supabase/supabase-js @types/supabase

REM Initialize TypeScript
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

REM Create Supabase authentication utility
echo Creating Supabase authentication utility...
mkdir src\lib\supabase
echo // src/lib/supabase/auth.ts
echo import { createClient } from '@supabase/supabase-js';
echo import { cookies } from 'next/headers';
echo import { Database } from './database.types'; // You'll need to generate this
echo.
echo export const createServerComponentClient = () => {
echo   const cookieStore = cookies();
echo   return createClient^<Database^>(
echo     process.env.NEXT_PUBLIC_SUPABASE_URL!,
echo     process.env.SUPABASE_SERVICE_ROLE_KEY!,
echo     {
echo       cookies: {
echo         get(name: string) {
echo           return cookieStore.get(name)?.value;
echo         },
echo       },
echo     }
echo   );
echo };
echo.
echo export const createClientComponentClient = () => {
echo   return createClient^<Database^>(
echo     process.env.NEXT_PUBLIC_SUPABASE_URL!,
echo     process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
echo   );
echo }; > src\lib\supabase\auth.ts

REM Initialize root layout
echo Creating root layout...
echo import type { Metadata } from "next";
echo import { Inter } from "next/font/google";
echo import "./globals.css";
echo.
echo const inter = Inter({ subsets: ["latin"] });
echo.
echo export const metadata: Metadata = {
echo   title: "Your Supabase App",
echo   description: "Your app description",
echo };
echo.
echo export default function RootLayout({
echo   children,
echo }: {
echo   children: React.ReactNode;
echo }) {
echo   return (
echo     ^<html lang="en"^>
echo       ^<body className={inter.className}^>{children}^</body^>
echo     ^</html^>
echo   );
echo } > src\app\layout.tsx

REM Create additional configuration files
echo Creating additional configuration files...

REM ESLint configuration
echo {
echo   "extends": [
echo     "next/core-web-vitals",
echo     "plugin:@typescript-eslint/recommended"
echo   ],
echo   "parser": "@typescript-eslint/parser",
echo   "plugins": ["@typescript-eslint"],
echo   "rules": {
echo     "@typescript-eslint/no-unused-vars": "warn",
echo     "@typescript-eslint/no-explicit-any": "warn"
echo   }
echo } > .eslintrc.json

REM Prettier configuration
echo {
echo   "semi": true,
echo   "singleQuote": true,
echo   "tabWidth": 2,
echo   "trailingComma": "es5",
echo   "plugins": ["prettier-plugin-tailwindcss"]
echo } > .prettierrc

REM Create example environment file
echo Creating environment files...
echo # Supabase Configuration>.env.example
echo NEXT_PUBLIC_SUPABASE_URL="your-project-url">>.env.example
echo NEXT_PUBLIC_SUPABASE_ANON_KEY="your-anon-key">>.env.example
echo SUPABASE_SERVICE_ROLE_KEY="your-service-role-key">>.env.example
echo.>>.env.example
echo # OAuth Providers>>.env.example
echo GITHUB_ID="your-github-id">>.env.example
echo GITHUB_SECRET="your-github-secret">>.env.example
echo GOOGLE_CLIENT_ID="your-google-client-id">>.env.example
echo GOOGLE_CLIENT_SECRET="your-google-client-secret">>.env.example

REM Update package.json scripts
echo Updating package.json scripts...
call npm pkg set scripts.dev="next dev"
call npm pkg set scripts.build="next build"
call npm pkg set scripts.start="next start"
call npm pkg set scripts.lint="next lint"
call npm pkg set scripts.format="prettier --write ."
call npm pkg set scripts.test="vitest"
call npm pkg set scripts.test:coverage="vitest run --coverage"
call npm pkg set scripts.prepare="husky install"
call npm pkg set scripts.supabase:types="supabase gen types typescript --project-id YOUR_PROJECT_ID > src/lib/supabase/database.types.ts"

REM Initialize git
echo Initializing git repository...
git init
echo # Dependencies > .gitignore
echo node_modules/ >> .gitignore
echo .pnp >> .gitignore
echo .pnp.js >> .gitignore
echo.>> .gitignore
echo # Testing >> .gitignore
echo /coverage >> .gitignore
echo.>> .gitignore
echo # Next.js >> .gitignore
echo /.next/ >> .gitignore
echo /out/ >> .gitignore
echo.>> .gitignore
echo # Production >> .gitignore
echo /build >> .gitignore
echo.>> .gitignore
echo # Misc >> .gitignore
echo .DS_Store >> .gitignore
echo *.pem >> .gitignore
echo.>> .gitignore
echo # Debug >> .gitignore
echo npm-debug.log* >> .gitignore
echo yarn-debug.log* >> .gitignore
echo yarn-error.log* >> .gitignore
echo.>> .gitignore
echo # Local env files >> .gitignore
echo .env*.local >> .gitignore
echo .env >> .gitignore
echo.>> .gitignore
echo # Vercel >> .gitignore
echo .vercel >> .gitignore
echo.>> .gitignore
echo # TypeScript >> .gitignore
echo *.tsbuildinfo >> .gitignore
echo next-env.d.ts >> .gitignore
echo # Supabase >> .gitignore
echo *.local >> .gitignore

REM Create README
echo Creating README...
echo # Project Name > README.md
echo. >> README.md
echo ## Getting Started >> README.md
echo. >> README.md
echo 1. Clone the repository >> README.md
echo 2. Copy `.env.example` to `.env` and update the values >> README.md
echo 3. Install dependencies: >> README.md
echo    ```bash >> README.md
echo    npm install >> README.md
echo    ``` >> README.md
echo 4. Generate Supabase types: >> README.md
echo    ```bash >> README.md
echo    npm run supabase:types >> README.md
echo    ``` >> README.md
echo 5. Start the development server: >> README.md
echo    ```bash >> README.md
echo    npm run dev >> README.md
echo    ``` >> README.md
echo. >> README.md
echo ## Features >> README.md
echo. >> README.md
echo - Next.js 13+ with App Router >> README.md
echo - TypeScript >> README.md
echo - Supabase Authentication and Database >> README.md
echo - TailwindCSS >> README.md
echo - Testing Setup (Vitest + Testing Library) >> README.md
echo - ESLint + Prettier >> README.md
echo. >> README.md
echo ## Project Structure >> README.md
echo. >> README.md
echo ```bash >> README.md
echo src/ >> README.md
echo ├── app/         # Next.js App Router pages >> README.md
echo ├── components/  # React components >> README.md
echo ├── lib/         # Utility functions >> README.md
echo └── server/      # Server-side code >> README.md
echo ``` >> README.md
echo. >> README.md
echo ## Supabase Setup >> README.md
echo. >> README.md
echo 1. Create a Supabase project at https://supabase.com >> README.md
echo 2. Copy your project URL and anon key to `.env` >> README.md
echo 3. Set up authentication providers in Supabase dashboard >> README.md

echo Setup complete! 
echo.
echo Next steps:
echo 1. Copy .env.example to .env and update the values
echo 2. Run 'npm install' to install dependencies
echo 3. Run 'npm run supabase:types' to generate type definitions
echo 4. Run 'npm run dev' to start the development server
pause