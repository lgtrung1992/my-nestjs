import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddDisplayUsername1747485461165 implements MigrationInterface {
  name = 'AddDisplayUsername1747485461165';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Username field is now included in the initial migration
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Username field is now included in the initial migration
  }
}
