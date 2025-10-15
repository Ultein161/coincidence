# Overview

This is a Russian-language dating application called "СвойЧеловек+" (formerly LoveConnect). The application helps users find compatible matches through a personality-based compatibility test system. Users can browse potential matches in a feed, chat with connections, and manage their profiles. The app features a premium "Prime" subscription tier that unlocks additional features like unlimited swipes and advanced filters.

# User Preferences

Preferred communication style: Simple, everyday language.

# System Architecture

## Frontend Architecture

The frontend is a modern React single-page application built with TypeScript and Vite:

- **UI Framework**: React 18 with TypeScript for type safety and modern component patterns
- **Build Tool**: Vite for fast development server and optimized production builds
- **Styling Solution**: Tailwind CSS for utility-first styling with shadcn/ui component library providing pre-built, accessible components
- **Routing**: Wouter for lightweight client-side routing without the overhead of React Router
- **State Management**: TanStack Query (React Query) for server state, caching, and data synchronization
- **Form Management**: React Hook Form with Zod schema validation via @hookform/resolvers
- **Animation**: Framer Motion for smooth UI transitions and animations

The application follows a page-based architecture with routes for home, authentication, personality test, results/matches, feed, chat system, profile management, and premium features. All UI text is localized in Russian, including Cyrillic character support throughout.

**Design Rationale**: The combination of Wouter + TanStack Query was chosen over heavier alternatives like React Router + Redux to minimize bundle size while maintaining powerful data fetching capabilities. Shadcn/ui provides consistent, accessible components without the lock-in of traditional component libraries.

## Backend Architecture

The backend uses a Spring Boot REST API:

- **Framework**: Spring Boot 3.5.4 running on Java 19
- **API Design**: RESTful endpoints with `/api` prefix for all routes
- **Security**: Spring Security with JWT-based authentication for stateless session management
- **Data Access**: Spring Data JPA with Hibernate ORM for database operations

The backend implements core authentication endpoints (`/api/auth/login`, `/api/auth/signup`) and user management routes. The frontend development server proxies API requests to the backend running on port 8080.

**Design Rationale**: Spring Boot was selected for its mature ecosystem, excellent JPA integration, and built-in security features. JWT authentication enables stateless scaling and works well with the React SPA architecture.

## Data Storage Solutions

- **Database**: PostgreSQL via Replit's Neon integration
- **ORM**: Dual approach - Spring Data JPA/Hibernate on backend, Drizzle ORM configured on frontend
- **Schema Management**: 
  - Backend: Hibernate auto-generates schema from JPA entities
  - Frontend: Drizzle configured with schema at `shared/schema.ts` for type-safe queries
  
**Database Schema** (defined in Drizzle):
- `users` table: Core user data (id, username, email, password, fullName, age, bio, interests array)
- `test_results` table: Personality test answers and compatibility data linked to users
- `matches` table: Match relationships between users with compatibility scores and like status

**Design Rationale**: The dual ORM setup suggests potential migration from Spring Boot backend to a Node.js solution, or the Drizzle setup may be for future features. PostgreSQL provides robust relational capabilities needed for the matching system's complex queries.

## External Dependencies

### UI Component Libraries
- **Radix UI**: Headless accessible component primitives (@radix-ui/react-* packages)
- **shadcn/ui**: Pre-styled components built on Radix UI
- **Lucide React**: Icon library for consistent iconography

### Utility Libraries
- **date-fns**: Date manipulation and formatting
- **class-variance-authority**: Type-safe variant management for components
- **clsx + tailwind-merge**: Conditional class name handling

### Development Tools
- **Replit Integration**: Custom Vite plugins for Replit environment (@replit/vite-plugin-runtime-error-modal, @replit/vite-plugin-cartographer)
- **TypeScript**: Full type safety across frontend codebase

### State & Data Management
- **TanStack Query**: Server state management with built-in caching, refetching, and request deduplication
- **React Hook Form**: Form state and validation with minimal re-renders
- **Zod**: Runtime type validation and schema definition via drizzle-zod integration

**Notable Architectural Decisions**:
- LocalStorage used for client-side data persistence (user profiles, Prime status)
- Mock data used throughout frontend (chats, profiles, matches) suggesting backend API integration is incomplete

## Authentication & Authorization (Recently Added - October 2025)

The application now implements a complete JWT-based authentication system on the frontend:

### Authentication Infrastructure
- **AuthContext**: React Context for global authentication state management
  - Token validation using jwt-decode library
  - Automatic token expiry detection
  - Login/logout functionality
  - User state derived from decoded JWT

- **API Client** (`lib/apiClient.ts`): Centralized HTTP client
  - Automatic JWT token injection in Authorization headers
  - Automatic 401 error handling with redirect to login
  - Generic methods for GET, POST, PUT, DELETE requests
  - Support for authenticated and unauthenticated requests

- **Route Protection** (`PrivateRoute` component):
  - Wraps protected routes to enforce authentication
  - Redirects unauthenticated users to /auth
  - Protected routes: /test, /results, /feed, /chats, /chat/:id, /profile, /prime
  - Public routes: /, /auth

### Authentication Flow
1. User logs in via `/auth` page
2. Backend returns JWT token
3. Frontend stores token in localStorage via AuthContext
4. Token is decoded to extract user information
5. All API requests automatically include Bearer token
6. Token validity is checked on AuthContext initialization
7. Expired/invalid tokens trigger automatic cleanup and redirect

### Security Features
- JWT expiration validation on client-side
- Automatic logout on token expiry
- Protected routes redirect unauthorized users
- Centralized 401 error handling
- Already-authenticated users are redirected from /auth to /profile

**Design Rationale**: Context API was chosen over Redux for auth state to minimize bundle size. The apiClient pattern centralizes token management and prevents token-related bugs. localStorage is used for token storage (instead of httpOnly cookies) due to Replit's proxy architecture limitations.