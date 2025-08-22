# Nest.js Boilerplate ⚡

A comprehensive, production-ready Nest.js boilerplate designed for scalable applications with enterprise-grade features.

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ 
- pnpm
- Docker & Docker Compose
- PostgreSQL (via Docker)

### Local Development Setup

1. **Clone and Install Dependencies**
   ```bash
   git clone <your-repo-url>
   cd my-nestjs
   pnpm install
   ```

2. **Environment Configuration**
   ```bash
   # Copy environment files
   cp .env.example .env
   cp .env.docker.example .env.docker
   
   # Edit .env with your local settings
   # Edit .env.docker for Docker-specific settings
   ```

3. **Start Development Environment**
   ```bash
   # Start all services (PostgreSQL, Redis, MailPit, etc.)
   pnpm docker:dev:up
   
   # Run database migrations
   docker compose exec -it app sh
   pnpm migration:up
   
   # Seed initial data
   pnpm seed:run
   
   # Start the development server
   pnpm start:dev
   ```

4. **Verify Installation**
   - API: http://localhost:3000
   - Swagger Docs: http://localhost:3000/api/docs
   - GraphQL Playground: http://localhost:3000/graphql
   - MailPit (Email Testing): http://localhost:18025
   - Bull Board (Queue Monitoring): http://localhost:3000/admin/queues

## 📦 Core Features

### 🔐 Authentication & Authorization
- **Better Auth Integration**: Complete authentication solution supporting:
  - Email/Password authentication
  - OAuth providers (Google, GitHub, etc.)
  - Magic link authentication
  - Passkey (WebAuthn) support
  - Two-factor authentication (2FA)
  - Role-based access control
  - Session management
- **JWT & Session-based auth**
- **Rate limiting with Redis**
- **Guards and decorators for route protection**

### 🗄️ Database & ORM
- **PostgreSQL** with TypeORM
- **Database migrations** and seeding
- **Entity relationship diagrams** (auto-generated)
- **Connection pooling** and query optimization
- **Multiple database support** (dev/prod configurations)

### 🔄 Background Processing
- **BullMQ** for job queues
- **Worker server** for background task processing
- **Queue monitoring** with Bull Board UI
- **Email queue processing**
- **Retry mechanisms** and error handling

### 📧 Email System
- **React Email** for template development
- **MailPit** for local email testing
- **Multiple email providers** support
- **Template compilation** to HTML
- **Email queue processing**

### 🚀 API Features
- **REST API** with automatic documentation
- **GraphQL** with code-first approach
- **WebSocket** support with Socket.io
- **Redis adapter** for horizontal scaling
- **API versioning**
- **Request/Response validation**
- **Pagination** (offset and cursor-based)

### 📊 Monitoring & Observability
- **Prometheus** metrics collection
- **Grafana** dashboards
- **Sentry** error tracking
- **Pino** structured logging
- **Health checks**
- **Performance monitoring**

### 🛠️ Development Tools
- **Swagger/OpenAPI** documentation
- **Automatic API code generation**
- **Dependency graph visualization**
- **Database ERD generation**
- **Hot reload** development
- **TypeScript** with strict configuration

### 🐳 DevOps & Deployment
- **Docker** containers (dev & prod)
- **Docker Compose** for local development
- **GitHub Actions** CI/CD
- **Environment-specific configurations**
- **Graceful shutdown handling**

## 🏗️ Project Structure

```
src/
├── api/                    # API modules (REST, GraphQL)
│   ├── user/              # User management
│   ├── health/            # Health checks
│   └── file/              # File uploads
├── auth/                  # Authentication & authorization
│   ├── entities/          # Auth-related database entities
│   └── guards/            # Route protection
├── config/                # Configuration management
├── database/              # Database setup & migrations
├── shared/                # Shared services
│   ├── cache/            # Redis caching
│   ├── mail/             # Email services
│   └── socket/           # WebSocket handling
├── worker/               # Background job processing
└── utils/                # Utility functions
```

## 🔧 Development Commands

### Basic Development
```bash
# Start development server
pnpm start:dev

# Build for production
pnpm build

# Run tests
pnpm test
pnpm test:e2e

# Lint code
pnpm lint
pnpm lint:fix
```

### Database Operations
```bash
# Run migrations
pnpm migration:run

# Generate migration
pnpm migration:generate -- src/database/migrations/MigrationName

# Revert migration
pnpm migration:revert

# Seed database
pnpm seed:run
```

### Docker Operations
```bash
# Development environment
pnpm docker:dev:up      # Start dev containers
pnpm docker:dev:down    # Stop dev containers

# Production environment
pnpm docker:prod:up     # Start prod containers
pnpm docker:prod:down   # Stop prod containers
```

### Email Development

We use [React Email](https://react.email/) only in local development. We don't ship React and it's packages in production at all(<i>you can see that all of the React packages are dev only</i>). After our email templates have been created, we convert the `.tsx` files into static html files at build time and NodeMailer uses that html file from our backend. All of these things are handled automatically, you don't have to do any extra setup.

- React Email dev server: See all of your email templates in Web UI.

```
pnpm email:dev
```

- Build email templates(Handled): Convert `.tsx` templates file into html(`.hbs`). This is already handled in post build (`build` script).

```
pnpm email: build
```

- Watch Email(Handled): Watch your `.tsx` email files inside `templates/` folder and convert them to html(`.hbs`). This is already handled when you run your Nest.js server (in `start:dev` script).

```
pnpm email:watch
```

### Monitoring & Analysis
NOTE: Make sure [Graphviz](https://www.graphviz.org/) is installed first.
```
docker-compose run --rm schemaspy /usr/local/bin/schemaspy \
  -t pgsql \
  -host host.docker.internal \
  -u ${POSTGRESQL_USERNAME} \
  -p ${POSTGRESQL_PASSWORD} \
  -db ${POSTGRESQL_DATABASE} \
  -port ${POSTGRESQL_PORT} \
  -s public \
  -connprops useSSL\\=false \
  -imageformat svg \
  -norows
```

```bash
# Generate dependency graph
pnpm graph:app

# Check circular dependencies
pnpm graph:circular

# Generate database ERD
pnpm erd:generate

# Generate API documentation
pnpm codegen
```

## 🔐 Authentication Setup

This boilerplate uses [Better Auth](https://www.better-auth.com/) for comprehensive authentication. The auth API documentation is available at `/api/auth/reference` when the server is running.

### Supported Authentication Methods
- **Email/Password**: Traditional login
- **OAuth**: Google, GitHub, Discord, etc.
- **Magic Links**: Passwordless email authentication
- **Passkeys**: WebAuthn-based authentication
- **Two-Factor Authentication**: TOTP-based 2FA
- **Session Management**: Secure session handling

## 📊 Monitoring Setup

### Enable Monitoring (Optional)
To enable Prometheus and Grafana monitoring:

1. **Update environment configuration**:
   ```bash
   # In .env.docker
   COMPOSE_PROFILES=monitoring
   ```

2. **Access monitoring dashboards**:
   - Grafana: http://localhost:3001 (admin/admin)
   - Prometheus: http://localhost:9090

### Available Dashboards
- **Server Monitoring**: CPU, memory, request rates
- **Database Monitoring**: Query performance, connections
- **Application Metrics**: Custom business metrics

## 🚀 Production Deployment

### Docker Deployment
```bash
# Build and start production containers
pnpm docker:prod:up

# Deploy using script
sh ./bin/deploy.sh
```

### Environment Variables
Ensure all production environment variables are properly configured:
- Database credentials
- Redis configuration
- Email provider settings
- OAuth provider credentials
- Sentry DSN
- AWS/GCP credentials (if using cloud services)

### Health Checks
The application includes comprehensive health checks:
- Database connectivity
- Redis connectivity
- External service dependencies
- Custom business logic checks

## 🧪 Testing

### Test Structure
- **Unit Tests**: Individual service/controller tests
- **Integration Tests**: API endpoint testing
- **E2E Tests**: Full application flow testing

### Running Tests
```bash
# Unit tests
pnpm test

# E2E tests
pnpm test:e2e

# Test coverage
pnpm test:cov

# Watch mode
pnpm test:watch
```

## 📚 API Documentation

### REST API
- **Swagger UI**: http://localhost:3000/api/docs
- **OpenAPI Spec**: http://localhost:3000/api/docs-json

### GraphQL
- **Playground**: http://localhost:3000/graphql
- **Schema**: Auto-generated from TypeScript decorators

### WebSocket
- **Socket.io**: Real-time communication
- **Redis Adapter**: Horizontal scaling support

## 🔄 Background Jobs

### Queue Management
- **Bull Board UI**: http://localhost:3000/admin/queues
- **Job Monitoring**: Real-time job status
- **Retry Configuration**: Automatic retry with backoff
- **Job Scheduling**: Cron-based job scheduling

### Common Job Types
- Email sending
- File processing
- Data synchronization
- Report generation

## 🌐 Internationalization

The application supports multiple languages using i18n:
- **Supported Languages**: English, Spanish (extensible)
- **Translation Files**: Located in `src/i18n/translations/`
- **Auto-detection**: Based on request headers
- **Fallback**: Default language when translation missing

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

This boilerplate is extended from [nestjs-boilerplate](https://github.com/vndevteam/nestjs-boilerplate) and enhanced with additional features for production readiness.

---

**Need Help?** Check the [issues](https://github.com/your-repo/issues) or create a new one for support.
****
