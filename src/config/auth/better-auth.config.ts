import { AuthService } from '@/auth/auth.service';
import { GlobalConfig } from '@/config/config.type';
import { CacheService } from '@/shared/cache/cache.service';
import { validateUsername } from '@/utils/validators/username';
import { ConfigService } from '@nestjs/config';
import { APIError } from 'better-auth/api';
import { magicLink, openAPI, twoFactor, username } from 'better-auth/plugins';
import { passkey } from 'better-auth/plugins/passkey';
import { BetterAuthOptions, BetterAuthPlugin } from 'better-auth/types';
import { Pool } from 'pg';
import { v4 as uuid } from 'uuid';

/**
 * Better Auth Configuration
 * Visit https://www.better-auth.com/docs/reference/options to see full options
 * Visit `/api/auth/reference` to see all the API references integrated in this better auth instance
 */
export function getConfig({
  configService,
  cacheService,
  authService,
}: {
  configService: ConfigService<GlobalConfig>;
  cacheService: CacheService;
  authService: AuthService;
}): BetterAuthOptions {
  const appConfig = configService.getOrThrow('app', { infer: true });
  const databaseConfig = configService.getOrThrow('database', { infer: true });
  const authConfig = configService.getOrThrow('auth', { infer: true });

  // Core plugins
  const plugins: BetterAuthPlugin[] = [
    username({ usernameValidator: validateUsername }),
    magicLink({
      disableSignUp: true,
      async sendMagicLink({ email, url }) {
        try {
          await authService.sendSigninMagicLink({ email, url });
        } catch (error: any) {
          throw new APIError(error.status, {
            status: error.status,
            message: error.message,
          });
        }
      },
    }),
    twoFactor({
      schema: {
        user: {
          fields: {
            twoFactorEnabled: 'two_factor_enabled',
          },
        },
        twoFactor: {
          modelName: 'two_factors',
          fields: {
            userId: 'user_id',
            secret: 'secret',
            backupCodes: 'backup_codes',
          },
        },
      },
    }),
    passkey({
      rpName: appConfig.name,
      schema: {
        passkey: {
          modelName: 'passkeys',
          fields: {
            name: 'name',
            userId: 'user_id',
            publicKey: 'public_key',
            credentialID: 'credential_id',
            counter: 'counter',
            deviceType: 'device_type',
            backedUp: 'backed_up',
            transports: 'transports',
            aaguid: 'aaguid',
            createdAt: 'created_at',
          },
        },
      },
    }),
  ];

  // Plugins for development only
  const nonProdPlugins = [openAPI()];
  if (appConfig.nodeEnv !== 'production') {
    plugins.push(...nonProdPlugins);
  }

  return {
    appName: appConfig.name,
    secret: authConfig.authSecret,
    baseURL: appConfig.url,
    plugins,
    database: new Pool({
      database: databaseConfig.database,
      user: databaseConfig.username,
      password: databaseConfig.password,
      host: databaseConfig.host,
      port: databaseConfig.port,
      ...(typeof databaseConfig.ssl === 'object'
        ? {
            ssl: {
              rejectUnauthorized: databaseConfig.ssl?.rejectUnauthorized,
              ca: databaseConfig.ssl?.ca,
              key: databaseConfig.ssl?.key,
              cert: databaseConfig.ssl?.cert,
            },
          }
        : {}),
    }),
    emailAndPassword: {
      enabled: true,
      autoSignIn: false,
      requireEmailVerification: true,
      sendResetPassword: async ({ url, user }) => {
        try {
          await authService.resetPassword({ url, userId: user.id });
        } catch (error: any) {
          throw new APIError(error.status, {
            status: error.status,
            message: error.message,
          });
        }
      },
    },
    session: {
      freshAge: 0, // We perform every sensitive operation via our own API so this is irrelevant.
      modelName: 'sessions',
      fields: {
        userId: 'user_id',
        expiresAt: 'expires_at',
        ipAddress: 'ip_address',
        userAgent: 'user_agent',
        createdAt: 'created_at',
        updatedAt: 'updated_at',
      },
    },
    user: {
      modelName: 'users',
      fields: {
        name: 'first_name',
        emailVerified: 'is_email_verified',
        createdAt: 'created_at',
        updatedAt: 'updated_at',
      },
      additionalFields: {
        last_name: {
          type: 'string',
          required: false,
          input: true,
        },
        username: {
          type: 'string',
          required: false,
          input: true,
        },
        role: {
          type: 'string',
          required: false,
          defaultValue: 'professor',
          input: false, // don't allow user to set role
        },
        university_id: {
          type: 'string',
          required: false,
          input: false, // don't allow user to set university_id
        },
        status: {
          type: 'string',
          required: false,
          defaultValue: 'pending',
          input: false, // don't allow user to set status
        },
        last_login_at: {
          type: 'string',
          required: false,
          input: false, // don't allow user to set last_login_at
        },
        // Extended user information (moved from user_profiles)
        phone: {
          type: 'string',
          required: false,
          input: true,
        },
        address: {
          type: 'string',
          required: false,
          input: true,
        },
        bio: {
          type: 'string',
          required: false,
          input: true,
        },
        department: {
          type: 'string',
          required: false,
          input: true,
        },
        position: {
          type: 'string',
          required: false,
          input: true,
        },
        research_field: {
          type: 'string',
          required: false,
          input: true,
        },
      },
    },
    account: {
      modelName: 'accounts',
      fields: {
        userId: 'user_id',
        accountId: 'account_id',
        providerId: 'provider_id',
        accessToken: 'access_token',
        refreshToken: 'refresh_token',
        accessTokenExpiresAt: 'access_token_expires_at',
        refreshTokenExpiresAt: 'refresh_token_expires_at',
        idToken: 'id_token',
        createdAt: 'created_at',
        updatedAt: 'updated_at',
      },
    },
    verification: {
      modelName: 'verifications',
      fields: {
        expiresAt: 'expires_at',
        createdAt: 'created_at',
        updatedAt: 'updated_at',
      },
    },
    emailVerification: {
      sendVerificationEmail: async ({ user, url }) => {
        try {
          await authService.verifyEmail({ url, userId: user.id });
        } catch (error: any) {
          throw new APIError(error.status, {
            status: error.status,
            message: error.message,
          });
        }
      },
    },
    trustedOrigins: appConfig.corsOrigin as string[],
    socialProviders: {
      ...(authConfig.oAuth.github?.clientId && authConfig.oAuth.github?.clientSecret
        ? {
            github: {
              clientId: authConfig.oAuth.github?.clientId,
              clientSecret: authConfig.oAuth.github?.clientSecret,
              mapProfileToUser(profile) {
                return {
                  email: profile.email,
                  first_name: profile.name?.split(' ')[0] || profile.login,
                  last_name: profile.name?.split(' ')[1] || '',
                  username: profile.login,
                  is_email_verified: true,
                  image: profile.avatar_url,
                  role: 'professor',
                  status: 'active',
                };
              },
            },
          }
        : {}),
    },
    advanced: {
      database: {
        generateId() {
          return uuid();
        },
      },
      cookiePrefix: authConfig.cookiePrefix,
    },
    // Use Redis for storing sessions
    secondaryStorage: {
      get: async (key) => {
        return (await cacheService.get({ key: 'AccessToken', args: [key] })) ?? null;
      },
      set: async (key, value, ttl) => {
        await cacheService.set(
          { key: 'AccessToken', args: [key] },
          value,
          ttl
            ? {
                ttl: ttl * 1000,
              }
            : {},
        );
      },
      delete: async (key) => {
        await cacheService.delete({ key: 'AccessToken', args: [key] });
      },
    },
    telemetry: {
      enabled: false,
    },
  };
}
