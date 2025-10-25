# 🏛️ AGSA – Automated Government Service Agent

**An AI-powered government services platform that helps citizens discover schemes, verify documents, and navigate bureaucratic processes with ease.**

[🏆 DevPost Project](https://devpost.com/software/agsa-automated-government-service-agen) • [🚀 Quick Start](#quick-start) • [✨ Features](#features) • [⚙️ Setup](#setup) • [🐳 Docker](#docker)

---

**Frontend:** React 18 · TypeScript · Vite · Tailwind CSS · shadcn/ui  
**Backend:** Django 5.2.6 · DRF · PostgreSQL · Google Gemini AI · UV Package Manager  
**Infrastructure:** Docker · Redis · nginx

---

## 📋 Table of Contents

- [🚀 Quick Start](#-quick-start)
- [✨ Features](#-features)
- [⚙️ Setup Instructions](#️-setup-instructions)
- [🐳 Docker Deployment](#-docker-deployment)
- [🔑 Admin Access](#-admin-access)
- [📦 DigiLocker Package](#-digilocker-package)
- [🤖 AI Integration](#-ai-integration)
- [🧪 Testing](#-testing)
- [🏗️ Architecture](#️-architecture)
- [🔮 Future Development](#-future-development)
- [📄 License](#-license)

---

## 🚀 Quick Start

### Prerequisites
- **Python 3.11+** with [UV package manager](https://docs.astral.sh/uv/)
- **Node.js 18+** with npm
- **Docker Desktop** (for containerized deployment)
- **Google Gemini API Key** from [AI Studio](https://aistudio.google.com/app/apikey)

### One-Command Setup (Docker - Recommended)
```bash
# Clone the repository
git clone https://github.com/frankmathewsajan/agsa-gov-agent-ai.git
cd agsa-gov-agent-ai

# Setup environment and deploy
npm run docker:setup:env  # Interactive setup
npm run docker:setup      # Build and start everything

# Access your application
# Frontend: http://localhost
# Backend:  http://localhost:8000
# Admin:    http://localhost:8000/admin
```

### Manual Development Setup
```bash
# Backend setup
cd backend
uv sync                    # Install dependencies
cp .env.template .env      # Copy environment file
# Add your Gemini API key to .env
uv run python manage.py migrate
uv run python manage.py runserver

# Frontend setup (new terminal)
cd ../
npm install
npm run dev
```

---

## ✨ Features

### 🏛️ Government Services Integration
- **Scheme Discovery**: AI-powered search for government schemes and benefits
- **Eligibility Assessment**: Automated qualification checking based on user profile
- **Document Management**: Secure upload, storage, and verification of government documents
- **Application Assistance**: Step-by-step guidance for scheme applications

### 🤖 AI-Powered Assistant
- **Google Gemini Integration**: Advanced natural language processing for user queries
- **Context-Aware Responses**: Maintains conversation history and user context
- **Intent Classification**: Automatically categorizes user requests (eligibility, documents, forms)
- **Confidence Scoring**: AI response reliability metrics with fallback handling

### 🔐 Secure Authentication System
- **DigiLocker Integration**: Mock implementation of India's digital document locker
- **OTP-Based Authentication**: Secure phone number verification
- **KYC Compliance**: Comprehensive user profiling and verification
- **Document Security**: Encrypted storage and secure access controls

### 📱 Modern User Experience
- **Responsive Design**: Works seamlessly across desktop, tablet, and mobile
- **Real-time Chat**: Interactive AI assistant with typing indicators
- **Document Viewer**: Secure in-browser document preview and download
- **Progressive Enhancement**: Graceful fallbacks when services are unavailable

---

## ⚙️ Setup Instructions

### Step 1: Get Your Gemini API Key
1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the generated API key (starts with `AIza...`)
5. Keep this key secure - you'll need it for configuration

### Step 2: Clone and Configure
```bash
# Clone the repository
git clone https://github.com/frankmathewsajan/agsa-gov-agent-ai.git
cd agsa-gov-agent-ai

# Backend configuration
cd backend
uv sync                              # Install Python dependencies
cp .env.template .env               # Create environment file
```

### Step 3: Configure Environment Variables
Edit `backend/.env` and add your configuration:
```env
# Required: Add your Gemini API key
GEMINI_API_KEY=your_gemini_api_key_here

# Optional: Customize other settings
DEBUG=True
SECRET_KEY=your-secret-key-here
DATABASE_URL=sqlite:///db.sqlite3
```

### Step 4: Initialize Database
```bash
cd backend
uv run python manage.py migrate          # Create database tables
uv run python manage.py collectstatic    # Collect static files
```

### Step 5: Create Admin User
```bash
uv run python manage.py createsuperuser
# Follow prompts to create admin credentials
```

### Step 6: Start Development Servers
```bash
# Terminal 1: Backend server
cd backend
uv run python manage.py runserver

# Terminal 2: Frontend development server
cd ..
npm install
npm run dev
```

### Step 7: Access Your Application
- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **Admin Panel**: http://localhost:8000/admin

---

## 🐳 Docker Deployment

### Quick Docker Setup
```bash
# Interactive environment setup
npm run docker:setup:env

# One-command deployment
npm run docker:setup

# Access applications
# Frontend: http://localhost
# Backend: http://localhost:8000
```

### Docker Commands Reference
```bash
# Production environment
npm run docker:build        # Build images
npm run docker:up           # Start services
npm run docker:down         # Stop services
npm run docker:logs         # View logs
npm run docker:clean        # Clean everything

# Development environment
npm run docker:dev:up       # Start dev environment
npm run docker:dev:down     # Stop dev environment
npm run docker:dev:logs     # View dev logs

# Service-specific operations
npm run docker:backend:logs  # Backend logs only
npm run docker:frontend:logs # Frontend logs only
npm run docker:db:logs       # Database logs only
```

### Docker Services
| Service | Production Port | Development Port | Purpose |
|---------|----------------|------------------|---------|
| Frontend (nginx) | 80 | 3001 | React application |
| Backend (Django) | 8000 | 8001 | API server |
| Database (PostgreSQL) | 5432 | 5433 | Data storage |
| Redis | 6379 | 6380 | Caching & sessions |

---

## 🔑 Admin Access

### Creating a Superuser
After setting up the application, create an admin user to access the Django admin panel:

```bash
# Local development
cd backend
uv run python manage.py createsuperuser

# Docker environment
docker-compose exec backend uv run python manage.py createsuperuser
```

### Admin Panel Features
Access the admin panel at `http://localhost:8000/admin` to:

- **📄 Manage Documents**: Upload and organize government documents
- **👥 User Management**: View and manage user accounts
- **🏛️ Scheme Administration**: Add and modify government schemes
- **📊 System Monitoring**: View application logs and statistics
- **🔧 Configuration**: Manage system settings and API keys

### Document Upload Process
1. Login to admin panel with superuser credentials
2. Navigate to "Documents" section
3. Click "Add Document" to upload new documents
4. Set document type, visibility, and metadata
5. Documents become available to users through the main interface

---

## 📦 DigiLocker Package

### Overview
AGSA includes a custom DigiLocker package (`backend/digilocker/`) that provides a mock implementation of India's digital document locker system.

### Package Structure
```
backend/digilocker/
├── __init__.py          # Package initialization
├── client.py            # Main DigiLocker client
├── exceptions.py        # Custom exception classes
├── models.py           # Data models and schemas
└── client_db.py        # Database interaction layer
```

### Using the DigiLocker Client
```python
from digilocker.client import DigiLockerClient

# Initialize client
client = DigiLockerClient()

# Authenticate user
client.authenticate(mobile_number="9876543210")
client.verify_otp(otp="123456")

# Fetch user documents
documents = client.get_documents()

# Download specific document
document_data = client.download_document(doc_id="DOC123")
```

### Authentication Flow
1. **Mobile Verification**: User provides mobile number
2. **OTP Generation**: System sends verification code
3. **OTP Validation**: User enters code for authentication
4. **Session Management**: Secure session creation and maintenance
5. **Document Access**: Authenticated access to user documents

### Security Features
- **OTP-based Authentication**: No passwords, only secure mobile verification
- **Session Management**: Time-limited authenticated sessions
- **Document Encryption**: Secure storage and transmission of sensitive documents
- **Access Logging**: Comprehensive audit trails for document access

### Extending the Package
The DigiLocker package is designed to be modular and extensible:

```python
# Custom document validator
class CustomDocumentValidator:
    def validate_aadhaar(self, document):
        # Implementation for Aadhaar validation
        pass
    
    def validate_pan(self, document):
        # Implementation for PAN validation
        pass

# Integration with external services
client = DigiLockerClient(
    validator=CustomDocumentValidator(),
    storage_backend=AWSS3Storage(),
    notification_service=SMSService()
)
```

---

## 🤖 AI Integration

### Google Gemini Configuration
The application uses Google Gemini Pro for intelligent chat responses:

```python
# backend/chat/ai_service.py
import google.generativeai as genai

class GeminiChatService:
    def __init__(self):
        genai.configure(api_key=settings.GEMINI_API_KEY)
        self.model = genai.GenerativeModel('gemini-1.5-flash')
    
    def analyze_user_message(self, message, context=None):
        # AI processing with government service specialization
        response = self.model.generate_content(prompt)
        return self.parse_ai_response(response)
```

### AI Features
- **Intent Classification**: Automatically categorizes user queries
- **Confidence Scoring**: Reliability metrics for AI responses
- **Context Preservation**: Maintains conversation history
- **Fallback Handling**: Graceful degradation when AI is unavailable
- **Government Domain Expertise**: Specialized knowledge of Indian government schemes

### Chat Flow Architecture
1. User sends message via React frontend
2. Frontend calls `/api/chat/` API endpoint
3. Backend processes with `GeminiChatService`
4. Gemini AI generates contextual response
5. Response includes structured data (intent, confidence, actions)
6. Frontend displays with AI indicators and typing animations

---

## 🧪 Testing

### Backend Test Suite
```bash
cd backend

# Populate test data
uv run tests/populate_sample_data.py

# Run specific test categories
uv run tests/test_complete_flow.py        # End-to-end testing
uv run tests/test_chat_api.py            # AI chat functionality
uv run tests/test_api.py                 # Authentication & documents
uv run tests/test_frontend_backend_integration.py  # Integration tests

# Run all Django tests
uv run python manage.py test
```

### Test Categories
| Test File | Purpose |
|-----------|---------|
| `test_complete_flow.py` | End-to-end user journey testing |
| `test_chat_api.py` | AI chat functionality and Gemini integration |
| `test_api.py` | Authentication and document API testing |
| `test_frontend_backend_integration.py` | Cross-system integration tests |
| `populate_sample_data.py` | Database seeding with sample data |

### Frontend Testing (Planned)
```bash
# Future implementation with Vitest + React Testing Library
npm run test
npm run test:coverage
npm run test:e2e
```

---

## 🏗️ Architecture

### System Overview
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  React Frontend │    │  Django Backend │    │  Google Gemini  │
│  (Vite + TS)    │◄──►│  (DRF + SQLite) │◄──►│   AI Service    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     nginx       │    │   PostgreSQL    │    │     Redis       │
│  (Production)   │    │   (Production)  │    │   (Sessions)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Frontend Architecture
- **React 18**: Modern React with hooks and context
- **TypeScript**: Type-safe development
- **Vite**: Fast build tool and dev server
- **Tailwind CSS**: Utility-first styling
- **shadcn/ui**: High-quality UI components
- **React Router**: Client-side routing
- **Framer Motion**: Smooth animations

### Backend Architecture
- **Django 5.2.6**: Modern Python web framework
- **Django REST Framework**: API development
- **UV Package Manager**: Fast Python dependency management
- **PostgreSQL**: Production-ready database
- **Redis**: Caching and session storage
- **Google Gemini AI**: Advanced language model

### Security Features
- **CORS Configuration**: Secure cross-origin requests
- **CSRF Protection**: Cross-site request forgery prevention
- **Secure Headers**: XSS, clickjacking, and content type protection
- **Input Validation**: Comprehensive data sanitization
- **Error Handling**: Secure error messages without information leakage

---

## 🔮 Future Development

### Current Status: Prototype
AGSA is currently a **proof-of-concept prototype** demonstrating the potential of AI-powered government services. This implementation showcases core functionality and user experience patterns.

### Production Roadmap

#### 🔐 Security Enhancements
- **Production-grade Authentication**: Integration with actual DigiLocker API
- **Advanced Encryption**: End-to-end encryption for sensitive documents
- **Audit Logging**: Comprehensive security event tracking
- **Penetration Testing**: Security vulnerability assessments
- **Compliance Certification**: SOC 2, ISO 27001 compliance

#### 🏛️ Government Integration
- **Real API Integration**: Connection to actual government databases
- **Multi-state Support**: Support for different state government schemes
- **Document Verification**: Real-time verification with issuing authorities
- **Blockchain Integration**: Immutable document verification system
- **Inter-agency Connectivity**: Seamless data sharing between departments

#### 🤖 AI Model Improvements
- **Custom Fine-tuning**: Government-specific language model training
- **Multi-language Support**: Regional language processing capabilities
- **Advanced NLP**: Better intent recognition and entity extraction
- **Predictive Analytics**: Proactive scheme recommendations
- **Voice Interface**: Speech-to-text and text-to-speech capabilities

#### 📊 Analytics & Insights
- **User Analytics**: Comprehensive usage patterns and insights
- **Performance Monitoring**: Real-time system health and performance
- **Scheme Effectiveness**: Data-driven policy recommendations
- **Citizen Feedback**: Automated sentiment analysis and feedback processing
- **Predictive Modeling**: Anticipating citizen needs and service gaps

#### 🌐 Scalability & Performance
- **Microservices Architecture**: Scalable service decomposition
- **Load Balancing**: High-availability deployment patterns
- **CDN Integration**: Global content delivery optimization
- **Caching Strategies**: Multi-layer caching for performance
- **Auto-scaling**: Dynamic resource allocation based on demand

### Vision Statement
The ultimate goal is to create a **comprehensive digital government platform** that:
- Eliminates bureaucratic friction for citizens
- Provides instant access to all government services
- Uses AI to predict and fulfill citizen needs proactively
- Ensures transparency and accountability in government processes
- Bridges the digital divide with multilingual, accessible interfaces

### DevPost Recognition
This project was showcased on [DevPost](https://devpost.com/software/agsa-automated-government-service-agen) as part of demonstrating innovative solutions for government digitization challenges.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on:
- Code of conduct
- Development setup
- Pull request process
- Issue reporting

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/frankmathewsajan/agsa-gov-agent-ai/issues)
- **Discussions**: [GitHub Discussions](https://github.com/frankmathewsajan/agsa-gov-agent-ai/discussions)
- **DevPost**: [Project Page](https://devpost.com/software/agsa-automated-government-service-agen)

---

<div align="center">
	<p><strong>Built with ❤️ for a better digital India</strong></p>
	<p>🏛️ AGSA - Making Government Services Accessible to All</p>
</div>

### Frontend Setup
```bash
git clone <repo-url>
cd agsa-gov-agent-ai
npm install
npm run dev
```

### Backend Setup
```bash
cd backend
uv sync
uv run manage.py migrate
uv run manage.py runserver
```

**Servers:**
- Frontend (Vite): http://localhost:8081
- Backend (Django): http://localhost:8000

### Environment Variables
Create `backend/.env`:
```bash
GEMINI_API_KEY=your_google_gemini_api_key_here
SECRET_KEY=your_django_secret_key
DEBUG=True
```

## 2. Core Concept
AGSA is a full-stack AI-powered government service assistant that:
- **Real Authentication**: Phone+OTP login/registration with Django backend
- **KYC Integration**: Comprehensive Know Your Customer data collection
- **Document Management**: Upload, download, and verify government documents
- **AI-Powered Chat**: Google Gemini-powered conversational assistant for scheme discovery, eligibility checks, and application guidance
- **Real-time Processing**: Contextual AI responses with confidence scoring and intent classification

The system integrates real AI capabilities with government service workflows, replacing previous mocks with production-ready APIs.

## 3. Application Flow & API Endpoints

### Frontend Routes
Route | File | Purpose
------|------|--------
`/` | `src/pages/Index.tsx` | Landing page with hero, features, and call-to-action
`/auth` | `src/pages/Auth.tsx` | Phone+OTP authentication with real backend integration
`/documents` | `src/pages/Documents.tsx` | Document upload/download with Django file handling
`/chat` | `src/pages/Chat.tsx` | Google Gemini-powered AI assistant with contextual responses
`*` | `src/pages/NotFound.tsx` | 404 fallback page

### Backend API Endpoints

#### Authentication APIs (`/api/auth/`)
- `POST /api/auth/send-otp/` - Send OTP to phone number
- `POST /api/auth/verify-otp/` - Verify OTP and authenticate
- `POST /api/auth/register/` - Register new user with KYC data
- `GET /api/auth/profile/` - Get user profile information
- `POST /api/auth/logout/` - Logout user session

#### Document APIs (`/api/documents/`)
- `GET /api/documents/` - List user's uploaded documents
- `POST /api/documents/upload/` - Upload new document (multipart/form-data)
- `GET /api/documents/{id}/download/` - Download document (base64 encoded)

#### Chat APIs (`/api/chat/`)
- `POST /api/chat/sessions/` - Create new chat session
- `GET /api/chat/sessions/{id}/` - Get chat session with message history
- `POST /api/chat/send/` - Send message and get AI response
- `POST /api/chat/eligibility/` - Check scheme eligibility
- `POST /api/chat/form-assistance/` - Get form filling assistance

### Backend Architecture

#### Django Apps Structure
```
backend/
├── agsa/                    # Main Django project
│   ├── settings.py         # Django configuration + Gemini API setup
│   ├── urls.py            # Root URL configuration
│   └── wsgi.py/asgi.py    # WSGI/ASGI application
├── api/                    # Authentication & documents API
│   ├── models.py          # User, UserProfile, Document models
│   ├── views.py           # Auth, profile, document endpoints
│   ├── serializers.py     # DRF serializers
│   └── urls.py            # API routes
├── chat/                   # AI-powered chat system
│   ├── models.py          # ChatSession, ChatMessage, ChatContext models
│   ├── ai_service.py      # Google Gemini integration
│   ├── views.py           # Chat endpoints with AI processing
│   ├── serializers.py     # Chat-specific serializers
│   └── urls.py            # Chat routes
├── digilocker/            # DigiLocker integration (future)
└── tests/                 # Comprehensive test suite
```

#### Key Backend Features
- **Google Gemini Integration**: Real AI responses with confidence scoring
- **Session Management**: Persistent chat sessions with context
- **Document Handling**: Secure file upload/download with base64 encoding
- **KYC Data Collection**: Comprehensive user profiling during registration
- **Intent Classification**: AI categorizes user queries (eligibility, documents, forms)
- **Fallback Handling**: Graceful degradation when AI services are unavailable

## 4. Testing Framework

### Backend Testing Structure
The backend includes a comprehensive testing framework in `backend/tests/`:

Test File | Purpose
----------|--------
`test_complete_flow.py` | End-to-end user journey testing
`test_chat_api.py` | AI chat functionality and Gemini integration
`test_api.py` | Authentication and document API testing
`test_frontend_backend_integration.py` | Cross-system integration tests
`populate_sample_data.py` | Database seeding with sample data
`simple_test.py` | Basic connectivity and health checks

**Running Tests:**
```bash
cd backend

# Populate sample data
uv run tests/populate_sample_data.py

# Run specific test suites
uv run tests/test_complete_flow.py
uv run tests/test_chat_api.py

# Run all tests
uv run manage.py test
```

### Frontend Testing (Planned)
```bash
# Future implementation with Vitest + React Testing Library
npm run test
npm run test:coverage
```

## 5. Key Files & Architecture

### Frontend Architecture
Category | File | Notes
---------|------|------
Entry | `index.html` | Base HTML, fonts, metadata, social OG tags
Bootstrap | `src/main.tsx` | Creates React root and renders `<App />`
App Shell | `src/App.tsx` | Providers: Auth Context, Toast, Routes
Pages | `src/pages/*.tsx` | Main application views (Index, Auth, Documents, Chat)
Components | `src/components/ui/*` | shadcn/ui + Radix primitives (accessible building blocks)
Services | `src/services/*.ts` | API clients for auth, documents, chat
Contexts | `src/contexts/*.tsx` | React contexts for global state management
Hooks | `src/hooks/*.ts` | Custom React hooks (toast, auth, etc.)
Utilities | `src/lib/utils.ts` | Helper functions and utilities
Assets | `src/assets/*` | Images, logos, and static resources
Styling | `src/index.css`, `tailwind.config.ts` | Tailwind configuration + global styles

### Backend Architecture
Category | File/Directory | Notes
---------|----------------|------
Django Project | `backend/agsa/` | Main Django configuration and settings
Auth API | `backend/api/` | User authentication, profiles, documents
Chat API | `backend/chat/` | AI-powered chat with Gemini integration
AI Service | `backend/chat/ai_service.py` | Google Gemini API integration
Models | `*/models.py` | Database schema definitions
Serializers | `*/serializers.py` | DRF request/response serialization
Views | `*/views.py` | API endpoint implementations
Tests | `backend/tests/` | Comprehensive test suite
Database | `backend/db.sqlite3` | SQLite database (development)
Dependencies | `backend/pyproject.toml` | UV package management

## 5. Chat Assistant Logic
The assistant in `Chat.tsx` is a state machine–like heuristic using keyword matching:
- Detects “scheme”, “benefit”, “subsidy” → eligibility flow
- Then “document”, “verify”, “yes” → document verification status messages
- Then “form”, “application”, “prepare” → application summary
Messages are stored in local component state; timestamps + simple formatted rendering.

To integrate a real LLM:
1. Extract `simulateAssistantResponse` into a service module.
2. Replace keyword logic with API call (e.g., `/api/chat` streaming).
3. Normalize responses into the `Message` shape.
4. Add loading & error states (TanStack Query or custom controller).

## 7. Authentication & User Management

### Real Authentication System
- **Phone+OTP**: Primary authentication method
- **Session Management**: Django session-based authentication
- **KYC Integration**: Comprehensive user profiling during registration
- **Profile Management**: Secure user data storage and retrieval

**Authentication Flow:**
1. User enters phone number
2. Backend sends OTP via SMS (simulated)
3. User verifies OTP
4. Session established with Django backend
5. User proceeds to KYC or main app

### User Profile & KYC
The system collects comprehensive KYC data:
- Personal Information (name, DOB, address)
- Government IDs (Aadhaar, PAN, voter ID)
- Income and employment details
- Family information
- Document uploads and verification

## 8. Document Management System

### Secure File Handling
- **Upload**: Multipart form data with validation
- **Storage**: Django file handling with secure paths
- **Download**: Base64 encoded responses for browser compatibility
- **Metadata**: Document type, upload date, verification status

**Supported Document Types:**
- Government IDs (Aadhaar, PAN, Passport)
- Income proofs (salary slips, ITR)
- Address proofs (utility bills, bank statements)
- Educational certificates
- Custom document types

### API Integration
```typescript
// Frontend document service
export const documentService = {
  uploadDocument: (file: File, documentType: string) => 
    api.post('/api/documents/upload/', formData),
  
  getDocuments: () => 
    api.get('/api/documents/'),
    
  downloadDocument: (id: string) => 
    api.get(`/api/documents/${id}/download/`)
};
```

## 9. Styling & Design System

### Frontend Technologies
- **Tailwind CSS**: Utility-first styling with consistent design tokens
- **shadcn/ui + Radix**: Accessible component primitives
- **Framer Motion**: Smooth animations and micro-interactions
- **Responsive Design**: Mobile-first approach with desktop optimization

### Component Architecture
- **`cn` helper**: Conditional class merging utility
- **Design Tokens**: Consistent spacing, colors, typography
- **Accessibility**: ARIA labels, keyboard navigation, screen reader support
- **Motion System**: Entrance animations, loading states, transitions

## 10. State Management & Data Flow

### Frontend State
- **React Context**: Global auth state and user management
- **Local State**: Component-specific state (forms, UI)
- **Service Layer**: API communication and data transformation
- **Error Handling**: Centralized error boundaries and toast notifications

### Backend State
- **Database**: SQLite (development) / PostgreSQL (production ready)
- **Session Management**: Django sessions for authentication
- **File Storage**: Local file system (development) / cloud storage ready
- **AI Context**: Persistent chat sessions with conversation history

## 11. Development & Production Setup

### Package Management
- **Frontend**: npm with Vite for fast development
- **Backend**: UV (modern Python package manager) for dependency management

### Scripts & Commands

#### Frontend Scripts
```bash
npm run dev          # Start development server (http://localhost:8081)
npm run build        # Production build
npm run preview      # Preview production build
npm run lint         # ESLint code checking
```

#### Backend Scripts  
```bash
uv sync              # Install dependencies
uv run manage.py migrate           # Apply database migrations
uv run manage.py runserver         # Start Django server (http://localhost:8000)
uv run manage.py createsuperuser   # Create admin user
uv run manage.py collectstatic     # Collect static files (production)
```

### Environment Configuration
Create `backend/.env` with:
```bash
# Required
GEMINI_API_KEY=your_google_gemini_api_key_here
SECRET_KEY=your_django_secret_key_here

# Optional
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
CORS_ALLOWED_ORIGINS=http://localhost:8081
```

### Database Setup
```bash
cd backend
uv run manage.py makemigrations
uv run manage.py migrate
uv run tests/populate_sample_data.py  # Add sample data
```

## 12. Future Enhancements & Roadmap

### Priority 1 (Core Features)
Priority | Enhancement | Status
---------|-------------|--------
✅ | Real Authentication | **Complete** - Phone+OTP with Django backend
✅ | AI Chat Integration | **Complete** - Google Gemini integration
✅ | Document Management | **Complete** - Upload/download with validation
✅ | KYC Data Collection | **Complete** - Comprehensive user profiling
🔄 | Production Deployment | In Progress - Docker + cloud setup
🔄 | Enhanced AI Features | In Progress - Scheme recommendations, form assistance

### Priority 2 (User Experience)
Priority | Enhancement | Summary
---------|-------------|--------
📋 | Real SMS Integration | Replace OTP simulation with actual SMS service
📋 | Advanced Document Verification | AI-powered document authenticity checking
📋 | Scheme Database Integration | Connect to real government scheme databases
📋 | Multi-language Support | Hindi + regional language support
📋 | Offline Capabilities | PWA features for limited connectivity scenarios

### Priority 3 (Platform Features)
Priority | Enhancement | Summary
---------|-------------|--------
📋 | Admin Dashboard | Django admin interface for user management
📋 | Analytics Integration | User journey tracking and insights
📋 | API Rate Limiting | Protect AI endpoints from abuse
📋 | Advanced Testing | Comprehensive E2E testing with Playwright
📋 | Performance Optimization | Caching, CDN, database optimization

## 13. Deployment
Use this lightweight branching model:
```bash
git checkout -b feat/<short-name>
# implement
git commit -m "feat(chat): add streaming support"
git push origin feat/<short-name>
```
Open a PR; include before/after screenshots for UI changes.

### Suggested Folder Additions (when scaling)
```
src/
	api/          # API clients, request/response schemas
	services/     # Domain logic (eligibility, documents, chat orchestration)
	store/        # Zustand / Redux / Jotai (if needed)
	types/        # Shared TypeScript types
	tests/        # Unit & integration tests
```

## 11. Environment & Configuration
Currently no `.env` file required. When adding backends define e.g.:
```
VITE_API_BASE_URL=https://api.example.com
VITE_OPENAI_API_KEY=... (never commit)
```
Access via `import.meta.env.VITE_API_BASE_URL`.

## 12. Scripts
Script | Purpose
-------|--------
`npm run dev` | Start Vite dev server
`npm run build` | Production build (outputs to `dist/`)
`npm run build:dev` | Development-mode build (useful for profiling)
`npm run preview` | Preview built assets locally
`npm run lint` | Run ESLint over the repo

## 13. Tech Decisions Rationale
- Vite: fast HMR & TS integration
- shadcn/ui + Radix: accessible primitives without heavy design overhead
- React Query prepared: future async data orchestration
- Framer Motion: subtle motion for perceived polish
- Keyword-based assistant: rapid prototyping before committing to LLM costs

## 14. Testing (Proposed Setup)
Install (future): `vitest`, `@testing-library/react`, `@testing-library/user-event`, `jsdom`.
Example test target candidates:
- Chat flow triggers (eligibility → documents → summary)
- KYC integration state transitions
- Auth mode switch (login/register + phone/email)

## 15. Accessibility Checklist (Current Gaps)
- Add `aria-live="polite"` region for incoming assistant messages
- Ensure focus trapping in dialogs (when added later)
- Provide skip-to-content link on landing
- Confirm color contrast (run tooling)

## 16. Deployment
Any static host works (Netlify, Vercel, Cloudflare Pages, GitHub Pages):
```bash
npm run build
# deploy dist/ directory
```
When adding server features, introduce a `/api` proxy in `vite.config.ts`.

## 17. Security Notes / Future
- Sanitize user input before sending to LLM / backend
- Rate limit scheme lookups
- Use token-based session (JWT / HttpOnly cookie) for persisted auth
- Implement audit logging for sensitive eligibility queries

## 18. File Change Map (Where to Add What)
Need | Modify File(s) | Notes
-----|----------------|------
Add real chat backend | `src/pages/Chat.tsx`, new `src/services/chat.ts` | Extract simulation → service
Persist user profile | `src/pages/Auth.tsx`, `src/pages/KYC.tsx`, add `src/api/user.ts` | Replace timeouts with API
Add scheme catalog | New: `src/api/schemes.ts`, `src/services/eligibility.ts` | Query + filter + rank
Add global store | New: `src/store/*` | Manage auth/session outside pages
Add dark mode toggle | `Navbar.tsx`, use `next-themes` or CSS class toggle | Tailwind `dark:` support

## 14. Contributing & Development Guidelines

### Development Workflow
```bash
git checkout -b feat/<feature-name>
# Implement changes
git commit -m "feat(chat): add real-time AI responses"
git push origin feat/<feature-name>
# Open pull request with screenshots for UI changes
```

### Code Standards
- **Frontend**: ESLint + Prettier configuration
- **Backend**: Black formatting + Django best practices
- **TypeScript**: Strict type checking enabled
- **Testing**: Write tests for new features
- **Documentation**: Update README for significant changes

### Folder Structure (Current)
```
src/
├── components/ui/     # Reusable UI components
├── pages/            # Main application pages
├── services/         # API clients and data services
├── contexts/         # React context providers
├── hooks/            # Custom React hooks
├── lib/              # Utility functions
└── assets/           # Static resources

backend/
├── agsa/             # Django project configuration
├── api/              # Authentication and documents
├── chat/             # AI chat functionality
├── tests/            # Test suites
└── docs/             # API documentation
```

## 15. Security & Best Practices

### Current Security Measures
- **CORS Configuration**: Proper cross-origin request handling
- **Session Management**: Django's built-in session security
- **Input Validation**: DRF serializers with validation
- **File Upload Security**: Type and size validation
- **Environment Variables**: Sensitive data in .env files

### Production Security Checklist
- [ ] HTTPS enforcement
- [ ] Rate limiting on AI endpoints
- [ ] Input sanitization for LLM prompts
- [ ] Audit logging for sensitive operations
- [ ] Database connection encryption
- [ ] Static file security headers

## 16. Performance Optimization

### Frontend Optimizations
- **Code Splitting**: Lazy loading for routes
- **Image Optimization**: Compressed assets
- **Bundle Analysis**: Regular bundle size monitoring
- **Memoization**: React.memo for expensive components
- **Debounced Inputs**: Reduced API calls

### Backend Optimizations
- **Database Indexing**: Optimized queries
- **Caching Strategy**: Redis for session data
- **AI Response Caching**: Reduce Gemini API calls
- **File Storage**: CDN for document serving
- **Connection Pooling**: Database connection optimization

## 17. Troubleshooting

### Common Issues
**Frontend Build Errors:**
```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

**Backend Database Issues:**
```bash
# Reset database (development only)
rm backend/db.sqlite3
uv run manage.py migrate
uv run tests/populate_sample_data.py
```

**Gemini API Errors:**
```bash
# Check API key in .env file
echo $GEMINI_API_KEY

# Test API connectivity
uv run tests/test_chat_api.py
```

## 18. API Documentation

### Interactive API Docs
- Django REST Framework browsable API: http://localhost:8000/api/
- Swagger/OpenAPI documentation (future): http://localhost:8000/docs/

### Example API Calls
```bash
# Authentication
curl -X POST http://localhost:8000/api/auth/send-otp/ \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "+919876543210"}'

# Chat message
curl -X POST http://localhost:8000/api/chat/send/ \
  -H "Content-Type: application/json" \
  -H "Cookie: sessionid=<session_id>" \
  -d '{"session_id": "uuid", "message": "What schemes am I eligible for?"}'
```

## 19. License

This project is licensed under the MIT License - see the LICENSE file for details.

## 20. Maintainers & Support

**Primary Maintainer:** AGSA Development Team  
**Support:** Create an issue on GitHub for bugs or feature requests  
**Documentation:** This README is updated with each major release

---

**Current Status:** ✅ Production-ready with real AI integration and comprehensive backend APIs

> **Note:** This system now includes real AI capabilities, authentication, and document management. All previous mocks have been replaced with production-ready implementations.

