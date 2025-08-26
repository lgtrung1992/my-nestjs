import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddTwoFactorTable1747577474291 implements MigrationInterface {
  name = 'AddTwoFactorTable1747577474291';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            CREATE TABLE "two_factors" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "created_at" TIMESTAMP NOT NULL DEFAULT now(),
                "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
                "deleted_at" TIMESTAMP,
                "user_id" uuid NOT NULL,
                "secret" character varying,
                "backup_codes" character varying,
                CONSTRAINT "PK_6e6e22172b1e7437f77cbfed056" PRIMARY KEY ("id")
            )
        `);
    await queryRunner.query(`
            ALTER TABLE "two_factors"
            ADD CONSTRAINT "FK_03fe91172968ed69813bc6ff0bd" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION
        `);

    await queryRunner.query(`
            ALTER TABLE "users"
            ADD COLUMN "two_factor_enabled" boolean NULL DEFAULT false
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE "two_factors" DROP CONSTRAINT "FK_03fe91172968ed69813bc6ff0bd"
        `);
    await queryRunner.query(`
            DROP TABLE "two_factors"
        `);
    await queryRunner.query(`
            ALTER TABLE "users" DROP COLUMN "two_factor_enabled"
        `);
  }
}
