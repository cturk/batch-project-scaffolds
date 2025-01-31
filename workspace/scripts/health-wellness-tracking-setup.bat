@echo off
echo Starting Health and Wellness Tracking App Project Setup...

REM Create project directory structure
echo Creating project directory structure...
mkdir health-wellness-tracker
cd health-wellness-tracker
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
mkdir tracking
mkdir nutrition
mkdir fitness
mkdir goals
mkdir insights
cd ..
mkdir prisma
mkdir public
mkdir scripts
mkdir tests
mkdir wearable-integrations

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
call npm install recharts
call npm install react-datepicker

REM Install health tracking and analysis dependencies
echo Installing health tracking dependencies...
call npm install @prisma/extension-accelerate
call npm install d3
call npm install mathjs
call npm install ml-matrix
call npm install tensorflow
call npm install @tensorflow/tfjs
call npm install simple-statistics
call npm install moment

REM Install wearable and integration dependencies
echo Installing wearable integration dependencies...
call npm install @garmin-connect/connect
call npm install fitbit-api-client
call npm install @withings/api

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
echo enum BodyMetricType {
echo   WEIGHT
echo   BODY_FAT
echo   MUSCLE_MASS
echo   WATER_PERCENTAGE
echo }
echo.
echo enum ActivityType {
echo   RUNNING
echo   CYCLING
echo   SWIMMING
echo   STRENGTH_TRAINING
echo   YOGA
echo   WALKING
echo }
echo.
echo enum NutrientType {
echo   PROTEIN
echo   CARBOHYDRATE
echo   FAT
echo   CALORIES
echo }
echo.
echo enum GoalType {
echo   WEIGHT_LOSS
echo   MUSCLE_GAIN
echo   ENDURANCE
echo   FLEXIBILITY
echo   GENERAL_FITNESS
echo }
echo.
echo enum WearableIntegrationType {
echo   GARMIN
echo   FITBIT
echo   APPLE_HEALTH
echo   WITHINGS
echo }
echo.
echo model User {
echo   id            String    @id @default(cuid())
echo   name          String?
echo   email         String    @unique
echo   emailVerified DateTime?
echo   image         String?
echo   profile       UserProfile?
echo   accounts      Account[]
echo   sessions      Session[]
echo   bodyMetrics   BodyMetric[]
echo   activities    Activity[]
echo   nutritionLogs NutritionLog[]
echo   goals         Goal[]
echo   wearableIntegrations WearableIntegration[]
echo   sleepLogs     SleepLog[]
echo   meditations   Meditation[]
echo   createdAt     DateTime  @default(now())
echo   updatedAt     DateTime  @updatedAt
echo }
echo.
echo model UserProfile {
echo   id            String    @id @default(cuid())
echo   userId        String    @unique
echo   user          User      @relation(fields: [userId], references: [id])
echo   age           Int?
echo   height        Float?
echo   weight        Float?
echo   gender        String?
echo   fitnessLevel  String?
echo   dietaryPreferences String?
echo   medicalConditions String?
echo }
echo.
echo model BodyMetric {
echo   id          String          @id @default(cuid())
echo   userId      String
echo   user        User            @relation(fields: [userId], references: [id])
echo   type        BodyMetricType
echo   value       Float
echo   unit        String
echo   timestamp   DateTime        @default(now())
echo }
echo.
echo model Activity {
echo   id          String          @id @default(cuid())
echo   userId      String
echo   user        User            @relation(fields: [userId], references: [id])
echo   type        ActivityType
echo   duration    Int             // in minutes
echo   intensity   String?
echo   calories    Float?
echo   distance    Float?
echo   timestamp   DateTime        @default(now())
echo }
echo.
echo model NutritionLog {
echo   id          String          @id @default(cuid())
echo   userId      String
echo   user        User            @relation(fields: [userId], references: [id])
echo   foodName    String
echo   nutrients   NutrientEntry[]
echo   mealType    String          // Breakfast, Lunch, Dinner, Snack
echo   timestamp   DateTime        @default(now())
echo }
echo.
echo model NutrientEntry {
echo   id              String          @id @default(cuid())
echo   nutritionLogId  String
echo   nutritionLog    NutritionLog    @relation(fields: [nutritionLogId], references: [id])
echo   type            NutrientType
echo   amount          Float
echo   unit            String
echo }
echo.
echo model Goal {
echo   id          String          @id @default(cuid())
echo   userId      String
echo   user        User            @relation(fields: [userId], references: [id])
echo   type        GoalType
echo   target      Float
echo   unit        String
echo   startDate   DateTime
echo   endDate     DateTime?
echo   progress    GoalProgress[]
echo }
echo.
echo model GoalProgress {
echo   id          String          @id @default(cuid())
echo   goalId      String
echo   goal        Goal            @relation(fields: [goalId], references: [id])
echo   currentValue Float
echo   timestamp   DateTime        @default(now())
echo }
echo.
echo model WearableIntegration {
echo   id          String                  @id @default(cuid())
echo   userId      String
echo   user        User                    @relation(fields: [userId], references: [id])
echo   type        WearableIntegrationType
echo   accessToken String
echo   refreshToken String?
echo   lastSync    DateTime?
echo }
echo.
echo model SleepLog {
echo   id          String          @id @default(cuid())
echo   userId      String
echo   user        User            @relation(fields: [userId], references: [id])
echo   duration    Int             // in minutes
echo   quality     String?
echo   deepSleep   Int?            // in minutes
echo   timestamp   DateTime        @default(now())
echo }
echo.
echo model Meditation {
echo   id          String          @id @default(cuid())
echo   userId      String
echo   user        User            @relation(fields: [userId], references: [id])
echo   duration    Int             // in minutes
echo   type        String?         // Mindfulness, Breathing, Guided, etc.
echo   mood        String?
echo   timestamp   DateTime        @default(now())
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

REM Create health analysis utility
echo Creating health analysis utility...
mkdir src\lib\health-analysis
echo import * as math from 'mathjs';
echo import * as tf from '@tensorflow/tfjs';
echo import * as stats from 'simple-statistics';
echo.
echo class HealthInsightGenerator {
echo   // Calculate BMI
echo   calculateBMI(weightKg, heightCm) {
echo     const heightM = heightCm / 100;
echo     return weightKg / (heightM * heightM);
echo   }
echo.
echo   // Analyze body composition trends
echo   analyzeBodyCompositionTrends(bodyMetrics) {
echo     const weightTrends = this.extractTrend(
echo       bodyMetrics.filter(m => m.type === 'WEIGHT')
echo     );
echo.
echo     const bodyFatTrends = this.extractTrend(
echo       bodyMetrics.filter(m => m.type === 'BODY_FAT')
echo     );
echo.
echo     return {
echo       weight: weightTrends,
echo       bodyFat: bodyFatTrends
echo     };
echo   }
echo.
echo   // Extract trend from time series data
echo   extractTrend(metrics) {
echo     if (metrics.length < 2) return { trend: 'Insufficient data', slope: 0 };
echo.
echo     const timestamps = metrics.map(m => m.timestamp.getTime());
echo     const values = metrics.map(m => m.value);
echo.
echo     // Linear regression to determine trend
echo     const slope = stats.linearRegression(
echo       timestamps.map((t, i) => [t, values[i]])
echo     ).m;
echo.
echo     return {
echo       trend: slope > 0 ? 'Increasing' : 'Decreasing',
echo       slope
echo     };
echo   }
echo.
echo   // Predict future body metrics using TensorFlow
echo   predictBodyMetrics(historicalData) {
echo     // Simple linear regression model
echo     const xs = tf.tensor1d(
echo       historicalData.map((_, i) => i)
echo     );
echo     const ys = tf.tensor1d(
echo       historicalData.map(data => data.value)
echo     );
echo.
echo     const model = tf.sequential();
echo     model.add(tf.layers.dense({units: 1, inputShape: [1]}));
echo     model.compile({
echo       optimizer: 'sgd',
echo       loss: 'meanSquaredError'
echo     });
echo.
echo     model.fit(xs, ys, {epochs: 250});
echo.
echo     // Predict next few data points
echo     const futureXs = tf.tensor1d([
echo       historicalData.length,
echo       historicalData.length + 1,
echo       historicalData.length + 2
echo     ]);
echo.
echo     return model.predict(futureXs);
echo   }
echo.
echo   // Comprehensive health risk assessment
echo   assessHealthRisks(userProfile, bodyMetrics, activities) {
echo     const risks = [];
echo.
echo     const bmi = this.calculateBMI(
echo       bodyMetrics.find(m => m.type === 'WEIGHT')?.value,
echo       userProfile.height
echo     );
echo.
echo     // BMI risk assessment
echo     if (bmi < 18.5) risks.push('Underweight');
echo     else if (bmi >= 25) risks.push('Overweight');
echo.
echo     // Inactivity risk
echo     const weeklyActivityMinutes = activities
echo       .filter(a => a.timestamp > new Date(Date.now() - 7 * 24 * 60 * 60 * 1000))
echo       .reduce((total, activity) => total + activity.duration, 0);
echo.
echo     if (weeklyActivityMinutes < 150) {
echo       risks.push('Low Physical Activity');
echo     }
echo.
echo     return risks;
echo   }
echo.
echo   // Generate personalized health recommendations
echo   generateHealthRecommendations(userProfile, risks) {
echo     const recommendations = [];
echo.
echo     risks.forEach(risk => {
echo       switch(risk) {
echo         case 'Underweight':
echo           recommendations.push(
echo             'Focus on nutrient-dense, high-calorie foods'
echo           );
echo           break;
echo         case 'Overweight':
echo           recommendations.push(
echo             'Increase physical activity and monitor calorie intake'
echo           );
echo           break;
echo         case 'Low Physical Activity':
echo           recommendations.push(
echo             'Aim for 150 minutes of moderate exercise per week'
echo           );
echo           break;
echo       }
echo     });
echo.
echo     return recommendations;
echo   }
echo } > src\lib\health-analysis\insights.ts

REM Create example environment file
echo Creating environment files...
echo # Database Connection>.env.example
echo DATABASE_URL="postgresql://user:password@localhost:5432/health_tracker?schema=public">>.env.example
echo.>>.env.example
echo # Next Auth>>.env.example
echo NEXTAUTH_URL="http://localhost:3000">>.env.example
echo NEXTAUTH_SECRET="your-nextauth-secret">>.env.example
echo.>>.env.example
echo # Wearable API Credentials>>.env.example
echo GARMIN_CLIENT_ID="your-garmin-client-id">>.env.example
echo GARMIN_CLIENT_SECRET="your-garmin-client-secret">>.env.example
echo FITBIT_CLIENT_ID="your-fitbit-client-id">>.env.example
echo FITBIT_CLIENT_SECRET="your-fitbit-client-secret">>.env.example
echo