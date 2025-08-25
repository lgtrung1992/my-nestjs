import { Role } from '@/api/user/user.enum';
import { AccountEntity } from '@/auth/entities/account.entity';
import { UserEntity } from '@/auth/entities/user.entity';
import { DataSource } from 'typeorm';
import { Seeder, SeederFactoryManager } from 'typeorm-extension';

// eslint-disable-next-line no-console
const log = (message: string) => console.log(`[Seeder] ${message}`);

export class InitialSeed1732461424212 implements Seeder {
  track = true;

  public async run(
    dataSource: DataSource,
    _: SeederFactoryManager,
  ): Promise<any> {
    log('Starting seeder...');

    await dataSource.transaction(async (transactionManager) => {
      log('Inside transaction...');

      const $userRepository = transactionManager.getRepository(UserEntity);
      const $accountRepository =
        transactionManager.getRepository(AccountEntity);

      log('Creating user...');
      const user = await $userRepository.save(
        $userRepository.create({
          username: 'admin',
          email: 'admin@admin.com',
          role: Role.Admin,
          isEmailVerified: true,
          firstName: 'Admin',
          lastName: 'User',
          status: 'active',
        }),
      );
      log(`User created: ${user.id}`);

      // For security reasons, admin password is not set here.
      // Use reset password feature to set password for this account.
      log('Creating account...');
      await $accountRepository.save(
        $accountRepository.create({
          accountId: user.id,
          userId: user.id,
          providerId: 'credential',
        }),
      );
      log('Account created successfully');
    });

    log('Seeder completed successfully');
  }
}
