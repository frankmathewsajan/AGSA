# Contributing to AGSA

Thank you for your interest in contributing to AGSA (Automated Government Service Agent)! This document provides guidelines for contributing to the project.

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/agsa-gov-agent-ai.git
   cd agsa-gov-agent-ai
   ```
3. **Set up the development environment** following the [README setup instructions](README.md#setup-instructions)
4. **Create a new branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 🛠️ Development Setup

### Prerequisites
- Python 3.11+ with UV package manager
- Node.js 18+ with npm
- Docker Desktop (optional)
- Google Gemini API key

### Quick Setup
```bash
# Backend
cd backend
uv sync
cp .env.template .env
# Add your Gemini API key to .env
uv run python manage.py migrate
uv run python manage.py runserver

# Frontend (new terminal)
npm install
npm run dev
```

## 📝 Code Style Guidelines

### Python (Backend)
- Follow **PEP 8** style guidelines
- Use **type hints** where appropriate
- Write **docstrings** for functions and classes
- Use **UV** for dependency management
- Format code with **Black** (if available)

### TypeScript/React (Frontend)
- Follow **ESLint** configuration
- Use **TypeScript** strictly
- Prefer **functional components** with hooks
- Use **Tailwind CSS** for styling
- Follow **shadcn/ui** component patterns

## 🧪 Testing

### Running Tests
```bash
# Backend tests
cd backend
uv run python manage.py test
uv run tests/test_complete_flow.py

# Frontend tests (when available)
npm run test
```

### Writing Tests
- Write tests for new features
- Ensure existing tests pass
- Include both unit and integration tests
- Test error conditions and edge cases

## 📋 Pull Request Process

1. **Update documentation** if needed
2. **Add tests** for new functionality
3. **Ensure all tests pass**
4. **Update the README** if necessary
5. **Submit a pull request** with:
   - Clear description of changes
   - Link to related issues
   - Screenshots (if UI changes)
   - Test evidence

### Pull Request Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests pass
- [ ] New tests added
- [ ] Manual testing completed

## Screenshots (if applicable)
```

## 🐛 Reporting Issues

### Bug Reports
Use the GitHub issue template and include:
- **Clear description** of the problem
- **Steps to reproduce** the issue
- **Expected vs actual behavior**
- **Environment details** (OS, browser, versions)
- **Screenshots** if applicable

### Feature Requests
- **Describe the feature** and its benefits
- **Explain the use case** or problem it solves
- **Consider implementation** complexity
- **Provide examples** or mockups if possible

## 🏛️ Government Integration Guidelines

When working on government service integrations:

### Security Considerations
- **Never commit real API keys** or credentials
- **Use mock data** for development
- **Follow data privacy** regulations
- **Implement proper error handling**

### Data Handling
- **Validate all inputs** thoroughly
- **Sanitize user data** before processing
- **Use secure communication** (HTTPS)
- **Implement audit logging**

### Accessibility
- **Follow WCAG guidelines** for accessibility
- **Support multiple languages** (Hindi, English)
- **Design for low-bandwidth** environments
- **Consider users with disabilities**

## 🤝 Code of Conduct

### Our Standards
- **Be respectful** and inclusive
- **Welcome newcomers** and help them learn
- **Focus on constructive feedback**
- **Respect different opinions** and experiences
- **Prioritize community well-being**

### Unacceptable Behavior
- Harassment or discrimination
- Trolling or insulting comments
- Publishing private information
- Political or off-topic discussions
- Spam or commercial promotions

## 📚 Resources

### Documentation
- [Django Documentation](https://docs.djangoproject.com/)
- [React Documentation](https://react.dev/)
- [Google Gemini AI](https://ai.google.dev/)
- [UV Package Manager](https://docs.astral.sh/uv/)

### Learning Resources
- [Government Digital Services](https://www.gov.uk/government/organisations/government-digital-service)
- [Indian Government IT Standards](https://www.meity.gov.in/)
- [Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

## 🎯 Project Goals

Remember that AGSA aims to:
- **Simplify government services** for citizens
- **Reduce bureaucratic friction**
- **Provide accessible digital services**
- **Demonstrate AI potential** in governance
- **Serve as a prototype** for larger implementations

## 💬 Getting Help

- **GitHub Discussions**: For questions and general discussion
- **GitHub Issues**: For bug reports and feature requests
- **Code Reviews**: Learn from feedback on pull requests

---

Thank you for contributing to AGSA and helping make government services more accessible! 🏛️