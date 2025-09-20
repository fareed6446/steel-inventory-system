# Supabase Email Authentication Setup

## 📧 Email Authentication Configuration

### Current Status: ✅ Email Auth Enabled

Since email authentication is enabled in your Supabase project, here's what you need to know:

## 🔧 Configuration Options

### 1. Email Confirmation Settings

In your Supabase Dashboard → Authentication → Settings:

#### **A. Email Confirmations**
- **Enabled**: Users must verify email before signing in
- **Disabled**: Users can sign in immediately after signup

#### **B. Recommended Setting for Development**
```
Email Confirmations: DISABLED
```
**Why?** For development and testing, you want immediate access without email verification.

#### **C. Production Setting**
```
Email Confirmations: ENABLED
```
**Why?** For production, verify emails to ensure valid user accounts.

### 2. Site URL Configuration

#### **Development**
```
Site URL: http://localhost:3000
Redirect URLs: http://localhost:3000/**
```

#### **Production**
```
Site URL: https://yourdomain.com
Redirect URLs: https://yourdomain.com/**
```

### 3. Email Templates

Supabase provides customizable email templates:

#### **A. Sign Up Email**
- **Subject**: "Confirm your signup"
- **Content**: Welcome message with confirmation link

#### **B. Password Reset Email**
- **Subject**: "Reset your password"
- **Content**: Password reset instructions

#### **C. Email Change Email**
- **Subject**: "Confirm your email change"
- **Content**: Email change confirmation

## 🚀 How It Works in Your App

### 1. Sign Up Flow (Email Confirmation ENABLED)

```dart
// User signs up
final success = await _authController.signUp(
  email: 'user@example.com',
  password: 'password123',
  name: 'John Doe',
  role: 'operator',
);

if (success) {
  // User account created but not confirmed
  // Supabase sends confirmation email
  // User must click email link to activate account
}
```

### 2. Sign Up Flow (Email Confirmation DISABLED)

```dart
// User signs up
final success = await _authController.signUp(
  email: 'user@example.com',
  password: 'password123',
  name: 'John Doe',
  role: 'operator',
);

if (success) {
  // User account created and immediately active
  // User can sign in right away
  // No email confirmation required
}
```

### 3. Sign In Flow

```dart
// User signs in
final success = await _authController.signIn(
  email: 'user@example.com',
  password: 'password123',
);

if (success) {
  // User is logged in
  // Session is established
  // Redirect to main app
}
```

## 🔧 Recommended Configuration for Your Project

### For Development/Testing:

1. **Go to Supabase Dashboard**
2. **Authentication → Settings**
3. **Set these values:**
   ```
   Site URL: http://localhost:3000
   Redirect URLs: http://localhost:3000/**
   Email Confirmations: DISABLED
   ```

### For Production:

1. **Go to Supabase Dashboard**
2. **Authentication → Settings**
3. **Set these values:**
   ```
   Site URL: https://yourdomain.com
   Redirect URLs: https://yourdomain.com/**
   Email Confirmations: ENABLED
   ```

## 📱 Testing Your Authentication

### 1. Test Sign Up (No Email Confirmation)

```dart
// In your Flutter app
await _authController.signUp(
  email: 'test@steelfactory.com',
  password: 'test123456',
  name: 'Test User',
  role: 'admin',
);

// Should immediately create account and log in
```

### 2. Test Sign In

```dart
// In your Flutter app
await _authController.signIn(
  email: 'test@steelfactory.com',
  password: 'test123456',
);

// Should log in successfully
```

### 3. Verify in Supabase Dashboard

- **Authentication → Users**: Should see your test user
- **Table Editor → users**: Should see user profile

## 🚨 Common Issues & Solutions

### Issue 1: "Email not confirmed"
**Solution**: Disable email confirmations for development

### Issue 2: "Invalid redirect URL"
**Solution**: Add your app's URL to redirect URLs

### Issue 3: "Site URL mismatch"
**Solution**: Set correct site URL in auth settings

### Issue 4: "Email not sent"
**Solution**: Check email provider settings in Supabase

## 🎯 Next Steps

1. **Configure auth settings** in Supabase Dashboard
2. **Test sign up/sign in** in your Flutter app
3. **Verify user creation** in Supabase
4. **Test role-based access** in your app

## 📞 Support

- **Supabase Auth Docs**: https://supabase.com/docs/guides/auth
- **Email Templates**: https://supabase.com/docs/guides/auth/auth-email-templates
- **Configuration**: https://supabase.com/docs/guides/auth/auth-configuration
