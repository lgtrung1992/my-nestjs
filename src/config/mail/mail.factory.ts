import { GlobalConfig } from '@/config/config.type';
import { MailerOptions } from '@nestjs-modules/mailer';
import { HandlebarsAdapter } from '@nestjs-modules/mailer/dist/adapters/handlebars.adapter';
import { TransportType } from '@nestjs-modules/mailer/dist/interfaces/mailer-options.interface';
import { ConfigService } from '@nestjs/config';
import path from 'path';

async function useMailFactory(config: ConfigService<GlobalConfig>): Promise<MailerOptions> {
  const mailUser = config.get('mail.user', { infer: true });
  const mailPassword = config.get('mail.password', { infer: true });

  const transport: TransportType = {
    host: config.get('mail.host', { infer: true }),
    port: config.get('mail.port', { infer: true }),
    ignoreTLS: config.get('mail.ignoreTLS', { infer: true }),
    requireTLS: config.get('mail.requireTLS', { infer: true }),
    secure: config.get('mail.secure', { infer: true }),
    logger: false, // This will be logged via app logger instead.
  };

  // Only add auth if both user and password are provided
  if (mailUser && mailPassword) {
    transport.auth = {
      user: mailUser,
      pass: mailPassword,
    };
  }

  return {
    transport,
    defaults: {
      from: `"${config.get('mail.defaultName', { infer: true })}" <${config.get('mail.defaultEmail', { infer: true })}>`,
    },
    template: {
      dir: path.join(__dirname, '..', '..', 'shared/mail/templates'),
      adapter: new HandlebarsAdapter(),
      options: {
        strict: true,
      },
    },
  };
}

export default useMailFactory;
