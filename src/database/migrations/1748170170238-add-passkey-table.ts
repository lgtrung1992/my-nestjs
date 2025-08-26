import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddPasskeyTable1748170170238 implements MigrationInterface {
  name = 'AddPasskeyTable1748170170238';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            CREATE TABLE "passkeys" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "created_at" TIMESTAMP NOT NULL DEFAULT now(),
                "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
                "deleted_at" TIMESTAMP,
                "name" character varying,
                "user_id" uuid NOT NULL,
                "public_key" character varying NOT NULL,
                "credential_id" character varying NOT NULL,
                "counter" integer NOT NULL,
                "device_type" character varying NOT NULL,
                "backed_up" boolean NOT NULL,
                "transports" character varying NOT NULL,
                "aaguid" character varying NULL,
                CONSTRAINT "PK_783e2060d8025abd6a6ca45d2c7" PRIMARY KEY ("id")
            )
        `);

    await queryRunner.query(`
            ALTER TABLE "passkeys"
            ADD CONSTRAINT "FK_c36f303905314ea9ead857b6268" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE "passkeys" DROP CONSTRAINT "FK_c36f303905314ea9ead857b6268"
        `);
    await queryRunner.query(`
            DROP TABLE "passkeys"
        `);
  }
}
