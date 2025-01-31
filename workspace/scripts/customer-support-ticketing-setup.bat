@echo off
echo Starting Customer Support Ticketing System Project Setup...

REM Create project directory structure
echo Creating project directory structure...
mkdir customer-support-ticketing
cd customer-support-ticketing
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
mkdir ai
mkdir integrations
cd ..
mkdir prisma
mkdir public
mkdir scripts
mkdir tests
mkdir knowledge-base

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
call npm install @prisma/extension-accelerate

REM Install AI and NLP dependencies
echo Installing AI and NLP dependencies...
call npm install openai
call npm install natural
call npm install compromise
call npm install @huggingface/inference

REM Install WebSocket and real-time dependencies
echo Installing real-time communication dependencies...
call npm install socket.io-client
call npm install socket.io

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
echo   AGENT
echo   SUPERVISOR
echo   ADMIN
echo }
echo.
echo enum TicketStatus {
echo   OPEN
echo   IN_PROGRESS
echo   RESOLVED
echo   CLOSED
echo }
echo.
echo enum TicketPriority {
echo   LOW
echo   MEDIUM
echo   HIGH
echo   CRITICAL
echo }
echo.
echo enum ChannelType {
echo   EMAIL
echo   CHAT
echo   PHONE
echo   SOCIAL_MEDIA
echo }
echo.
echo model User {
echo   id            String    @id @default(cuid())
echo   name          String
echo   email         String    @unique
echo   password      String
echo   role         UserRole
echo   department   String?
echo   tickets      Ticket[]
echo   notes        AgentNote[]
echo   createdAt    DateTime  @default(now())
echo   updatedAt    DateTime  @updatedAt
echo }
echo.
echo model Ticket {
echo   id          String        @id @default(cuid())
echo   title       String
echo   description String
echo   status      TicketStatus  @default(OPEN)
echo   priority    TicketPriority @default(MEDIUM)
echo   channel     ChannelType
echo   customerId  String
echo   customer    Customer      @relation(fields: [customerId], references: [id])
echo   assignedToId String?
echo   assignedTo   User?        @relation(fields: [assignedToId], references: [id])
echo   messages     TicketMessage[]
echo   notes       AgentNote[]
echo   resolution   String?
echo   aiSummary   String?
echo   createdAt   DateTime      @default(now())
echo   updatedAt   DateTime      @updatedAt
echo }
echo.
echo model Customer {
echo   id          String    @id @default(cuid())
echo   name        String
echo   email       String    @unique
echo   phone       String?
echo   tickets     Ticket[]
echo   createdAt   DateTime  @default(now())
echo   updatedAt   DateTime  @updatedAt
echo }
echo.
echo model TicketMessage {
echo   id          String    @id @default(cuid())
echo   ticketId    String
echo   ticket      Ticket    @relation(fields: [ticketId], references: [id])
echo   senderId    String
echo   sender      User      @relation(fields: [senderId], references: [id])
echo   content     String
echo   isInternal  Boolean   @default(false)
echo   createdAt   DateTime  @default(now())
echo }
echo.
echo model AgentNote {
echo   id          String    @id @default(cuid())
echo   ticketId    String
echo   ticket      Ticket    @relation(fields: [ticketId], references: [id])
echo   authorId    String
echo   author      User      @relation(fields: [authorId], references: [id])
echo   content     String
echo   createdAt   DateTime  @default(now())
echo }
echo.
echo model KnowledgeBaseArticle {
echo   id          String    @id @default(cuid())
echo   title       String
echo   content     String
echo   categories  String[]
echo   tags        String[]
echo   viewCount   Int       @default(0)
echo   createdAt   DateTime  @default(now())
echo   updatedAt   DateTime  @updatedAt
echo } > prisma\schema.prisma

REM Create AI-assisted response utility
echo Creating AI response utility...
mkdir src\lib\ai
echo import OpenAI from 'openai';
echo import { natural } from 'natural';
echo.
echo class AIResponseGenerator {
echo   private openai: OpenAI;
echo.
echo   constructor() {
echo     this.openai = new OpenAI({
echo       apiKey: process.env.OPENAI_API_KEY
echo     });
echo   }
echo.
echo   async generateSupportResponse(ticketContext: string): Promise<string> {
echo     try {
echo       const completion = await this.openai.chat.completions.create({
echo         model: "gpt-3.5-turbo",
echo         messages: [
echo           {
echo             role: "system",
echo             content: "You are a helpful customer support AI assistant. Provide a concise, professional, and empathetic response."
echo           },
echo           {
echo             role: "user",
echo             content: `Generate a support response for the following ticket context: ${ticketContext}`
echo           }
echo         ]
echo       });
echo.
echo       return completion.choices[0].message.content || 'Unable to generate response.';
echo     } catch (error) {
echo       console.error('AI Response Generation Error:', error);
echo       return 'Our support team will review your request shortly.';
echo     }
echo   }
echo.
echo   // Additional AI-powered ticket classification and routing methods
echo   classifyTicket(description: string): { category: string, priority: string } {
echo     // Use NLP to classify ticket
echo     const classifier = new natural.BayesClassifier();
echo.
echo     // Train classifier with sample data
echo     classifier.addDocument('server is down', 'technical');
echo     classifier.addDocument('billing issue', 'billing');
echo     classifier.addDocument('cannot log in', 'authentication');
echo.
echo     classifier.train();
echo.
echo     const category = classifier.classify(description);
echo     const priority = this.determinePriority(description);
echo.
echo     return { category, priority };
echo   }
echo.
echo   private determinePriority(description: string): string {
echo     const urgentKeywords = ['urgent', 'critical', 'emergency', 'down'];
echo     return urgentKeywords.some(keyword => 
echo       description.toLowerCase().includes(keyword)
echo     ) ? 'HIGH' : 'MEDIUM';
echo   }
echo } > src\lib\ai\support-ai.ts

REM Create example environment file
echo Creating environment files...
echo # Database Connection>.env.example
echo DATABASE_URL="postgresql://user:password@localhost:5432/support_ticketing?schema=public">>.env.example
echo.>>.env.example
echo # Authentication>>.env.example
echo NEXTAUTH_SECRET="your-nextauth-secret">>.env.example
echo NEXTAUTH_URL="http://localhost:3000">>.env.example
echo.>>.env.example
echo # AI Services>>.env.example
echo OPENAI_API_KEY="your-openai-api-key">>.env.example
echo.>>.env.example
echo # Email and Notification Services>>.env.example
echo SMTP_HOST="your-smtp-host">>.env.example
echo SMTP_PORT=587>>.env.example
echo SMTP_USER="your-email">>.env.example
echo SMTP_PASS="your-email-password">>.env.example

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
call npm pkg set scripts.seed="ts-node scripts/seed.ts"

REM Create README
echo Creating README.md...
echo # Customer Support Ticketing System > README.md
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
echo - Multi-channel support ticket management >> README.md
echo - AI-powered ticket routing and response generation >> README.md
echo - Knowledge base integration >> README.md
echo - Real-time collaboration >> README.md
echo - Comprehensive analytics >> README.md
echo - Role-based access control >> README.md

REM Initialize git
echo Initializing git repository...
git init
echo node_modules/ > .gitignore
echo .next/ >> .gitignore
echo .env >> .gitignore
echo .env.local >> .gitignore
echo .vercel >> .gitignore
echo *.log >> .gitignore

echo Customer Support Ticketing System Setup Complete!
echo Next steps:
echo 1. Configure environment variables
echo 2. Set up OpenAI API key
echo 3. Configure database connection
echo 4. Start building your support system
pause