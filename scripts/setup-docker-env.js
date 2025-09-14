#!/usr/bin/env node

/**
 * Docker Environment Setup Script
 * This script helps set up the Docker environment files
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

async function setupDockerEnvironment() {
  console.log('🐳 AGSA Docker Environment Setup');
  console.log('='.repeat(50));
  
  // Check if .env.docker already exists
  const envDockerPath = '.env.docker';
  if (fs.existsSync(envDockerPath)) {
    const overwrite = await question('⚠️  .env.docker already exists. Overwrite? (y/N): ');
    if (overwrite.toLowerCase() !== 'y') {
      console.log('✅ Setup cancelled. Using existing .env.docker');
      rl.close();
      return;
    }
  }
  
  console.log('\n📝 Please provide the following configuration:');
  
  // Get Gemini API key
  const geminiApiKey = await question('🤖 Gemini API Key (get from https://ai.google.dev/): ');
  
  // Get database password
  const dbPassword = await question('🔐 Database Password (leave empty for auto-generated): ');
  const finalDbPassword = dbPassword || generatePassword();
  
  // Get Redis password
  const redisPassword = await question('🔐 Redis Password (leave empty for auto-generated): ');
  const finalRedisPassword = redisPassword || generatePassword();
  
  // Get domain (optional)
  const domain = await question('🌐 Domain name (optional, for production): ');
  
  // Generate the .env.docker file
  const envContent = generateEnvContent({
    geminiApiKey,
    dbPassword: finalDbPassword,
    redisPassword: finalRedisPassword,
    domain
  });
  
  // Write the file
  fs.writeFileSync(envDockerPath, envContent);
  
  console.log('\n✅ Created .env.docker successfully!');
  console.log('\n🚀 Next steps:');
  console.log('   1. Review and customize .env.docker if needed');
  console.log('   2. Run: npm run docker:build');
  console.log('   3. Run: npm run docker:up');
  console.log('   4. Access the app at http://localhost');
  
  rl.close();
}

function generatePassword(length = 32) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*';
  let password = '';
  for (let i = 0; i < length; i++) {
    password += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return password;
}

function generateEnvContent({ geminiApiKey, dbPassword, redisPassword, domain }) {
  const secretKey = generatePassword(50);
  const allowedHosts = domain ? `localhost,127.0.0.1,${domain}` : 'localhost,127.0.0.1';
  const corsOrigins = domain ? `http://localhost:3000,https://${domain}` : 'http://localhost:3000';
  
  return `# Docker Environment Configuration for AGSA Government Agent AI
# Generated on ${new Date().toISOString()}

# =============================================================================
# GENERAL SETTINGS
# =============================================================================
DEBUG=False
SECRET_KEY=${secretKey}
ALLOWED_HOSTS=${allowedHosts}
CORS_ALLOWED_ORIGINS=${corsOrigins}

# =============================================================================
# DATABASE SETTINGS (PostgreSQL)
# =============================================================================
POSTGRES_DB=agsa_db
POSTGRES_USER=agsa_user
POSTGRES_PASSWORD=${dbPassword}
POSTGRES_PORT=5432

# Database URL for Django
DATABASE_URL=postgresql://agsa_user:${dbPassword}@database:5432/agsa_db

# =============================================================================
# REDIS SETTINGS (Cache & Sessions)
# =============================================================================
REDIS_PASSWORD=${redisPassword}
REDIS_PORT=6379
REDIS_URL=redis://:${redisPassword}@redis:6379/0

# =============================================================================
# GEMINI AI SETTINGS
# =============================================================================
GEMINI_API_KEY=${geminiApiKey}

# =============================================================================
# FRONTEND SETTINGS
# =============================================================================
REACT_APP_API_URL=${domain ? `https://${domain}` : 'http://localhost:8000'}
REACT_APP_ENV=production

# =============================================================================
# DOCKER SERVICE PORTS
# =============================================================================
BACKEND_PORT=8000
FRONTEND_PORT=80
POSTGRES_PORT_HOST=5432
REDIS_PORT_HOST=6379

# =============================================================================
# SECURITY SETTINGS (Production)
# =============================================================================
SECURE_SSL_REDIRECT=${domain ? 'True' : 'False'}
SECURE_HSTS_SECONDS=${domain ? '31536000' : '0'}
SECURE_HSTS_INCLUDE_SUBDOMAINS=${domain ? 'True' : 'False'}
SECURE_HSTS_PRELOAD=${domain ? 'True' : 'False'}

# Session security
SESSION_COOKIE_SECURE=${domain ? 'True' : 'False'}
CSRF_COOKIE_SECURE=${domain ? 'True' : 'False'}

# =============================================================================
# EMAIL SETTINGS (Optional)
# =============================================================================
EMAIL_BACKEND=django.core.mail.backends.console.EmailBackend

# =============================================================================
# LOGGING SETTINGS
# =============================================================================
LOG_LEVEL=INFO
`;
}

// Run the setup
setupDockerEnvironment().catch(console.error);