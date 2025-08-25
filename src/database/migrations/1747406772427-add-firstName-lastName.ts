import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddFirstNameLastName1747406772427 implements MigrationInterface {
  name = 'AddFirstNameLastName1747406772427';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Fields are now included in the initial migration
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Fields are now included in the initial migration
  }
}
